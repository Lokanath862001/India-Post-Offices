import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'web_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        unawaited(MobileAds.instance.initialize());
      }
    } catch (e) {
      debugPrint('AdMob initialization error: $e');
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'India Post Offices',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF9933), // Indian Saffron
          secondary: Color(0xFF128807), // Indian Green
          surface: Color(0xFF1E293B), // Slate 800
        ),
        useMaterial3: true,
      ),
      home: const PostOfficeFinderScreen(),
    );
  }
}

class PostOfficeFinderScreen extends StatefulWidget {
  const PostOfficeFinderScreen({super.key});

  @override
  State<PostOfficeFinderScreen> createState() => _PostOfficeFinderScreenState();
}

class _PostOfficeFinderScreenState extends State<PostOfficeFinderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, List<dynamic>> _cache = {};
  
  List<dynamic> _offices = [];
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _debounce;
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadBannerAd();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    if (kIsWeb) return;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        _bannerAd = BannerAd(
          adUnitId: 'ca-app-pub-1945844675060188/2608941912',
          request: const AdRequest(),
          size: AdSize.banner,
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isBannerAdReady = true;
              });
            },
            onAdFailedToLoad: (ad, err) {
              debugPrint('Failed to load a banner ad: ${err.message}');
              _isBannerAdReady = false;
              ad.dispose();
            },
          ),
        );
        _bannerAd!.load();
      }
    } catch (e) {
      debugPrint('AdMob load error: $e');
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(_searchController.text);
    });
  }

  // Classification logic for sorting
  int getOfficeRank(Map<String, dynamic> po) {
    final name = (po['Name'] ?? '').toString().toUpperCase();
    final branchType = (po['BranchType'] ?? '').toString().toUpperCase();

    // 1. NSH (National Sorting Hub)
    if (name.contains('NSH') ||
        name.contains('NATIONAL SORTING HUB') ||
        branchType.contains('NSH') ||
        branchType.contains('NATIONAL SORTING HUB')) {
      return 0;
    }
    // 2. Parcel Hubs
    if (name.contains('PARCEL HUB') ||
        name.contains('PARCEL') ||
        branchType.contains('PARCEL HUB') ||
        branchType.contains('PARCEL')) {
      return 1;
    }
    // 3. ICH (Intra Circle Hub)
    if (name.contains('ICH') ||
        name.contains('INTRA-CIRCLE') ||
        name.contains('INTRA CIRCLE') ||
        branchType.contains('ICH')) {
      return 2;
    }
    // 4. TMO (Transit Mail Office)
    if (name.contains('TMO') ||
        name.contains('TRANSIT MAIL OFFICE') ||
        branchType.contains('TMO')) {
      return 3;
    }
    // 5. Mail Offices
    if (name.contains('MAIL OFFICE') ||
        name.contains(' M.O') ||
        name.endsWith(' M.O') ||
        branchType.contains('MAIL OFFICE') ||
        branchType.contains('MAIL')) {
      return 4;
    }
    // 6. L1U
    if (name.contains('L1U') ||
        name.contains('L-1U') ||
        name.contains('L1 U') ||
        name.contains('L-1 U') ||
        name.endsWith(' L1')) {
      return 5;
    }
    // 7. L2U
    if (name.contains('L2U') ||
        name.contains('L-2U') ||
        name.contains('L2 U') ||
        name.contains('L-2 U') ||
        name.endsWith(' L2')) {
      return 6;
    }
    // 8. NDSO
    if (name.contains('NDSO') ||
        name.contains('NEW DELHI SORTING') ||
        branchType.contains('NDSO')) {
      return 7;
    }
    // 9. Postal Directorate
    if (name.contains('DIRECTORATE') ||
        name.contains('POSTAL DIRECTORATE') ||
        branchType.contains('DIRECTORATE')) {
      return 8;
    }
    // 10. Printing Press
    if (name.contains('PRINTING PRESS') ||
        name.contains('POSTAL PRESS') ||
        branchType.contains('PRINTING PRESS')) {
      return 9;
    }
    // 11. Foreign Post
    if (name.contains('FOREIGN POST') ||
        name.contains('FOREIGN MAIL') ||
        branchType.contains('FOREIGN POST') ||
        branchType.contains('FOREIGN MAIL')) {
      return 10;
    }
    // 12. Head Offices
    if (branchType.contains('HEAD') ||
        name.contains('H.O.') ||
        name.endsWith(' H.O') ||
        name.contains(' HPO')) {
      return 11;
    }
    // 13. Sub Offices
    if (branchType.contains('SUB') ||
        name.contains('S.O.') ||
        name.endsWith(' S.O') ||
        name.contains(' SO ')) {
      return 12;
    }
    // 14. Branch Offices
    if (branchType.contains('BRANCH') ||
        name.contains('B.O.') ||
        name.endsWith(' B.O') ||
        name.contains(' BO ')) {
      return 13;
    }
    return 14; // Default
  }

  String getOfficeTypeLabel(Map<String, dynamic> po) {
    final rank = getOfficeRank(po);
    switch (rank) {
      case 0:
        return 'NSH';
      case 1:
        return 'Parcel Hub';
      case 2:
        return 'ICH';
      case 3:
        return 'TMO';
      case 4:
        return 'Mail Office';
      case 5:
        return 'L1U';
      case 6:
        return 'L2U';
      case 7:
        return 'NDSO';
      case 8:
        return 'Directorate';
      case 9:
        return 'Printing Press';
      case 10:
        return 'Foreign Post';
      case 11:
        return 'Head Office';
      case 12:
        return 'Sub Office';
      case 13:
        return 'Branch Office';
      default:
        return po['BranchType'] ?? 'Unknown';
    }
  }

  Color _getBadgeColor(String label) {
    switch (label) {
      case 'NSH':
        return const Color(0xFFFF5722); // Deep Orange
      case 'Parcel Hub':
        return const Color(0xFFE91E63); // Pink
      case 'ICH':
        return const Color(0xFF9C27B0); // Purple
      case 'TMO':
        return const Color(0xFF673AB7); // Deep Purple
      case 'Mail Office':
        return const Color(0xFF3F51B5); // Indigo
      case 'L1U':
        return const Color(0xFF00BCD4); // Cyan
      case 'L2U':
        return const Color(0xFF009688); // Teal
      case 'NDSO':
        return const Color(0xFF4CAF50); // Green
      case 'Directorate':
        return const Color(0xFF8BC34A); // Light Green
      case 'Printing Press':
        return const Color(0xFFCDDC39); // Lime
      case 'Foreign Post':
        return const Color(0xFFFFEB3B); // Yellow
      case 'Head Office':
        return const Color(0xFFFFB300); // Amber
      case 'Sub Office':
        return const Color(0xFF00B0FF); // Light Blue
      case 'Branch Office':
        return const Color(0xFF00E676); // Light Green
      default:
        return Colors.grey;
    }
  }

  Future<void> _performSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _offices = [];
        _isLoading = false;
        _errorMessage = null;
      });
      return;
    }

    final isNumeric = RegExp(r'^\d+$').hasMatch(trimmed);

    // Validate inputs for API call
    if (isNumeric) {
      if (trimmed.length != 6) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please enter a valid 6-digit Pincode';
          _offices = [];
        });
        return;
      }
    } else {
      if (trimmed.length < 3) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please enter at least 3 characters of the Office Name';
          _offices = [];
        });
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final cacheKey = trimmed.toLowerCase();
    if (_cache.containsKey(cacheKey)) {
      setState(() {
        _offices = _cache[cacheKey]!;
        _isLoading = false;
      });
      return;
    }

    try {
      final url = isNumeric
          ? 'https://api.postalpincode.in/pincode/$trimmed'
          : 'https://api.postalpincode.in/postoffice/$trimmed';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final status = data[0]['Status'];
          final message = data[0]['Message'];

          if (status == 'Success') {
            final List<dynamic> postOffices = data[0]['PostOffice'] ?? [];

            // Sort post offices strictly by rank hierarchy, then name
            postOffices.sort((a, b) {
              int rankA = getOfficeRank(a);
              int rankB = getOfficeRank(b);
              if (rankA != rankB) {
                return rankA.compareTo(rankB);
              }
              return (a['Name'] ?? '').toString().compareTo((b['Name'] ?? '').toString());
            });

            _cache[cacheKey] = postOffices;

            setState(() {
              _offices = postOffices;
              _isLoading = false;
            });
          } else {
            setState(() {
              _offices = [];
              _errorMessage = message ?? 'No records found';
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _offices = [];
            _errorMessage = 'Invalid response structure from server';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _offices = [];
          _errorMessage = 'Server returned error code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _offices = [];
        _errorMessage = 'Failed to connect. Please check your internet connection.';
        _isLoading = false;
      });
    }
  }

  Future<void> _exportToExcel() async {
    if (_offices.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final excel = Excel.createExcel();
      final Sheet sheet = excel['India Post Offices'];
      excel.delete('Sheet1');

      // Add header row
      sheet.appendRow([
        TextCellValue('Office Name'),
        TextCellValue('Branch Type'),
        TextCellValue('Pincode'),
        TextCellValue('Division Name'),
        TextCellValue('Region Name'),
        TextCellValue('Circle Name'),
        TextCellValue('District'),
        TextCellValue('State'),
        TextCellValue('Delivery Status')
      ]);

      // Add data rows
      for (final po in _offices) {
        final String name = po['Name'] ?? '';
        final String type = getOfficeTypeLabel(po);
        final String pincode = po['Pincode'] ?? '';
        final String division = po['Division'] ?? '';
        final String region = po['Region'] ?? '';
        final String circle = po['Circle'] ?? '';
        final String district = po['District'] ?? '';
        final String state = po['State'] ?? '';
        final String delivery = po['DeliveryStatus'] ?? '';

        sheet.appendRow([
          TextCellValue(name),
          TextCellValue(type),
          TextCellValue(pincode),
          TextCellValue(division),
          TextCellValue(region),
          TextCellValue(circle),
          TextCellValue(district),
          TextCellValue(state),
          TextCellValue(delivery)
        ]);
      }

      final fileBytes = excel.save();
      if (fileBytes == null) {
        throw Exception('Failed to generate Excel sheet bytes');
      }

      if (kIsWeb) {
        final fileName = 'india_post_offices_${DateTime.now().millisecondsSinceEpoch}.xlsx';
        downloadExcel(fileBytes, fileName);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Excel sheet generated and download started!'),
              backgroundColor: Color(0xFF128807), // Green
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final fileName = 'india_post_offices_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final file = File('${tempDir.path}/$fileName');

      await file.writeAsBytes(fileBytes, flush: true);

      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: 'Exported India Post Offices Search Results');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Excel sheet exported and shared successfully!'),
            backgroundColor: Color(0xFF128807), // Green
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: const Color(0xFFEF4444), // Red
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A), // Slate 900
              Color(0xFF0A0F1D), // Deep dark navy
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildSearchCard(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildContent(),
                      ),
                    ],
                  ),
                ),
              ),
              _buildAdBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdBanner() {
    if (_isBannerAdReady && _bannerAd != null) {
      return Container(
        width: double.infinity,
        height: _bannerAd!.size.height.toDouble(),
        margin: const EdgeInsets.only(top: 8),
        decoration: const BoxDecoration(
          color: Color(0xFF1E293B),
          border: Border(
            top: BorderSide(color: Color(0xFF334155), width: 1),
          ),
        ),
        alignment: Alignment.center,
        child: SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B), // Slate 800
        border: Border(
          top: BorderSide(color: Color(0xFF334155), width: 1), // Slate 700
        ),
      ),
      child: Stack(
        children: [
          // Small "Ad" indicator in the corner
          Positioned(
            left: 8,
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFFB300), width: 1), // Amber
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                'Ad',
                style: TextStyle(
                  color: Color(0xFFFFB300),
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Main Ad Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.campaign,
                    color: Color(0xFFFF9933), // Saffron
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'India Post Speed Post Logistics',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Fast, reliable parcel delivery across India. Send now!',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Mock ad click
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF128807), // Indian Green
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'BOOK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFF9933),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INDIA POST',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'OFFICES DIRECTORY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: const Color(0xFF128807).withOpacity(0.9), // Green
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Search offices by Name or Pincode in real-time',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF94A3B8), // Slate 400
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Slate 800
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF334155), // Slate 700
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Enter 6-digit Pincode or Office Name...',
              hintStyle: const TextStyle(color: Color(0xFF64748B)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFFFF9933)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF94A3B8)),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFF0F172A),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFF9933), width: 1.5),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty && !_isLoading && _errorMessage == null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${min(_offices.length, 50)} results',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (_offices.isNotEmpty)
                  TextButton.icon(
                    onPressed: _exportToExcel,
                    icon: const Icon(Icons.file_download, size: 16, color: Color(0xFFFF9933)),
                    label: const Text(
                      'Export to Excel',
                      style: TextStyle(
                        color: Color(0xFFFF9933),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9933)),
            ),
            const SizedBox(height: 16),
            Text(
              'Searching India Post Database...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, color: Color(0xFFEF4444), size: 48),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFF87171),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchController.text.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_outlined,
                color: Colors.white.withOpacity(0.15),
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                'Ready to Search',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Enter at least 6 digits to search by Pincode, or 3 letters to search by Post Office Name.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_offices.isEmpty) {
      return const Center(
        child: Text(
          'No office matches found.',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
      );
    }

    return _buildResponsiveTable();
  }

  Widget _buildResponsiveTable() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hint banner for horizontal scrolling
          Container(
            color: const Color(0xFF0F172A),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.swap_horizontal_circle_outlined, size: 14, color: Color(0xFFFF9933)),
                SizedBox(width: 6),
                Text(
                  'Swipe horizontally to view more details',
                  style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: const Color(0xFF334155),
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(const Color(0xFF0F172A)),
                    dataRowMinHeight: 52,
                    dataRowMaxHeight: 68,
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Office Name & Type',
                          style: TextStyle(color: Color(0xFFFF9933), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Pincode',
                          style: TextStyle(color: Color(0xFFFF9933), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Division Name',
                          style: TextStyle(color: Color(0xFFFF9933), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Region Name',
                          style: TextStyle(color: Color(0xFFFF9933), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Circle Name',
                          style: TextStyle(color: Color(0xFFFF9933), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                    rows: _offices.map((po) {
                      final String name = po['Name'] ?? '';
                      final String pincode = po['Pincode'] ?? '';
                      final String division = po['Division'] ?? '';
                      final String region = po['Region'] ?? '';
                      final String circle = po['Circle'] ?? '';
                      final String typeLabel = getOfficeTypeLabel(po);
                      final Color badgeColor = _getBadgeColor(typeLabel);
                      final bool isBranchOffice = typeLabel == 'Branch Office';
                      final bool isNonDelivery = (po['DeliveryStatus'] ?? '').toString().trim().toLowerCase() == 'non-delivery';
                      final bool canTriggerPopup = isBranchOffice || isNonDelivery;

                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withOpacity(0.12),
                                    border: Border.all(color: badgeColor.withOpacity(0.8), width: 1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    typeLabel,
                                    style: TextStyle(
                                      color: badgeColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            canTriggerPopup
                                ? Tooltip(
                                    message: 'Show associated Sub Office / Head Office',
                                    child: InkWell(
                                      onTap: () => _showAssociatedOffice(context, pincode),
                                      borderRadius: BorderRadius.circular(4),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                        child: Text(
                                          pincode,
                                          style: const TextStyle(
                                            color: Color(0xFFFF9933), // Saffron
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 0.5,
                                            decoration: TextDecoration.underline,
                                            decorationColor: Color(0xFFFF9933),
                                            decorationThickness: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    pincode,
                                    style: const TextStyle(
                                      color: Color(0xFFFF9933), // Saffron
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                          DataCell(Text(division, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13))),
                          DataCell(Text(region, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13))),
                          DataCell(Text(circle, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAssociatedOffice(BuildContext context, String pincode) async {
    List<dynamic>? officesList = _offices;
    
    bool hasPincodeData = officesList.any((o) => o['Pincode'] == pincode);
    if (!hasPincodeData) {
      final cacheKey = pincode.toLowerCase();
      if (_cache.containsKey(cacheKey)) {
        officesList = _cache[cacheKey];
      } else {
        officesList = null;
      }
    }

    Map<String, dynamic>? associatedOffice;

    if (officesList != null) {
      associatedOffice = _findSOorHO(officesList, pincode);
    }

    if (associatedOffice != null) {
      _displayOfficeDialog(context, associatedOffice);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9933)),
          ),
        );
      },
    );

    try {
      final url = 'https://api.postalpincode.in/pincode/$pincode';
      final response = await http.get(Uri.parse(url));
      
      if (context.mounted) Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty && data[0]['Status'] == 'Success') {
          final List<dynamic> postOffices = data[0]['PostOffice'] ?? [];
          _cache[pincode.toLowerCase()] = postOffices;
          
          associatedOffice = _findSOorHO(postOffices, pincode);
          if (associatedOffice != null && context.mounted) {
            _displayOfficeDialog(context, associatedOffice);
            return;
          }
        }
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No associated Sub Office or Head Office found for Pincode $pincode'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch associated office: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Map<String, dynamic>? _findSOorHO(List<dynamic> list, String pincode) {
    for (final po in list) {
      if (po['Pincode'] == pincode) {
        final label = getOfficeTypeLabel(po);
        if (label == 'Sub Office') return po;
      }
    }
    for (final po in list) {
      if (po['Pincode'] == pincode) {
        final label = getOfficeTypeLabel(po);
        if (label == 'Head Office') return po;
      }
    }
    return null;
  }

  void _displayOfficeDialog(BuildContext context, Map<String, dynamic> po) {
    final String name = po['Name'] ?? 'Unknown';
    final String pincode = po['Pincode'] ?? '';
    final String type = getOfficeTypeLabel(po);
    final String division = po['Division'] ?? 'N/A';
    final String region = po['Region'] ?? 'N/A';
    final String circle = po['Circle'] ?? 'N/A';
    final String district = po['District'] ?? 'N/A';
    final String state = po['State'] ?? 'N/A';
    final String delivery = po['DeliveryStatus'] ?? 'N/A';
    final Color badgeColor = _getBadgeColor(type);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFF1E293B),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9933).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Color(0xFFFF9933),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Associated Main Office',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(color: Color(0xFF334155), height: 1),
                const SizedBox(height: 18),
                _buildDialogRow('Office Type', type, badgeColor: badgeColor),
                const SizedBox(height: 12),
                _buildDialogRow('Pincode', pincode, valueColor: const Color(0xFFFF9933)),
                const SizedBox(height: 12),
                _buildDialogRow('Delivery Status', delivery, 
                  valueColor: delivery.toLowerCase() == 'delivery' ? const Color(0xFF128807) : const Color(0xFFEF4444)),
                const SizedBox(height: 12),
                _buildDialogRow('District', district),
                const SizedBox(height: 12),
                _buildDialogRow('State', state),
                const SizedBox(height: 12),
                _buildDialogRow('Division', division),
                const SizedBox(height: 12),
                _buildDialogRow('Region', region),
                const SizedBox(height: 12),
                _buildDialogRow('Circle', circle),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9933),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Dismiss',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogRow(String label, String value, {Color? valueColor, Color? badgeColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: badgeColor != null
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.12),
                      border: Border.all(color: badgeColor.withOpacity(0.8), width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? const Color(0xFFE2E8F0),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }

  // Quick helper to limit shown items to prevent rendering lag with huge datasets
  int min(int a, int b) => a < b ? a : b;
}
