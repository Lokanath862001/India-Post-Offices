import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'web_helper.dart';

class AppThemeConfig {
  final Brightness brightness;
  final Color primary;
  final Color secondary;
  final Color scaffoldBgStart;
  final Color scaffoldBgEnd;
  final Color cardBg;
  final Color inputFill;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color tableHeaderBg;
  final Color shadow;
  final Color textOnPrimary;

  const AppThemeConfig({
    required this.brightness,
    required this.primary,
    required this.secondary,
    required this.scaffoldBgStart,
    required this.scaffoldBgEnd,
    required this.cardBg,
    required this.inputFill,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.tableHeaderBg,
    required this.shadow,
    this.textOnPrimary = Colors.white,
  });
}

final Map<String, AppThemeConfig> appThemes = {
  'light': const AppThemeConfig(
    brightness: Brightness.light,
    primary: Color(0xFFFF9933),
    secondary: Color(0xFF128807),
    scaffoldBgStart: Color(0xFFF8FAFC),
    scaffoldBgEnd: Color(0xFFE2E8F0),
    cardBg: Color(0xFFFFFFFF),
    inputFill: Color(0xFFF1F5F9),
    border: Color(0xFFCBD5E1),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textHint: Color(0xFF94A3B8),
    tableHeaderBg: Color(0xFFE2E8F0),
    shadow: Color(0x0C000000),
    textOnPrimary: Colors.white,
  ),
  'dark': const AppThemeConfig(
    brightness: Brightness.dark,
    primary: Color(0xFFFF9933),
    secondary: Color(0xFF128807),
    scaffoldBgStart: Color(0xFF0F172A),
    scaffoldBgEnd: Color(0xFF0A0F1D),
    cardBg: Color(0xFF1E293B),
    inputFill: Color(0xFF0F172A),
    border: Color(0xFF334155),
    textPrimary: Colors.white,
    textSecondary: Color(0xFF94A3B8),
    textHint: Color(0xFF64748B),
    tableHeaderBg: Color(0xFF0F172A),
    shadow: Color(0x33000000),
    textOnPrimary: Colors.white,
  ),
  'red': const AppThemeConfig(
    brightness: Brightness.dark,
    primary: Color(0xFFEF4444),
    secondary: Color(0xFF10B981),
    scaffoldBgStart: Color(0xFF2C0F10),
    scaffoldBgEnd: Color(0xFF1A0809),
    cardBg: Color(0xFF3F1416),
    inputFill: Color(0xFF2C0F10),
    border: Color(0xFF631D21),
    textPrimary: Colors.white,
    textSecondary: Color(0xFFFCA5A5),
    textHint: Color(0xFFB91C1C),
    tableHeaderBg: Color(0xFF2C0F10),
    shadow: Color(0x4D000000),
    textOnPrimary: Colors.white,
  ),
  'orange': const AppThemeConfig(
    brightness: Brightness.dark,
    primary: Color(0xFFFF9933),
    secondary: Color(0xFF128807),
    scaffoldBgStart: Color(0xFF2E1205),
    scaffoldBgEnd: Color(0xFF1A0A02),
    cardBg: Color(0xFF451A03),
    inputFill: Color(0xFF2E1205),
    border: Color(0xFF6C2505),
    textPrimary: Colors.white,
    textSecondary: Color(0xFFFFD0B0),
    textHint: Color(0xFFB45309),
    tableHeaderBg: Color(0xFF2E1205),
    shadow: Color(0x4D000000),
    textOnPrimary: Colors.white,
  ),
  'yellow': const AppThemeConfig(
    brightness: Brightness.dark,
    primary: Color(0xFFFBBF24),
    secondary: Color(0xFF10B981),
    scaffoldBgStart: Color(0xFF241C03),
    scaffoldBgEnd: Color(0xFF140F01),
    cardBg: Color(0xFF382B05),
    inputFill: Color(0xFF241C03),
    border: Color(0xFF5C4708),
    textPrimary: Colors.white,
    textSecondary: Color(0xFFFDE68A),
    textHint: Color(0xFFB45309),
    tableHeaderBg: Color(0xFF241C03),
    shadow: Color(0x4D000000),
    textOnPrimary: Colors.white,
  ),
  'green': const AppThemeConfig(
    brightness: Brightness.dark,
    primary: Color(0xFF00C853),
    secondary: Color(0xFFFF9933),
    scaffoldBgStart: Color(0xFF04211A),
    scaffoldBgEnd: Color(0xFF02120E),
    cardBg: Color(0xFF0B3A30),
    inputFill: Color(0xFF04211A),
    border: Color(0xFF125E4F),
    textPrimary: Colors.white,
    textSecondary: Color(0xFFA7F3D0),
    textHint: Color(0xFF1B6B5D),
    tableHeaderBg: Color(0xFF04211A),
    shadow: Color(0x4D000000),
    textOnPrimary: Colors.white,
  ),
  'blue': const AppThemeConfig(
    brightness: Brightness.dark,
    primary: Color(0xFF0EA5E9),
    secondary: Color(0xFFFF9933),
    scaffoldBgStart: Color(0xFF03253A),
    scaffoldBgEnd: Color(0xFF011420),
    cardBg: Color(0xFF073857),
    inputFill: Color(0xFF03253A),
    border: Color(0xFF0A5889),
    textPrimary: Colors.white,
    textSecondary: Color(0xFF7DD3FC),
    textHint: Color(0xFF0284C7),
    tableHeaderBg: Color(0xFF03253A),
    shadow: Color(0x4D000000),
    textOnPrimary: Colors.white,
  ),
  'indigo': const AppThemeConfig(
    brightness: Brightness.dark,
    primary: Color(0xFF6366F1),
    secondary: Color(0xFF00D2FF),
    scaffoldBgStart: Color(0xFF071F30),
    scaffoldBgEnd: Color(0xFF030D16),
    cardBg: Color(0xFF0D324D),
    inputFill: Color(0xFF071F30),
    border: Color(0xFF1A5276),
    textPrimary: Colors.white,
    textSecondary: Color(0xFFBAE6FD),
    textHint: Color(0xFF5992B1),
    tableHeaderBg: Color(0xFF071F30),
    shadow: Color(0x4D000000),
    textOnPrimary: Colors.white,
  ),
  'violet': const AppThemeConfig(
    brightness: Brightness.dark,
    primary: Color(0xFFC084FC),
    secondary: Color(0xFFFF9933),
    scaffoldBgStart: Color(0xFF200F35),
    scaffoldBgEnd: Color(0xFF120820),
    cardBg: Color(0xFF321752),
    inputFill: Color(0xFF200F35),
    border: Color(0xFF55258C),
    textPrimary: Colors.white,
    textSecondary: Color(0xFFE9D5FF),
    textHint: Color(0xFF9333EA),
    tableHeaderBg: Color(0xFF200F35),
    shadow: Color(0x4D000000),
    textOnPrimary: Colors.white,
  ),
};

final ValueNotifier<String> themeNotifier = ValueNotifier<String>('dark');

AppThemeConfig get currentTheme => appThemes[themeNotifier.value] ?? appThemes['dark']!;

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

  // Load saved theme
  String savedTheme = 'dark';
  try {
    final prefs = await SharedPreferences.getInstance();
    savedTheme = prefs.getString('app_theme') ?? 'dark';
  } catch (e) {
    debugPrint('Error loading saved theme: $e');
  }
  themeNotifier.value = savedTheme;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: themeNotifier,
      builder: (context, themeKey, child) {
        final themeConfig = appThemes[themeKey] ?? appThemes['dark']!;
        return MaterialApp(
          title: 'India Post Offices',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: themeConfig.brightness,
            scaffoldBackgroundColor: themeConfig.scaffoldBgStart,
            colorScheme: ColorScheme.fromSeed(
              seedColor: themeConfig.primary,
              brightness: themeConfig.brightness,
              primary: themeConfig.primary,
              secondary: themeConfig.secondary,
              surface: themeConfig.cardBg,
            ),
            useMaterial3: true,
          ),
          home: const PostOfficeFinderScreen(),
        );
      },
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
  List<Map<String, dynamic>> _localOfficesData = [];
  int _searchCount = 0;
  String _selectedOfficeTypeFilter = 'All Offices';
  bool _isLoading = false;

  List<dynamic> get _displayOffices {
    if (_selectedOfficeTypeFilter == 'All Offices' || _selectedOfficeTypeFilter == 'All') return _offices;

    return _offices.where((po) {
      final typeLabel = getOfficeTypeLabel(po).toUpperCase();
      final hub = (po['HubLevel'] ?? po['hubLevel'] ?? '').toString().toUpperCase();
      final l1 = (po['L1OfficeName'] ?? po['l1OfficeName'] ?? '').toString().toUpperCase();
      final l2 = (po['L2OfficeName'] ?? po['l2OfficeName'] ?? '').toString().toUpperCase();
      final name = (po['Name'] ?? po['name'] ?? '').toString().toUpperCase();
      final branchType = (po['BranchType'] ?? '').toString().toUpperCase();

      if (_selectedOfficeTypeFilter == 'NSH') {
        return l1.contains('NSH') || l2.contains('NSH') || name.contains('NSH') || typeLabel.contains('NSH') || branchType.contains('NSH');
      }
      if (_selectedOfficeTypeFilter == 'ICH') {
        return l1.contains('ICH') || l2.contains('ICH') || name.contains('ICH') || typeLabel.contains('ICH') || branchType.contains('ICH');
      }
      if (_selectedOfficeTypeFilter == 'PH') {
        return l1.contains('PH') || l2.contains('PH') || name.contains(' PH') || name.endsWith('PH') || typeLabel.contains('PH') || branchType.contains('PH');
      }
      if (_selectedOfficeTypeFilter == 'L1 Offices') {
        return hub == 'L1' || typeLabel.contains('L1');
      }
      if (_selectedOfficeTypeFilter == 'L2 Offices') {
        return hub == 'L2' || typeLabel.contains('L2');
      }
      if (_selectedOfficeTypeFilter == 'Head Office') {
        return typeLabel == 'HEAD OFFICE' || getOfficeRank(po) == 0;
      }
      if (_selectedOfficeTypeFilter == 'Sub Office') {
        return typeLabel == 'SUB OFFICE' || getOfficeRank(po) == 1;
      }
      if (_selectedOfficeTypeFilter == 'Branch Office') {
        return typeLabel == 'BRANCH OFFICE' || getOfficeRank(po) == 2;
      }
      return true;
    }).toList();
  }
  String? _errorMessage;
  Timer? _debounce;
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  late FlutterTts _flutterTts;
  bool _isSpeaking = false;
  bool _isTtsInitialized = false;
  int _currentlyReadingIndex = -1;
  Completer<void>? _speechCompleter;

  static const String _localVersion = '1.0.5';
  static const int _localBuild = 6;

  bool _showUpdatePrompt = false;
  Map<String, dynamic>? _remoteVersionData;

  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(_onThemeChanged);
    _searchController.addListener(_onSearchChanged);
    _loadLocalOffices();
    _loadBannerAd();
    _loadInterstitialAd();
    _checkAppVersion();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _changeTheme(String key) {
    if (appThemes.containsKey(key)) {
      themeNotifier.value = key;
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('app_theme', key);
      });
    }
  }

  @override
  void dispose() {
    themeNotifier.removeListener(_onThemeChanged);
    if (_isTtsInitialized) {
      _flutterTts.stop();
    }
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    if (kIsWeb) return;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        _bannerAd = BannerAd(
          adUnitId: 'ca-app-pub-1945844675060188/3998004613',
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

  void _loadInterstitialAd() {
    if (kIsWeb) return;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        InterstitialAd.load(
          adUnitId: 'ca-app-pub-1945844675060188/6175631304',
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              _interstitialAd = ad;
              _isInterstitialAdLoaded = true;
            },
            onAdFailedToLoad: (err) {
              debugPrint('Failed to load InterstitialAd: ${err.message}');
              _interstitialAd = null;
              _isInterstitialAdLoaded = false;
            },
          ),
        );
      }
    } catch (e) {
      debugPrint('Interstitial load error: $e');
    }
  }

  void _showInterstitialAdIfAvailable(VoidCallback onComplete) {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
          onComplete();
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
          onComplete();
        },
      );
      _interstitialAd!.show();
    } else {
      onComplete();
    }
  }

  Future<void> _checkAppVersion() async {
    const String remoteUrl = 'https://raw.githubusercontent.com/Lokanath862001/India-Post-Offices/main/version.json';

    try {
      final response = await http.get(Uri.parse(remoteUrl)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final int latestBuild = data['latest_build'] ?? 1;
        final String latestVersion = data['latest_version'] ?? '';
        
        bool isUpdateAvailable = latestBuild > _localBuild;
        if (!isUpdateAvailable && latestVersion.isNotEmpty && latestVersion != _localVersion) {
          isUpdateAvailable = true;
        }

        if (isUpdateAvailable && mounted) {
          setState(() {
            _remoteVersionData = data;
            _showUpdatePrompt = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Version check error: $e');
    }
  }

  Future<void> _launchUpdateUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open store: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Widget _buildUpdatePromptScreen() {
    final String latestVersion = _remoteVersionData?['latest_version'] ?? '1.0.4';
    final String releaseNotes = _remoteVersionData?['release_notes'] ?? 'New features, security updates, and performance optimizations are available.';
    final String storeUrl = _remoteVersionData?['play_store_url'] ?? 'https://play.google.com/store/apps/details?id=com.oedc.indiaPostOffices';

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                currentTheme.scaffoldBgStart,
                currentTheme.scaffoldBgEnd,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          currentTheme.primary.withOpacity(0.25),
                          currentTheme.secondary.withOpacity(0.25),
                        ],
                      ),
                      border: Border.all(
                        color: currentTheme.primary.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.system_update_rounded,
                      size: 72,
                      color: currentTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.5)),
                    ),
                    child: const Text(
                      'MANDATORY UPDATE REQUIRED',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'App Update Required',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: currentTheme.brightness == Brightness.light ? currentTheme.textPrimary : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A new release of India Post Offices is available on Google Play. Access to installed older versions has been disabled to ensure security and compliance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.4,
                      color: currentTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: currentTheme.border.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Installed: v$_localVersion',
                          style: TextStyle(fontSize: 12, color: currentTheme.textHint, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: currentTheme.secondary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: currentTheme.secondary.withOpacity(0.4)),
                        ),
                        child: Text(
                          'Latest: v$latestVersion',
                          style: TextStyle(fontSize: 12, color: currentTheme.secondary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "What's New in this Release:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: currentTheme.brightness == Brightness.light ? currentTheme.textPrimary : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 160),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: currentTheme.cardBg.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: currentTheme.border.withOpacity(0.5),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        releaseNotes,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: currentTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            colors: [
                              currentTheme.primary,
                              currentTheme.primary.withRed(255).withGreen(140),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: currentTheme.primary.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => _launchUpdateUrl(storeUrl),
                          icon: const Icon(Icons.get_app_rounded, size: 22),
                          label: const Text(
                            'Update Now on Play Store',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: _checkAppVersion,
                        icon: Icon(Icons.refresh_rounded, size: 16, color: currentTheme.textSecondary),
                        label: Text(
                          'Already Updated? Check Status',
                          style: TextStyle(
                            fontSize: 13,
                            color: currentTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(_searchController.text);
    });
  }

  Future<void> _loadLocalOffices() async {
    if (_localOfficesData.isNotEmpty) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/otheroffices/other_offices.json');
      final List<dynamic> parsed = jsonDecode(jsonStr);
      _localOfficesData = parsed.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error loading local offices JSON: $e');
    }
  }

  Map<String, dynamic> _formatLocalOffice(Map<String, dynamic> item) {
    final l1 = (item['l1OfficeName'] ?? '').toString().trim();
    final l2 = (item['l2OfficeName'] ?? '').toString().trim();
    final hub = (item['hubLevel'] ?? '').toString().trim();
    final circle = (item['circleName'] ?? '').toString().trim();
    final fromPin = (item['fromPin'] ?? '').toString().trim();
    final toPin = (item['toPin'] ?? '').toString().trim();
    final sortplanId = (item['sortplanId'] ?? '').toString().trim();

    final pinDisplay = (fromPin == toPin || toPin.isEmpty) ? fromPin : '$fromPin - $toPin';
    final nameDisplay = l2.isNotEmpty ? '$l2 ($l1)' : l1;

    return {
      'isLocal': true,
      'Name': nameDisplay,
      'Pincode': pinDisplay,
      'Division': l2.isNotEmpty ? l2 : l1,
      'Region': '$l1 (Hub: $hub)',
      'Circle': circle,
      'BranchType': hub.isNotEmpty ? 'Local ($hub)' : 'Local Data',
      'SortplanId': sortplanId,
      'L1OfficeName': l1,
      'L2OfficeName': l2,
      'HubLevel': hub,
      'FromPin': fromPin,
      'ToPin': toPin,
      'DeliveryStatus': 'Local Data',
      'District': l2.isNotEmpty ? l2 : l1,
      'State': circle,
    };
  }

  List<Map<String, dynamic>> _searchLocalOfficesByPin(String query) {
    if (_localOfficesData.isEmpty) return [];

    final int? qMin = int.tryParse(query.padRight(6, '0'));
    final int? qMax = int.tryParse(query.padRight(6, '9'));

    final List<Map<String, dynamic>> results = [];

    for (final item in _localOfficesData) {
      final String fpStr = (item['fromPin'] ?? '').toString().trim();
      final String tpStr = (item['toPin'] ?? '').toString().trim();
      final int? fp = int.tryParse(fpStr);
      final int? tp = int.tryParse(tpStr);

      bool isMatch = false;
      if (qMin != null && qMax != null && fp != null && tp != null) {
        if (fp <= qMax && tp >= qMin) {
          isMatch = true;
        }
      }
      if (!isMatch) {
        if (fpStr.startsWith(query) || tpStr.startsWith(query)) {
          isMatch = true;
        }
      }

      if (isMatch) {
        results.add(_formatLocalOffice(item));
      }
    }

    return results;
  }

  List<Map<String, dynamic>> _searchLocalOfficesByText(String query) {
    if (_localOfficesData.isEmpty) return [];

    final String q = query.toLowerCase();
    final List<Map<String, dynamic>> results = [];

    for (final item in _localOfficesData) {
      final String l1 = (item['l1OfficeName'] ?? '').toString().toLowerCase();
      final String l2 = (item['l2OfficeName'] ?? '').toString().toLowerCase();
      final String circle = (item['circleName'] ?? '').toString().toLowerCase();

      if (l1.contains(q) || l2.contains(q) || circle.contains(q)) {
        results.add(_formatLocalOffice(item));
      }
    }

    return results;
  }

  // Classification logic for sorting
  int getOfficeRank(Map<String, dynamic> po) {
    if (po['isLocal'] == true) return -2;
    final name = (po['Name'] ?? '').toString().toUpperCase();
    final branchType = (po['BranchType'] ?? '').toString().toUpperCase();

    // 1. Head Offices
    if (branchType.contains('HEAD') ||
        name.contains('H.O.') ||
        name.endsWith(' H.O') ||
        name.contains(' HPO')) {
      return 0;
    }
    // 2. Sub Offices
    if (branchType.contains('SUB') ||
        name.contains('S.O.') ||
        name.endsWith(' S.O') ||
        name.contains(' SO ')) {
      return 1;
    }
    // 3. Branch Offices
    if (branchType.contains('BRANCH') ||
        name.contains('B.O.') ||
        name.endsWith(' B.O') ||
        name.contains(' BO ')) {
      return 2;
    }
    return -1; // Excluded types
  }

  String getOfficeTypeLabel(Map<String, dynamic> po) {
    if (po['isLocal'] == true) {
      final hub = po['HubLevel'] ?? '';
      return hub.isNotEmpty ? 'Local ($hub)' : 'Local Data';
    }
    final rank = getOfficeRank(po);
    switch (rank) {
      case 0:
        return 'Head Office';
      case 1:
        return 'Sub Office';
      case 2:
        return 'Branch Office';
      default:
        return po['BranchType'] ?? 'Unknown';
    }
  }

  Color _getBadgeColor(String label) {
    if (label.startsWith('Local')) {
      return const Color(0xFFAB47BC); // Purple / Magenta for local dataset matches
    }
    switch (label) {
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

  List<dynamic> _deduplicateOffices(List<dynamic> list) {
    final List<dynamic> uniqueList = [];
    final Set<String> seenKeys = {};

    for (final po in list) {
      final name = (po['Name'] ?? '').toString().trim().toLowerCase();
      final pin = (po['Pincode'] ?? '').toString().trim().toLowerCase();
      final type = getOfficeTypeLabel(po).trim().toLowerCase();
      final key = '$name|$pin|$type';

      if (!seenKeys.contains(key)) {
        seenKeys.add(key);
        uniqueList.add(po);
      }
    }

    return uniqueList;
  }

  void _setSearchResults(String cacheKey, List<dynamic> results) {
    _cache[cacheKey] = results;
    setState(() {
      _offices = results;
      _isLoading = false;
    });

    if (results.isNotEmpty) {
      _searchCount++;
      if (_searchCount % 10 == 0) {
        _showInterstitialAdIfAvailable(() {});
      }
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

    await _loadLocalOffices();

    final isNumeric = RegExp(r'^\d+$').hasMatch(trimmed);

    // Validate inputs
    if (isNumeric) {
      if (trimmed.length < 3) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please enter at least 3 digits of Pincode';
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
      _setSearchResults(cacheKey, _cache[cacheKey]!);
      return;
    }

    try {
      if (isNumeric) {
        final List<Map<String, dynamic>> localMatches = _searchLocalOfficesByPin(trimmed);

        if (trimmed.length == 6) {
          // Fetch 6-digit pincode API data
          final url = 'https://api.postalpincode.in/pincode/$trimmed';
          final response = await http.get(Uri.parse(url));

          List<dynamic> apiFilteredOffices = [];
          if (response.statusCode == 200) {
            final List<dynamic> data = jsonDecode(response.body);
            if (data.isNotEmpty && data[0]['Status'] == 'Success') {
              final List<dynamic> postOffices = data[0]['PostOffice'] ?? [];
              apiFilteredOffices = postOffices.where((po) {
                final rank = getOfficeRank(po);
                return rank >= 0;
              }).toList();

              apiFilteredOffices.sort((a, b) {
                int rankA = getOfficeRank(a);
                int rankB = getOfficeRank(b);
                if (rankA != rankB) {
                  return rankA.compareTo(rankB);
                }
                return (a['Name'] ?? '').toString().compareTo((b['Name'] ?? '').toString());
              });
            }
          }

          // Combine: Local data FIRST, then HO, SO, and BO from API, deduplicated for a unique offices list
          final List<dynamic> combined = _deduplicateOffices([...localMatches, ...apiFilteredOffices]);

          if (combined.isNotEmpty) {
            _setSearchResults(cacheKey, combined);
          } else {
            setState(() {
              _offices = [];
              _errorMessage = 'No matches found for Pincode $trimmed';
              _isLoading = false;
            });
          }
        } else {
          // 3, 4, or 5 digit pincode search -> display local matches
          final List<dynamic> combined = _deduplicateOffices(localMatches);
          if (combined.isNotEmpty) {
            _setSearchResults(cacheKey, combined);
          } else {
            setState(() {
              _offices = [];
              _errorMessage = 'No local matches found for Pincode prefix "$trimmed"';
              _isLoading = false;
            });
          }
        }
      } else {
        // Text query
        final List<Map<String, dynamic>> localMatches = _searchLocalOfficesByText(trimmed);

        final url = 'https://api.postalpincode.in/postoffice/$trimmed';
        final response = await http.get(Uri.parse(url));

        List<dynamic> apiFilteredOffices = [];
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          if (data.isNotEmpty && data[0]['Status'] == 'Success') {
            final List<dynamic> postOffices = data[0]['PostOffice'] ?? [];
            apiFilteredOffices = postOffices.where((po) {
              final rank = getOfficeRank(po);
              return rank >= 0;
            }).toList();

            apiFilteredOffices.sort((a, b) {
              int rankA = getOfficeRank(a);
              int rankB = getOfficeRank(b);
              if (rankA != rankB) {
                return rankA.compareTo(rankB);
              }
              return (a['Name'] ?? '').toString().compareTo((b['Name'] ?? '').toString());
            });
          }
        }

        final List<dynamic> combined = _deduplicateOffices([...localMatches, ...apiFilteredOffices]);

        if (combined.isNotEmpty) {
          _setSearchResults(cacheKey, combined);
        } else {
          setState(() {
            _offices = [];
            _errorMessage = 'No records found for "$trimmed"';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      final localMatches = isNumeric
          ? _searchLocalOfficesByPin(trimmed)
          : _searchLocalOfficesByText(trimmed);

      final combined = _deduplicateOffices(localMatches);

      if (combined.isNotEmpty) {
        _setSearchResults(cacheKey, combined);
      } else {
        setState(() {
          _offices = [];
          _errorMessage = 'Failed to connect. Please check your internet connection.';
          _isLoading = false;
        });
      }
    }
  }

  void _handleExportWithAd() {
    if (_displayOffices.isEmpty) return;
    _showInterstitialAdIfAvailable(() {
      _exportToExcel();
    });
  }

  Future<void> _exportToExcel() async {
    if (_displayOffices.isEmpty) return;

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
      for (final po in _displayOffices) {
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

  Future<void> _initTts() async {
    if (_isTtsInitialized) return;
    _flutterTts = FlutterTts();

    _flutterTts.setStartHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = true;
        });
      }
    });

    _flutterTts.setCompletionHandler(() {
      if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
        _speechCompleter!.complete();
      }
    });

    _flutterTts.setCancelHandler(() {
      if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
        _speechCompleter!.complete();
      }
    });

    _flutterTts.setErrorHandler((msg) {
      if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
        _speechCompleter!.complete();
      }
    });

    try {
      await _flutterTts.setSpeechRate(0.45);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setLanguage('en-IN');
      await _flutterTts.awaitSpeakCompletion(true);
    } catch (_) {}

    _isTtsInitialized = true;
  }

  Future<void> _stopDictation() async {
    _isSpeaking = false;
    if (_speechCompleter != null && !_speechCompleter!.isCompleted) {
      _speechCompleter!.complete();
    }
    if (_isTtsInitialized) {
      await _flutterTts.stop();
    }
    if (mounted) {
      setState(() {
        _currentlyReadingIndex = -1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dictation stopped'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  bool _areAllOfficesSamePincode(List<dynamic> list) {
    if (list.length <= 1) return true;
    final firstPin = list[0]['Pincode'];
    return list.every((po) => po['Pincode'] == firstPin);
  }

  String _formatPincodeDigitByDigit(String pincode) {
    final cleanPin = pincode.replaceAll(RegExp(r'\D'), '');
    if (cleanPin.isEmpty) return pincode;
    return cleanPin.split('').join(', ');
  }

  Future<void> _dictateTableData() async {
    if (_displayOffices.isEmpty) return;

    if (!_isTtsInitialized) {
      await _initTts();
    }

    if (_isSpeaking && _currentlyReadingIndex == -1) {
      await _stopDictation();
      return;
    }

    _showInterstitialAdIfAvailable(() {
      _startDictatingTableData();
    });
  }

  Future<void> _startDictatingTableData() async {
    final int count = _displayOffices.length;
    final int limit = min(count, 50);

    setState(() {
      _isSpeaking = true;
      _currentlyReadingIndex = -1;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.record_voice_over, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(child: Text('Dictating resulted table data... Tap Read / Dictate button again to stop.')),
            ],
          ),
          backgroundColor: const Color(0xFF128807),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    final bool isSamePincode = _areAllOfficesSamePincode(_displayOffices);

    try {
      if (isSamePincode) {
        // --- SAME PINCODE LIST ---
        // Find the primary upper office (Head Office or highest rank office)
        final upperOffice = _displayOffices.firstWhere(
          (po) => getOfficeRank(po) <= 1,
          orElse: () => _displayOffices[0],
        );
        final int upperIndex = _displayOffices.indexOf(upperOffice);

        final String upperName = upperOffice['Name'] ?? '';
        final String upperPin = upperOffice['Pincode'] ?? '';
        final String formattedPin = _formatPincodeDigitByDigit(upperPin);

        // Step 1: Read the upper office name then pincode digit-by-digit
        setState(() {
          _currentlyReadingIndex = upperIndex;
        });

        String firstSpeech = upperName;
        if (formattedPin.isNotEmpty) {
          firstSpeech += ', Pincode $formattedPin.';
        } else {
          firstSpeech += '.';
        }

        _speechCompleter = Completer<void>();
        await _flutterTts.speak(firstSpeech);
        await _speechCompleter!.future.timeout(
          const Duration(seconds: 12),
          onTimeout: () {},
        );

        if (!_isSpeaking || !mounted) return;
        await Future.delayed(const Duration(seconds: 1));

        // Step 2: Read lower office name then upper office name sequentially for each record
        for (int i = 0; i < limit; i++) {
          if (!_isSpeaking || !mounted) break;

          final po = _displayOffices[i];
          if (po == upperOffice) continue; // Upper office was already read first with pincode

          setState(() {
            _currentlyReadingIndex = i;
          });

          final String lowerName = po['Name'] ?? '';
          String assocUpperName = upperName;

          final String pincode = po['Pincode'] ?? '';
          final cacheKey = pincode.toLowerCase();
          List<dynamic>? searchList = _cache[cacheKey] ?? _displayOffices;

          for (final item in searchList) {
            if (item['Pincode'] == pincode && item['Name'] != lowerName) {
              final rank = getOfficeRank(item);
              if (rank < getOfficeRank(po)) {
                assocUpperName = item['Name'] ?? upperName;
                break;
              }
            }
          }

          String speechText = '$lowerName, $assocUpperName.';

          _speechCompleter = Completer<void>();
          await _flutterTts.speak(speechText);
          await _speechCompleter!.future.timeout(
            const Duration(seconds: 12),
            onTimeout: () {},
          );

          if (!_isSpeaking || !mounted) break;
          await Future.delayed(const Duration(seconds: 1));
        }
      } else {
        // --- DIFFERENT PINCODES LIST ---
        // Read office name and associated pincode (digit by digit) for each office record
        for (int i = 0; i < limit; i++) {
          if (!_isSpeaking || !mounted) break;

          setState(() {
            _currentlyReadingIndex = i;
          });

          final po = _displayOffices[i];
          final String name = po['Name'] ?? '';
          final String pincode = po['Pincode'] ?? '';
          final String formattedPin = _formatPincodeDigitByDigit(pincode);

          String speechText = name;
          if (formattedPin.isNotEmpty) {
            speechText += ', Pincode $formattedPin.';
          } else {
            speechText += '.';
          }

          _speechCompleter = Completer<void>();
          await _flutterTts.speak(speechText);
          await _speechCompleter!.future.timeout(
            const Duration(seconds: 12),
            onTimeout: () {},
          );

          if (!_isSpeaking || !mounted) break;
          await Future.delayed(const Duration(seconds: 1));
        }
      }
    } catch (e) {
      debugPrint('TTS Dictation error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _currentlyReadingIndex = -1;
        });
      }
    }
  }

  Future<void> _dictateSingleOffice(Map<String, dynamic> po, int index) async {
    if (!_isTtsInitialized) {
      await _initTts();
    }

    if (_isSpeaking && _currentlyReadingIndex == index) {
      await _stopDictation();
      return;
    }

    _showInterstitialAdIfAvailable(() {
      _startDictatingSingleOffice(po, index);
    });
  }

  Future<void> _startDictatingSingleOffice(Map<String, dynamic> po, int index) async {
    final String name = po['Name'] ?? '';
    final String pincode = po['Pincode'] ?? '';
    final String formattedPin = _formatPincodeDigitByDigit(pincode);

    String speech = '$name, Pincode $formattedPin.';

    if (mounted) {
      setState(() {
        _isSpeaking = true;
        _currentlyReadingIndex = index;
      });
    }

    await _flutterTts.speak(speech);
  }

  @override
  Widget build(BuildContext context) {
    if (_showUpdatePrompt) {
      return _buildUpdatePromptScreen();
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              currentTheme.scaffoldBgStart,
              currentTheme.scaffoldBgEnd,
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

  Widget _buildThemeSelector() {
    final themes = [
      {'key': 'light', 'color': const Color(0xFFF1F5F9), 'label': 'Light'},
      {'key': 'dark', 'color': const Color(0xFF0F172A), 'label': 'Dark'},
      {'key': 'blue', 'color': const Color(0xFF0EA5E9), 'label': 'Blue'},
      {'key': 'green', 'color': const Color(0xFF00C853), 'label': 'Green'},
      {'key': 'orange', 'color': const Color(0xFFFF9933), 'label': 'Orange'},
      {'key': 'red', 'color': const Color(0xFFEF4444), 'label': 'Red'},
      {'key': 'yellow', 'color': const Color(0xFFFBBF24), 'label': 'Yellow'},
      {'key': 'violet', 'color': const Color(0xFFC084FC), 'label': 'Violet'},
      {'key': 'indigo', 'color': const Color(0xFF6366F1), 'label': 'Indigo'},
    ];

    return ValueListenableBuilder<String>(
      valueListenable: themeNotifier,
      builder: (context, currentKey, child) {
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: themes.map((theme) {
            final String key = theme['key'] as String;
            final Color color = theme['color'] as Color;
            final String label = theme['label'] as String;
            final bool isSelected = currentKey == key;

            return GestureDetector(
              onTap: () => _changeTheme(key),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? currentTheme.primary : Colors.transparent,
                    width: 2.0,
                  ),
                ),
                child: Tooltip(
                  message: '$label Theme',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: key == 'light' ? const Color(0xFF94A3B8) : Colors.transparent,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 14,
                            color: key == 'light' ? Colors.black : Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildThemeSelectorGrid() {
    final themesList = [
      {'key': 'light', 'name': 'Light Mode', 'color': const Color(0xFFF8FAFC), 'primary': const Color(0xFFFF9933)},
      {'key': 'dark', 'name': 'Dark Slate', 'color': const Color(0xFF0F172A), 'primary': const Color(0xFFFF9933)},
      {'key': 'blue', 'name': 'Ocean Blue', 'color': const Color(0xFF03253A), 'primary': const Color(0xFF0EA5E9)},
      {'key': 'green', 'name': 'Emerald Green', 'color': const Color(0xFF04211A), 'primary': const Color(0xFF00C853)},
      {'key': 'orange', 'name': 'Amber Orange', 'color': const Color(0xFF2E1205), 'primary': const Color(0xFFFF9933)},
      {'key': 'red', 'name': 'Crimson Red', 'color': const Color(0xFF2C0F10), 'primary': const Color(0xFFEF4444)},
      {'key': 'yellow', 'name': 'Royal Yellow', 'color': const Color(0xFF241C03), 'primary': const Color(0xFFFBBF24)},
      {'key': 'violet', 'name': 'Deep Violet', 'color': const Color(0xFF200F35), 'primary': const Color(0xFFC084FC)},
      {'key': 'indigo', 'name': 'Indigo Blue', 'color': const Color(0xFF071F30), 'primary': const Color(0xFF6366F1)},
    ];

    return ValueListenableBuilder<String>(
      valueListenable: themeNotifier,
      builder: (context, currentKey, child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.05,
          ),
          itemCount: themesList.length,
          itemBuilder: (context, index) {
            final item = themesList[index];
            final String key = item['key'] as String;
            final String name = item['name'] as String;
            final Color bgColor = item['color'] as Color;
            final Color primaryColor = item['primary'] as Color;
            final bool isSelected = currentKey == key;

            return InkWell(
              onTap: () => _changeTheme(key),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? primaryColor : currentTheme.border,
                    width: isSelected ? 2.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 3,
                                )
                              ],
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 13, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: key == 'light' ? Colors.black87 : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.star, size: 9, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showThemeSelectorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<String>(
          valueListenable: themeNotifier,
          builder: (context, currentKey, child) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: currentTheme.cardBg,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: currentTheme.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.palette_outlined,
                            color: currentTheme.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Color Themes',
                                style: TextStyle(
                                  color: currentTheme.textPrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Tap any theme to update immediately',
                                style: TextStyle(
                                  color: currentTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: currentTheme.textHint),
                          onPressed: () => Navigator.of(context).pop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Divider(color: currentTheme.border, height: 1),
                    const SizedBox(height: 14),
                    _buildThemeSelectorGrid(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAdBanner() {
    if (_isBannerAdReady && _bannerAd != null) {
      return Container(
        width: double.infinity,
        height: _bannerAd!.size.height.toDouble(),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: currentTheme.cardBg,
          border: Border(
            top: BorderSide(color: currentTheme.border, width: 1),
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
      decoration: BoxDecoration(
        color: currentTheme.cardBg,
        border: Border(
          top: BorderSide(color: currentTheme.border, width: 1),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                border: Border.all(color: currentTheme.primary, width: 1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                'Ad',
                style: TextStyle(
                  color: currentTheme.primary,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.campaign,
                    color: currentTheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'India Post Speed Post Logistics',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: currentTheme.brightness == Brightness.light ? currentTheme.textPrimary : Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Fast, reliable parcel delivery across India. Send now!',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: currentTheme.textSecondary,
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
                      backgroundColor: currentTheme.secondary,
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
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: currentTheme.primary,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INDIA POST',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: currentTheme.brightness == Brightness.light ? currentTheme.textPrimary : Colors.white,
                      ),
                    ),
                    Text(
                      'OFFICES DIRECTORY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: currentTheme.secondary.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.palette_outlined,
                  color: currentTheme.primary,
                  size: 26,
                ),
                tooltip: 'Color Themes',
                onPressed: _showThemeSelectorDialog,
              ),
              IconButton(
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: currentTheme.primary,
                  size: 26,
                ),
                tooltip: 'App Info',
                onPressed: _showAppInfoDialog,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Search offices by Name or Pincode in real-time',
            style: TextStyle(
              fontSize: 13,
              color: currentTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          _buildThemeSelector(),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      decoration: BoxDecoration(
        color: currentTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: currentTheme.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: currentTheme.shadow,
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
            style: TextStyle(color: currentTheme.textPrimary, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Enter 3+ digit Pincode or Office Name...',
              hintStyle: TextStyle(color: currentTheme.textHint),
              prefixIcon: Icon(Icons.search, color: currentTheme.primary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: currentTheme.textSecondary),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              filled: true,
              fillColor: currentTheme.inputFill,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: currentTheme.primary, width: 1.5),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty && !_isLoading && _errorMessage == null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${min(_displayOffices.length, 50)} results',
                  style: TextStyle(
                    fontSize: 12,
                    color: currentTheme.textHint,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (_offices.isNotEmpty)
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        margin: const EdgeInsets.only(right: 2),
                        decoration: BoxDecoration(
                          color: currentTheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: currentTheme.primary.withOpacity(0.3), width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedOfficeTypeFilter,
                            isDense: true,
                            icon: Icon(Icons.filter_list_rounded, size: 14, color: currentTheme.primary),
                            dropdownColor: currentTheme.cardBg,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: currentTheme.primary,
                            ),
                            items: const [
                              DropdownMenuItem(value: 'All Offices', child: Text('All Offices')),
                              DropdownMenuItem(value: 'NSH', child: Text('NSH')),
                              DropdownMenuItem(value: 'ICH', child: Text('ICH')),
                              DropdownMenuItem(value: 'PH', child: Text('PH')),
                              DropdownMenuItem(value: 'L1 Offices', child: Text('L1 Offices')),
                              DropdownMenuItem(value: 'L2 Offices', child: Text('L2 Offices')),
                              DropdownMenuItem(value: 'Head Office', child: Text('Head Office')),
                              DropdownMenuItem(value: 'Sub Office', child: Text('Sub Office')),
                              DropdownMenuItem(value: 'Branch Office', child: Text('Branch Office')),
                            ],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedOfficeTypeFilter = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _handleExportWithAd,
                        icon: Icon(Icons.file_download, size: 16, color: currentTheme.primary),
                        label: Text(
                          'Export to Excel',
                          style: TextStyle(
                            color: currentTheme.primary,
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
                      TextButton.icon(
                        onPressed: _dictateTableData,
                        icon: Icon(
                          _isSpeaking && _currentlyReadingIndex == -1
                              ? Icons.stop_circle
                              : Icons.record_voice_over,
                          size: 16,
                          color: _isSpeaking && _currentlyReadingIndex == -1
                              ? Colors.redAccent
                              : currentTheme.primary,
                        ),
                        label: Text(
                          _isSpeaking && _currentlyReadingIndex == -1
                              ? 'Stop Dictation'
                              : 'Read / Dictate Table',
                          style: TextStyle(
                            color: _isSpeaking && _currentlyReadingIndex == -1
                                ? Colors.redAccent
                                : currentTheme.primary,
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
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(currentTheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Searching India Post Database...',
              style: TextStyle(
                color: currentTheme.textPrimary.withOpacity(0.8),
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
      return Center(
        child: Text(
          'No office matches found.',
          style: TextStyle(color: currentTheme.textSecondary),
        ),
      );
    }

    if (_displayOffices.isEmpty) {
      return Center(
        child: Text(
          'No offices found for selected type filter "$_selectedOfficeTypeFilter".',
          style: TextStyle(color: currentTheme.textSecondary, fontWeight: FontWeight.w500),
        ),
      );
    }

    return _buildResponsiveTable();
  }

  Widget _buildResponsiveTable() {
    return Container(
      decoration: BoxDecoration(
        color: currentTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: currentTheme.border,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hint banner for horizontal scrolling
          Container(
            color: currentTheme.tableHeaderBg,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.swap_horizontal_circle_outlined, size: 14, color: currentTheme.primary),
                const SizedBox(width: 6),
                Text(
                  'Swipe horizontally to view more details',
                  style: TextStyle(fontSize: 10, color: currentTheme.textSecondary, fontWeight: FontWeight.w500),
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
                    dividerColor: currentTheme.border,
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(currentTheme.tableHeaderBg),
                    dataRowMinHeight: 52,
                    dataRowMaxHeight: 68,
                    columns: [
                      DataColumn(
                        label: Text(
                          'Office Name & Type',
                          style: TextStyle(color: currentTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Pincode',
                          style: TextStyle(color: currentTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Division Name',
                          style: TextStyle(color: currentTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Region Name',
                          style: TextStyle(color: currentTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Circle Name',
                          style: TextStyle(color: currentTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Dictate',
                          style: TextStyle(color: currentTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                    rows: _displayOffices.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final po = entry.value;
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
                      final bool isRowSpeaking = _isSpeaking && _currentlyReadingIndex == index;

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
                                  style: TextStyle(
                                    color: currentTheme.textPrimary,
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
                                          style: TextStyle(
                                            color: currentTheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 0.5,
                                            decoration: TextDecoration.underline,
                                            decorationColor: currentTheme.primary,
                                            decorationThickness: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    pincode,
                                    style: TextStyle(
                                      color: currentTheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                          DataCell(Text(division, style: TextStyle(color: currentTheme.textSecondary, fontSize: 13))),
                          DataCell(Text(region, style: TextStyle(color: currentTheme.textSecondary, fontSize: 13))),
                          DataCell(Text(circle, style: TextStyle(color: currentTheme.textSecondary, fontSize: 13))),
                          DataCell(
                            IconButton(
                              icon: Icon(
                                isRowSpeaking ? Icons.stop_circle : Icons.volume_up_rounded,
                                color: isRowSpeaking ? Colors.redAccent : currentTheme.primary,
                                size: 18,
                              ),
                              tooltip: isRowSpeaking ? 'Stop Dictating' : 'Dictate this office',
                              onPressed: () => _dictateSingleOffice(po, index),
                            ),
                          ),
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
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(currentTheme.primary),
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
          
          // Filter out offices that are not Head Office, Sub Office, or Branch Office
          final List<dynamic> filteredOffices = postOffices.where((po) {
            final rank = getOfficeRank(po);
            return rank >= 0;
          }).toList();

          filteredOffices.sort((a, b) {
            int rankA = getOfficeRank(a);
            int rankB = getOfficeRank(b);
            if (rankA != rankB) {
              return rankA.compareTo(rankB);
            }
            return (a['Name'] ?? '').toString().compareTo((b['Name'] ?? '').toString());
          });

          _cache[pincode.toLowerCase()] = filteredOffices;
          
          associatedOffice = _findSOorHO(filteredOffices, pincode);
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
        return ValueListenableBuilder<String>(
          valueListenable: themeNotifier,
          builder: (context, themeKey, child) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: currentTheme.cardBg,
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
                            color: currentTheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                      child: Icon(
                        Icons.account_balance,
                        color: currentTheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Associated Main Office',
                            style: TextStyle(
                              color: currentTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            name,
                            style: TextStyle(
                              color: currentTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: currentTheme.textHint),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Divider(color: currentTheme.border, height: 1),
                const SizedBox(height: 18),
                _buildDialogRow('Office Type', type, badgeColor: badgeColor),
                const SizedBox(height: 12),
                _buildDialogRow('Pincode', pincode, valueColor: currentTheme.primary),
                const SizedBox(height: 12),
                _buildDialogRow('Delivery Status', delivery, 
                  valueColor: delivery.toLowerCase() == 'delivery' ? currentTheme.secondary : const Color(0xFFEF4444)),
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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _dictateSingleOffice(po, -2);
                        },
                        icon: const Icon(Icons.record_voice_over, size: 18),
                        label: const Text('Dictate Office'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentTheme.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
            style: TextStyle(
              color: currentTheme.textHint,
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
                    color: valueColor ?? currentTheme.textPrimary,
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

  void _showAppInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<String>(
          valueListenable: themeNotifier,
          builder: (context, themeKey, child) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: currentTheme.cardBg,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480, maxHeight: 540),
                padding: const EdgeInsets.all(20),
                child: DefaultTabController(
                  length: 5,
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dialog Header
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: currentTheme.primary,
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/images/logo.jpg',
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'India Post Offices',
                              style: TextStyle(
                                color: currentTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Version $_localVersion (Build $_localBuild)',
                              style: TextStyle(
                                color: currentTheme.textHint,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: currentTheme.textHint),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: currentTheme.border, height: 1),
                  const SizedBox(height: 8),
                  
                  // TabBar
                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: currentTheme.primary,
                    unselectedLabelColor: currentTheme.textSecondary,
                    indicatorColor: currentTheme.primary,
                    dividerColor: Colors.transparent,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                    tabs: const [
                      Tab(text: 'About', icon: Icon(Icons.description_outlined, size: 18)),
                      Tab(text: 'Themes', icon: Icon(Icons.palette_outlined, size: 18)),
                      Tab(text: 'Privacy', icon: Icon(Icons.privacy_tip_outlined, size: 18)),
                      Tab(text: 'Features', icon: Icon(Icons.featured_play_list_outlined, size: 18)),
                      Tab(text: 'Updates', icon: Icon(Icons.update_outlined, size: 18)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // TabBarView
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab 1: About
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Overview',
                                style: TextStyle(
                                  color: currentTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'India Post Offices is a highly optimized utility app that acts as a comprehensive directory for post offices across India. It connects directly to the Indian Postal API to verify, search, and catalog details about Head, Sub, and Branch post offices.',
                                style: TextStyle(
                                  color: currentTheme.textSecondary,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Data Sources',
                                style: TextStyle(
                                  color: currentTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'This app fetches official data under the Open Government Data Platform India (data.gov.in) via the open API protocol.',
                                style: TextStyle(
                                  color: currentTheme.textSecondary,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Privacy & Security Summary',
                                style: TextStyle(
                                  color: currentTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '• Developer: Shree Lakshmi Ventures (SLV)\n• Effective Date: August 2, 2026\n• Package Name: com.oedc.indiaPostOffices\n• We do not collect or store personal identity data, bank details, or GPS location.\n• Switch to the "Privacy" tab for the full Privacy Policy.',
                                style: TextStyle(
                                  color: currentTheme.textSecondary,
                                  fontSize: 12.5,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tab 2: Themes
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Color Palette & Themes',
                                style: TextStyle(
                                  color: currentTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Select any color theme below to update the app colors in real-time.',
                                style: TextStyle(
                                  color: currentTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildThemeSelectorGrid(),
                            ],
                          ),
                        ),
                        // Tab 2: Privacy Policy
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: currentTheme.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: currentTheme.primary.withOpacity(0.2)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Privacy Policy for India Post Offices',
                                      style: TextStyle(
                                        color: currentTheme.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Effective Date: August 2, 2026\nDeveloper: Shree Lakshmi Ventures (SLV)\nPackage Name: com.oedc.indiaPostOffices',
                                      style: TextStyle(
                                        color: currentTheme.textSecondary,
                                        fontSize: 11.5,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildPrivacySubHeading('1. Overview'),
                              _buildPrivacyText(
                                'Shree Lakshmi Ventures ("we", "our", or "us") developed the India Post Offices application to help users search and access information about India Post Offices across India. We value your privacy and are committed to protecting your information.',
                              ),
                              const SizedBox(height: 10),
                              _buildPrivacySubHeading('2. Information We Collect'),
                              _buildPrivacyText(
                                '• Account Registration: Not required.\n'
                                '• Personal Data: We DO NOT collect personal information such as Name, Email, Phone number, Postal address, Aadhaar number, PAN number, Bank details, or Payment info.\n'
                                '• Location Data: The app does not access your device GPS location.\n'
                                '• Device Technical Info: Limited technical info (Android version, device model, app version, crash reports) may be collected automatically to improve performance and reliability.',
                              ),
                              const SizedBox(height: 10),
                              _buildPrivacySubHeading('3. Advertisements (Google AdMob)'),
                              _buildPrivacyText(
                                'The app may display advertisements using Google AdMob. Google AdMob may collect Advertising ID, device information, approximate location, and ad interactions in accordance with Google\'s Privacy Policy.',
                              ),
                              const SizedBox(height: 6),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  side: BorderSide(color: currentTheme.primary.withOpacity(0.5)),
                                ),
                                icon: Icon(Icons.open_in_new, size: 14, color: currentTheme.primary),
                                label: Text(
                                  'Google Privacy Policy',
                                  style: TextStyle(fontSize: 11.5, color: currentTheme.primary),
                                ),
                                onPressed: () => _launchUpdateUrl('https://policies.google.com/privacy'),
                              ),
                              const SizedBox(height: 10),
                              _buildPrivacySubHeading('4. Data Storage & Sharing'),
                              _buildPrivacyText(
                                'User preferences and settings are stored locally on your device. No personal information is stored on our servers. We do not sell, rent, or share personal information with third parties. Information is only processed by trusted services like Google Play Services and Google AdMob.',
                              ),
                              const SizedBox(height: 10),
                              _buildPrivacySubHeading('5. Permissions'),
                              _buildPrivacyText(
                                'The app requests basic Internet and Network Access permissions solely for fetching post office data via API and displaying advertisements.',
                              ),
                              const SizedBox(height: 10),
                              _buildPrivacySubHeading('6. Children\'s Privacy & Security'),
                              _buildPrivacyText(
                                'Intended for general audiences. We do not knowingly collect personal information from children under the age of 13. Reasonable technical measures are implemented to safeguard application processing.',
                              ),
                              const SizedBox(height: 10),
                              _buildPrivacySubHeading('7. Government Disclaimer'),
                              _buildPrivacyText(
                                'India Post Offices is NOT an official Government of India application. It provides publicly available information for user convenience.',
                              ),
                              const SizedBox(height: 6),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  side: BorderSide(color: currentTheme.secondary.withOpacity(0.5)),
                                ),
                                icon: Icon(Icons.language, size: 14, color: currentTheme.secondary),
                                label: Text(
                                  'Official India Post Website',
                                  style: TextStyle(fontSize: 11.5, color: currentTheme.secondary),
                                ),
                                onPressed: () => _launchUpdateUrl('https://www.indiapost.gov.in'),
                              ),
                              const SizedBox(height: 10),
                              _buildPrivacySubHeading('8. Contact Us'),
                              _buildPrivacyText(
                                'Developer: Shree Lakshmi Ventures\nEmail: madhusmita852011@gmail.com',
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentTheme.primary,
                                  foregroundColor: currentTheme.textOnPrimary,
                                  minimumSize: const Size(double.infinity, 36),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.open_in_browser, size: 16),
                                label: const Text('View PRIVACY_POLICY.md on GitHub', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                onPressed: () => _launchUpdateUrl('https://github.com/Lokanath862001/India-Post-Offices/blob/main/PRIVACY_POLICY.md'),
                              ),
                            ],
                          ),
                        ),
                        // Tab 2: Features
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              _buildFeatureItem(
                                Icons.search_rounded,
                                'Instant Search',
                                'Query post offices by Pincode or Office Name instantly.',
                              ),
                              _buildFeatureItem(
                                Icons.filter_alt_rounded,
                                'Smart Hierarchy Classification',
                                'Ranks and badges Offices into Head, Sub, and Branch categories.',
                              ),
                              _buildFeatureItem(
                                Icons.download_for_offline_rounded,
                                'Excel Export & Sharing',
                                'Export search tables to Excel files & share with colleagues.',
                              ),
                              _buildFeatureItem(
                                Icons.record_voice_over_rounded,
                                'Read & Dictate Table',
                                'Reads resulted table data out loud using built-in Text-To-Speech audio dictation.',
                              ),
                              _buildFeatureItem(
                                Icons.palette_rounded,
                                'Beautiful Custom Themes',
                                'Choose from Light, Dark, or 7 vivid accent modes.',
                              ),
                              _buildFeatureItem(
                                Icons.offline_bolt_rounded,
                                'Dynamic Query Cache',
                                'Caches results locally to fetch repeat queries offline.',
                              ),
                            ],
                          ),
                        ),
                        // Tab 3: Updates
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildUpdateHeader('v1.0.4 (Build 5)', 'Current Version'),
                              const SizedBox(height: 4),
                              _buildUpdatePoint('Optimized App Bundle compilation for Play Console distribution.'),
                              _buildUpdatePoint('Integrated in-app Privacy Policy viewer for Google Play policy compliance.'),
                              _buildUpdatePoint('Enhanced table data dictation (TTS) and Excel export capabilities.'),
                              _buildUpdatePoint('General performance optimizations and UI fixes.'),
                              const SizedBox(height: 14),
                              _buildUpdateHeader('v1.0.3 (Build 4)', 'Previous Version'),
                              const SizedBox(height: 4),
                              _buildUpdatePoint('Integrated dedicated Privacy Policy tab & in-app policy viewer compliant with Play Console rules.'),
                              _buildUpdatePoint('Added official Privacy Policy (PRIVACY_POLICY.md) document to repository.'),
                              _buildUpdatePoint('Added direct links to Google Privacy Policy and official India Post portal.'),
                              _buildUpdatePoint('Optimized App Info dialog layout with responsive scrollable tab navigation.'),
                              const SizedBox(height: 14),
                              _buildUpdateHeader('v1.0.2 (Build 3)', 'Previous Version'),
                              const SizedBox(height: 4),
                              _buildUpdatePoint('Added Read / Dictate button after download to dictate resulted table data using Text-To-Speech.'),
                              _buildUpdatePoint('Integrated 9-theme customize engine (with Light/Dark auto).'),
                              _buildUpdatePoint('Added Excel (.xlsx) file generation and multi-platform sharing.'),
                              _buildUpdatePoint('Added automatic update detection checks from GitHub version.json.'),
                              _buildUpdatePoint('Optimized UI with new card layout and rank sorting hierarchy.'),
                              const SizedBox(height: 14),
                              _buildUpdateHeader('v1.0.0 (Build 1)', 'Initial Release'),
                              const SizedBox(height: 4),
                              _buildUpdatePoint('Search post offices by entering names or pincodes.'),
                              _buildUpdatePoint('Basic connection handling and list visualization.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  },
);
}

  Widget _buildFeatureItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: currentTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: currentTheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: currentTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    color: currentTheme.textSecondary,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateHeader(String version, String dateInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          version,
          style: TextStyle(
            color: currentTheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: currentTheme.secondary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            dateInfo,
            style: TextStyle(
              color: currentTheme.secondary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdatePoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(color: currentTheme.primary, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: currentTheme.textSecondary,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySubHeading(String text) {
    return Text(
      text,
      style: TextStyle(
        color: currentTheme.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }

  Widget _buildPrivacyText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: currentTheme.textSecondary,
        fontSize: 12,
        height: 1.35,
      ),
    );
  }
}
