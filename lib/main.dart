import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
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
import 'ecosystem/services/recommendation_service.dart';
import 'ecosystem/widgets/you_may_also_like.dart';

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

Color customThemeColor = const Color(0xFFFF9933);
Brightness customThemeBrightness = Brightness.dark;

AppThemeConfig buildCustomTheme(Color color, {Brightness brightness = Brightness.dark}) {
  final hsv = HSVColor.fromColor(color);
  final double hue = hsv.hue;

  if (brightness == Brightness.light) {
    return AppThemeConfig(
      brightness: Brightness.light,
      primary: color,
      secondary: HSVColor.fromAHSV(1.0, (hue + 140) % 360, 0.85, 0.65).toColor(),
      scaffoldBgStart: HSVColor.fromAHSV(1.0, hue, 0.05, 0.98).toColor(),
      scaffoldBgEnd: HSVColor.fromAHSV(1.0, hue, 0.10, 0.93).toColor(),
      cardBg: Colors.white,
      inputFill: HSVColor.fromAHSV(1.0, hue, 0.04, 0.96).toColor(),
      border: HSVColor.fromAHSV(1.0, hue, 0.15, 0.84).toColor(),
      textPrimary: const Color(0xFF0F172A),
      textSecondary: const Color(0xFF475569),
      textHint: const Color(0xFF94A3B8),
      tableHeaderBg: HSVColor.fromAHSV(1.0, hue, 0.10, 0.94).toColor(),
      shadow: const Color(0x0C000000),
      textOnPrimary: color.computeLuminance() > 0.55 ? Colors.black87 : Colors.white,
    );
  } else {
    return AppThemeConfig(
      brightness: Brightness.dark,
      primary: color,
      secondary: HSVColor.fromAHSV(1.0, (hue + 140) % 360, 0.85, 0.85).toColor(),
      scaffoldBgStart: HSVColor.fromAHSV(1.0, hue, 0.45, 0.12).toColor(),
      scaffoldBgEnd: HSVColor.fromAHSV(1.0, hue, 0.55, 0.07).toColor(),
      cardBg: HSVColor.fromAHSV(1.0, hue, 0.35, 0.18).toColor(),
      inputFill: HSVColor.fromAHSV(1.0, hue, 0.45, 0.12).toColor(),
      border: HSVColor.fromAHSV(1.0, hue, 0.40, 0.30).toColor(),
      textPrimary: Colors.white,
      textSecondary: HSVColor.fromAHSV(1.0, hue, 0.20, 0.85).toColor(),
      textHint: HSVColor.fromAHSV(1.0, hue, 0.45, 0.60).toColor(),
      tableHeaderBg: HSVColor.fromAHSV(1.0, hue, 0.45, 0.12).toColor(),
      shadow: const Color(0x4D000000),
      textOnPrimary: color.computeLuminance() > 0.55 ? Colors.black87 : Colors.white,
    );
  }
}

class _ColorWheelPainter extends CustomPainter {
  final double thumbX;
  final double thumbY;
  final Color selectedColor;

  const _ColorWheelPainter({
    required this.thumbX,
    required this.thumbY,
    required this.selectedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Draw Hue sweep gradient (spectrum of millions of colors)
    const sweepGradient = SweepGradient(
      colors: [
        Color(0xFFFF0000), // 0 deg - Red
        Color(0xFFFFFF00), // 60 deg - Yellow
        Color(0xFF00FF00), // 120 deg - Green
        Color(0xFF00FFFF), // 180 deg - Cyan
        Color(0xFF0000FF), // 240 deg - Blue
        Color(0xFFFF00FF), // 300 deg - Magenta
        Color(0xFFFF0000), // 360 deg - Red
      ],
    );

    final sweepPaint = Paint()
      ..shader = sweepGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, sweepPaint);

    // 2. Draw Saturation radial gradient (white in center to transparent on outer edge)
    const saturationGradient = RadialGradient(
      colors: [
        Colors.white,
        Color(0x00FFFFFF),
      ],
      stops: [0.0, 1.0],
    );

    final saturationPaint = Paint()
      ..shader = saturationGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, saturationPaint);

    // 3. Draw outer border ring
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, borderPaint);

    // 4. Draw Thumb / Selector Ring on current selected position
    if (thumbX >= 0 && thumbY >= 0) {
      final thumbCenter = Offset(thumbX, thumbY);

      // Shadow
      canvas.drawCircle(
        thumbCenter,
        14,
        Paint()
          ..color = Colors.black.withOpacity(0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      // Outer white ring
      canvas.drawCircle(
        thumbCenter,
        12,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );

      // Inner color preview
      canvas.drawCircle(
        thumbCenter,
        9.5,
        Paint()
          ..color = selectedColor
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ColorWheelPainter oldDelegate) {
    return oldDelegate.thumbX != thumbX ||
        oldDelegate.thumbY != thumbY ||
        oldDelegate.selectedColor != selectedColor;
  }
}

class CircleColorPicker extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;
  final double size;

  const CircleColorPicker({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
    this.size = 180.0,
  });

  @override
  State<CircleColorPicker> createState() => _CircleColorPickerState();
}

class _CircleColorPickerState extends State<CircleColorPicker> {
  late double _hue;
  late double _saturation;
  late double _value;
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
    final hsv = HSVColor.fromColor(widget.initialColor);
    _hue = hsv.hue;
    _saturation = hsv.saturation;
    _value = hsv.value > 0.1 ? hsv.value : 1.0;
  }

  @override
  void didUpdateWidget(covariant CircleColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialColor != widget.initialColor && widget.initialColor != _currentColor) {
      _currentColor = widget.initialColor;
      final hsv = HSVColor.fromColor(widget.initialColor);
      _hue = hsv.hue;
      _saturation = hsv.saturation;
      _value = hsv.value > 0.1 ? hsv.value : 1.0;
    }
  }

  void _handleTouch(Offset localPosition, double radius) {
    final center = Offset(radius, radius);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    final distance = (dx * dx + dy * dy);
    final distSqrt = distance > 0 ? math.sqrt(distance) : 0.0;

    final sat = (distSqrt / radius).clamp(0.0, 1.0);

    var rad = math.atan2(dy, dx);
    var deg = rad * 180 / math.pi;
    if (deg < 0) deg += 360;

    setState(() {
      _hue = deg;
      _saturation = sat;
      _currentColor = HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor();
    });

    widget.onColorChanged(_currentColor);
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.size / 2;
    final angleRad = _hue * math.pi / 180.0;
    final currentDist = _saturation * radius;
    final thumbX = radius + math.cos(angleRad) * currentDist;
    final thumbY = radius + math.sin(angleRad) * currentDist;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onPanDown: (details) => _handleTouch(details.localPosition, radius),
          onPanUpdate: (details) => _handleTouch(details.localPosition, radius),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _ColorWheelPainter(
                thumbX: thumbX,
                thumbY: thumbY,
                selectedColor: _currentColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Brightness / Shade slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              Icon(Icons.wb_sunny_outlined, size: 16, color: currentTheme.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    activeTrackColor: _currentColor,
                    inactiveTrackColor: currentTheme.border,
                    thumbColor: Colors.white,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                  ),
                  child: Slider(
                    value: _value,
                    min: 0.25,
                    max: 1.0,
                    onChanged: (val) {
                      setState(() {
                        _value = val;
                        _currentColor = HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor();
                      });
                      widget.onColorChanged(_currentColor);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${(_value * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: currentTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const String appLocalVersion = '1.1.5';
const int appLocalBuild = 15;

final ValueNotifier<String> themeNotifier = ValueNotifier<String>('dark');

AppThemeConfig get currentTheme => appThemes[themeNotifier.value] ?? appThemes['dark']!;

void changeAppTheme(String key) {
  if (appThemes.containsKey(key)) {
    themeNotifier.value = key;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('app_theme', key);
    });
  }
}

void applyAppCustomColor(Color color, {Brightness? brightness}) {
  customThemeColor = color;
  if (brightness != null) {
    customThemeBrightness = brightness;
  }
  appThemes['custom'] = buildCustomTheme(customThemeColor, brightness: customThemeBrightness);
  themeNotifier.value = 'custom';
  SharedPreferences.getInstance().then((prefs) {
    prefs.setString('app_theme', 'custom');
    prefs.setInt('custom_theme_color', customThemeColor.value);
    prefs.setString('custom_theme_brightness', customThemeBrightness == Brightness.light ? 'light' : 'dark');
  });
}

Future<void> launchAppUrl(String urlString) async {
  final Uri url = Uri.parse(urlString);
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    debugPrint('Could not launch URL $urlString: $e');
  }
}

int getOfficeRank(Map<String, dynamic> po) {
  final name = (po['Name'] ?? po['name'] ?? '').toString().toUpperCase();
  final branchType = (po['BranchType'] ?? po['branchType'] ?? '').toString().toUpperCase();
  final type = (po['Type'] ?? po['type'] ?? '').toString().toUpperCase();

  // 1. Head Offices
  if (branchType.contains('HEAD') ||
      type.contains('HEAD') ||
      name.contains('H.O.') ||
      name.endsWith(' H.O') ||
      name.contains(' HPO') ||
      name.contains('HEAD POST OFFICE')) {
    return 0;
  }
  // 2. Sub Offices
  if (branchType.contains('SUB') ||
      type.contains('SUB') ||
      name.contains('S.O.') ||
      name.endsWith(' S.O') ||
      name.contains(' SPO') ||
      name.contains('SUB POST OFFICE')) {
    return 1;
  }
  // 3. Branch Offices
  if (branchType.contains('BRANCH') ||
      type.contains('BRANCH') ||
      name.contains('B.O.') ||
      name.endsWith(' B.O') ||
      name.contains(' BO ') ||
      name.contains('BRANCH POST OFFICE')) {
    return 2;
  }
  // 4. Other offices associated to the pin code
  return 3;
}

String getOfficeTypeLabel(Map<String, dynamic> po) {
  final rank = getOfficeRank(po);
  switch (rank) {
    case 0:
      return 'Head Office';
    case 1:
      return 'Sub Office';
    case 2:
      return 'Branch Office';
    default:
      if (po['isLocal'] == true) {
        final hub = po['HubLevel'] ?? '';
        return hub.isNotEmpty ? 'Local ($hub)' : 'Local Data';
      }
      final bType = (po['BranchType'] ?? po['Type'] ?? '').toString().trim();
      return bType.isNotEmpty ? bType : 'Other Office';
  }
}

Color getBadgeColor(String label) {
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

class TopBannerAdWidget extends StatefulWidget {
  const TopBannerAdWidget({super.key});

  @override
  State<TopBannerAdWidget> createState() => _TopBannerAdWidgetState();
}

class _TopBannerAdWidgetState extends State<TopBannerAdWidget> {
  BannerAd? _ad;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (kIsWeb) return;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        _ad = BannerAd(
          adUnitId: 'ca-app-pub-1945844675060188/1982074117',
          request: const AdRequest(),
          size: AdSize.banner,
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              if (mounted) {
                setState(() => _isReady = true);
              }
            },
            onAdFailedToLoad: (ad, err) {
              debugPrint('Top Banner failed to load: ${err.message}');
              _isReady = false;
              ad.dispose();
            },
          ),
        );
        _ad!.load();
      }
    } catch (e) {
      debugPrint('Top Banner load error: $e');
    }
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _ad == null) {
      return const SizedBox.shrink();
    }
    return ValueListenableBuilder<String>(
      valueListenable: themeNotifier,
      builder: (context, currentThemeKey, child) {
        return Container(
          width: double.infinity,
          height: _ad!.size.height.toDouble(),
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: currentTheme.cardBg,
            border: Border(
              bottom: BorderSide(color: currentTheme.border, width: 1),
            ),
          ),
          alignment: Alignment.center,
          child: AdWidget(ad: _ad!),
        );
      },
    );
  }
}

class BottomBannerAdWidget extends StatefulWidget {
  const BottomBannerAdWidget({super.key});

  @override
  State<BottomBannerAdWidget> createState() => _BottomBannerAdWidgetState();
}

class _BottomBannerAdWidgetState extends State<BottomBannerAdWidget> {
  BannerAd? _ad;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (kIsWeb) return;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        _ad = BannerAd(
          adUnitId: 'ca-app-pub-1945844675060188/3998004613',
          request: const AdRequest(),
          size: AdSize.banner,
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              if (mounted) {
                setState(() => _isReady = true);
              }
            },
            onAdFailedToLoad: (ad, err) {
              debugPrint('Bottom Banner failed to load: ${err.message}');
              _isReady = false;
              ad.dispose();
            },
          ),
        );
        _ad!.load();
      }
    } catch (e) {
      debugPrint('Bottom Banner load error: $e');
    }
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _ad == null) {
      return const SizedBox.shrink();
    }
    return ValueListenableBuilder<String>(
      valueListenable: themeNotifier,
      builder: (context, currentThemeKey, child) {
        return Container(
          width: double.infinity,
          height: _ad!.size.height.toDouble(),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: currentTheme.cardBg,
            border: Border(
              top: BorderSide(color: currentTheme.border, width: 1),
            ),
          ),
          alignment: Alignment.center,
          child: AdWidget(ad: _ad!),
        );
      },
    );
  }
}

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

  // Load saved theme and custom color
  String savedTheme = 'dark';
  String savedOfficeFilter = 'All Offices';
  try {
    final prefs = await SharedPreferences.getInstance();
    final savedColorVal = prefs.getInt('custom_theme_color');
    final savedBrightnessStr = prefs.getString('custom_theme_brightness');
    if (savedColorVal != null) {
      customThemeColor = Color(savedColorVal);
    }
    if (savedBrightnessStr == 'light') {
      customThemeBrightness = Brightness.light;
    } else {
      customThemeBrightness = Brightness.dark;
    }
    appThemes['custom'] = buildCustomTheme(customThemeColor, brightness: customThemeBrightness);
    savedTheme = prefs.getString('app_theme') ?? 'dark';
    final filter = prefs.getString('selected_office_type_filter');
    const validFilters = [
      'All Offices',
      'NSH',
      'ICH',
      'PH',
      'L1 Offices',
      'L2 Offices',
      'Head Office',
      'Sub Office',
      'Branch Office',
    ];
    if (filter != null && validFilters.contains(filter)) {
      savedOfficeFilter = filter;
    }
  } catch (e) {
    debugPrint('Error loading saved theme: $e');
  }

  if (!appThemes.containsKey('custom')) {
    appThemes['custom'] = buildCustomTheme(customThemeColor, brightness: customThemeBrightness);
  }

  themeNotifier.value = savedTheme;

  runApp(MyApp(initialOfficeFilter: savedOfficeFilter));
}

class MyApp extends StatelessWidget {
  final String initialOfficeFilter;
  const MyApp({super.key, this.initialOfficeFilter = 'All Offices'});

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
          home: PostOfficeFinderScreen(initialOfficeFilter: initialOfficeFilter),
        );
      },
    );
  }
}

class PostOfficeFinderScreen extends StatefulWidget {
  final String initialOfficeFilter;
  const PostOfficeFinderScreen({super.key, this.initialOfficeFilter = 'All Offices'});

  @override
  State<PostOfficeFinderScreen> createState() => _PostOfficeFinderScreenState();
}

class _PostOfficeFinderScreenState extends State<PostOfficeFinderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, List<dynamic>> _cache = {};
  
  List<dynamic> _offices = [];
  List<Map<String, dynamic>> _localOfficesData = [];
  int _searchCount = 0;
  late String _selectedOfficeTypeFilter;
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
        final bool isPh = l1.contains('PH') ||
            l2.contains('PH') ||
            name.contains(' PH') ||
            name.endsWith('PH') ||
            name.startsWith('PH ') ||
            RegExp(r'\bPH\b').hasMatch(name) ||
            typeLabel.contains('PH') ||
            branchType.contains('PH');
        final bool isParcel = name.contains('PARCEL') ||
            l1.contains('PARCEL') ||
            l2.contains('PARCEL') ||
            typeLabel.contains('PARCEL') ||
            branchType.contains('PARCEL');
        return isPh || isParcel;
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
  String? _loadingMessage;
  (int, int)? _currentRangeQuery;
  Timer? _debounce;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  late FlutterTts _flutterTts;
  bool _isSpeaking = false;
  bool _isTtsInitialized = false;
  int _currentlyReadingIndex = -1;
  Completer<void>? _speechCompleter;

  late final RecommendationService _recommendationService;

  int min(int a, int b) => a < b ? a : b;

  @override
  void initState() {
    super.initState();
    _selectedOfficeTypeFilter = widget.initialOfficeFilter;
    _recommendationService = RecommendationService(
      currentApplicationId: 'com.oedc.indiaPostOffices',
    );
    themeNotifier.addListener(_onThemeChanged);
    _searchController.addListener(_onSearchChanged);
    _loadLocalOffices();
    _loadInterstitialAd();
  }

  void _onOfficeTypeFilterChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedOfficeTypeFilter = newValue;
      });
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('selected_office_type_filter', newValue);
      }).catchError((e) {
        debugPrint('Error saving office type filter: $e');
      });
      _showInterstitialAdIfAvailable(() {});
    }
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
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
    _interstitialAd?.dispose();
    super.dispose();
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

  Color _getBadgeColor(String label) => getBadgeColor(label);

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
      _loadingMessage = null;
    });

    if (results.isNotEmpty) {
      _searchCount++;
      if (_searchCount % 20 == 0) {
        _showInterstitialAdIfAvailable(() {});
      }
    }
  }

  (int, int)? _tryParsePincodeRange(String input) {
    final trimmed = input.trim();
    final matches = RegExp(r'(?<!\d)\d{6}(?!\d)').allMatches(trimmed).toList();
    if (matches.length == 2) {
      final p1 = int.tryParse(matches[0].group(0)!);
      final p2 = int.tryParse(matches[1].group(0)!);
      if (p1 != null && p2 != null && p1 != p2) {
        final withoutPincodes = trimmed
            .replaceAll(matches[0].group(0)!, '')
            .replaceAll(matches[1].group(0)!, '')
            .trim();
        final isCleanRange = RegExp(
          r'^(?:(?:pin(?:code)?|from|to|range|and)\b|[^a-zA-Z0-9]|\s)*$',
          caseSensitive: false,
        ).hasMatch(withoutPincodes);
        if (isCleanRange) {
          return (math.min(p1, p2), math.max(p1, p2));
        }
      }
    }
    return null;
  }

  Future<void> _performSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _offices = [];
        _isLoading = false;
        _errorMessage = null;
        _currentRangeQuery = null;
        _loadingMessage = null;
      });
      return;
    }

    // If user is actively typing a range separator like "110001 -", wait for them to finish typing second pin
    final isTypingRange = RegExp(
      r'^(?:(?:pin(?:code)?|from)\s*:?\s*)?\d{6}\s*(?:[-/]|to|\.\.|,|:)\s*$',
      caseSensitive: false,
    ).hasMatch(trimmed);
    if (isTypingRange) {
      return;
    }

    await _loadLocalOffices();

    // Check for range of pin codes (e.g. two 6-digit pin codes with delimiter/symbols/space)
    final range = _tryParsePincodeRange(trimmed);
    if (range != null) {
      final (startPin, endPin) = range;

      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _currentRangeQuery = (startPin, endPin);
        _loadingMessage = 'Searching range $startPin - $endPin in postal directory...';
      });

      final cacheKey = 'range_${startPin}_$endPin';
      if (_cache.containsKey(cacheKey)) {
        _setSearchResults(cacheKey, _cache[cacheKey]!);
        return;
      }

      try {
        final List<String> pinStrings = [
          for (int p = startPin; p <= endPin; p++) p.toString().padLeft(6, '0')
        ];

        final Map<String, List<dynamic>> pinResults = {};
        const int concurrency = 10;
        int completedCount = 0;

        for (int i = 0; i < pinStrings.length; i += concurrency) {
          if (!mounted) return;
          final batch = pinStrings.sublist(i, math.min(i + concurrency, pinStrings.length));
          final batchFutures = batch.map((pin) async {
            final cacheK = pin.toLowerCase();
            if (_cache.containsKey(cacheK)) {
              return MapEntry(pin, _cache[cacheK]!);
            }
            try {
              final url = 'https://api.postalpincode.in/pincode/$pin';
              final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
              if (response.statusCode == 200) {
                final List<dynamic> data = jsonDecode(response.body);
                if (data.isNotEmpty && data[0]['Status'] == 'Success') {
                  final List<dynamic> postOffices = data[0]['PostOffice'] ?? [];
                  final filtered = postOffices.where((po) {
                    final rank = getOfficeRank(po);
                    return rank >= 0;
                  }).toList();
                  _cache[cacheK] = filtered;
                  return MapEntry(pin, filtered);
                }
              }
            } catch (e) {
              debugPrint('Error fetching pincode $pin in range: $e');
            }
            return MapEntry(pin, <dynamic>[]);
          });

          final entries = await Future.wait(batchFutures);
          for (final entry in entries) {
            pinResults[entry.key] = entry.value;
          }
          completedCount += batch.length;
          if (pinStrings.length > 15 && mounted) {
            setState(() {
              _loadingMessage = 'Searching range $startPin - $endPin ($completedCount/${pinStrings.length} pincodes)...';
            });
          }
        }

        final List<Map<String, dynamic>> headOffices = [];
        final List<Map<String, dynamic>> subOffices = [];
        final Set<String> usedPincodes = {};

        for (final pin in pinStrings) {
          final offices = pinResults[pin] ?? [];
          if (offices.isEmpty) continue;

          Map<String, dynamic>? ho;
          Map<String, dynamic>? so;

          for (final po in offices) {
            final rank = getOfficeRank(po);
            if (rank == 0) {
              if (ho == null) {
                ho = Map<String, dynamic>.from(po);
              } else {
                final isDelivery = (po['DeliveryStatus'] ?? '').toString().trim().toLowerCase() == 'delivery';
                final prevDelivery = (ho['DeliveryStatus'] ?? '').toString().trim().toLowerCase() == 'delivery';
                if (isDelivery && !prevDelivery) {
                  ho = Map<String, dynamic>.from(po);
                }
              }
            } else if (rank == 1) {
              if (so == null) {
                so = Map<String, dynamic>.from(po);
              } else {
                final isDelivery = (po['DeliveryStatus'] ?? '').toString().trim().toLowerCase() == 'delivery';
                final prevDelivery = (so['DeliveryStatus'] ?? '').toString().trim().toLowerCase() == 'delivery';
                if (isDelivery && !prevDelivery) {
                  so = Map<String, dynamic>.from(po);
                }
              }
            }
          }

          if (ho != null) {
            if (!usedPincodes.contains(pin)) {
              usedPincodes.add(pin);
              headOffices.add(ho);
            }
          } else if (so != null) {
            if (!usedPincodes.contains(pin)) {
              usedPincodes.add(pin);
              subOffices.add(so);
            }
          }
        }

        headOffices.sort((a, b) {
          final pA = int.tryParse((a['Pincode'] ?? '').toString()) ?? 0;
          final pB = int.tryParse((b['Pincode'] ?? '').toString()) ?? 0;
          if (pA != pB) return pA.compareTo(pB);
          return (a['Name'] ?? '').toString().compareTo((b['Name'] ?? '').toString());
        });

        subOffices.sort((a, b) {
          final pA = int.tryParse((a['Pincode'] ?? '').toString()) ?? 0;
          final pB = int.tryParse((b['Pincode'] ?? '').toString()) ?? 0;
          if (pA != pB) return pA.compareTo(pB);
          return (a['Name'] ?? '').toString().compareTo((b['Name'] ?? '').toString());
        });

        final List<dynamic> combined = [...headOffices, ...subOffices];

        if (combined.isNotEmpty) {
          _setSearchResults(cacheKey, combined);
        } else {
          setState(() {
            _offices = [];
            _errorMessage = 'No Head Offices or Sub Offices found for range $startPin - $endPin';
            _isLoading = false;
            _loadingMessage = null;
          });
        }
      } catch (e) {
        setState(() {
          _offices = [];
          _errorMessage = 'Failed to fetch range data. Please check your internet connection.';
          _isLoading = false;
          _loadingMessage = null;
        });
      }
      return;
    }

    _currentRangeQuery = null;
    _loadingMessage = null;

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

          List<dynamic> apiOffices = [];
          if (response.statusCode == 200) {
            final List<dynamic> data = jsonDecode(response.body);
            if (data.isNotEmpty && data[0]['Status'] == 'Success') {
              final List<dynamic> postOffices = data[0]['PostOffice'] ?? [];
              apiOffices = postOffices;
            }
          }

          // Combine: API post offices and local database offices associated to this pin code
          final List<dynamic> combined = _deduplicateOffices([...apiOffices, ...localMatches]);

          // Sort strictly: Head Office (0) -> Sub Office (1) -> Branch Office (2) -> Other Offices (3)
          // Within each rank, sort alphabetically by Name
          combined.sort((a, b) {
            final int rankA = getOfficeRank(a);
            final int rankB = getOfficeRank(b);
            if (rankA != rankB) {
              return rankA.compareTo(rankB);
            }
            return (a['Name'] ?? '').toString().compareTo((b['Name'] ?? '').toString());
          });

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
        combined.sort((a, b) {
          final int rankA = getOfficeRank(a);
          final int rankB = getOfficeRank(b);
          if (rankA != rankB) {
            return rankA.compareTo(rankB);
          }
          return (a['Name'] ?? '').toString().compareTo((b['Name'] ?? '').toString());
        });

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
      combined.sort((a, b) {
        final int rankA = getOfficeRank(a);
        final int rankB = getOfficeRank(b);
        if (rankA != rankB) {
          return rankA.compareTo(rankB);
        }
        return (a['Name'] ?? '').toString().compareTo((b['Name'] ?? '').toString());
      });

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
        final fileName = 'India_Post_Offices_${DateTime.now().millisecondsSinceEpoch}.xlsx';
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
      final fileName = 'India_Post_Offices_${DateTime.now().millisecondsSinceEpoch}.xlsx';
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
    final firstPin = (list[0]['Pincode'] ?? '').toString().trim();
    if (firstPin.isEmpty) return false;
    return list.every((po) => (po['Pincode'] ?? '').toString().trim() == firstPin);
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
    final int limit = count;

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

    final String currentQuery = _searchController.text.trim();
    final bool is6DigitQuery = RegExp(r'^\d{6}$').hasMatch(currentQuery);
    final bool isSamePincode = is6DigitQuery || _areAllOfficesSamePincode(_displayOffices);

    try {
      if (isSamePincode) {
        // Check for Scenario 1 (associated with Head Office) or Scenario 2 (associated with Sub Office)
        Map<String, dynamic>? headOffice;
        int headOfficeIndex = -1;

        // Check _displayOffices first for Head Office (rank 0)
        for (int i = 0; i < _displayOffices.length; i++) {
          if (getOfficeRank(_displayOffices[i]) == 0) {
            headOfficeIndex = i;
            headOffice = _displayOffices[i];
            break;
          }
        }
        // If not in _displayOffices (e.g. filtered view), check _offices
        if (headOffice == null) {
          for (final po in _offices) {
            if (getOfficeRank(po) == 0) {
              headOffice = po;
              break;
            }
          }
        }

        if (headOffice != null) {
          // =========================================================
          // SCENARIO 1: Pincode is associated with Head Office
          // Read: Head Office name then pincode, then sub office name 1 then
          // head office name, then sub office name 2 then head office name, ...
          // The pincode is read once only and associated to Head Office only.
          // =========================================================
          final String hoName = headOffice['Name'] ?? '';
          final String hoPin = (headOffice['Pincode'] ?? (is6DigitQuery ? currentQuery : '')).toString().trim();
          final String formattedPin = _formatPincodeDigitByDigit(hoPin);

          // Step 1: Read Head Office name then pincode
          if (headOfficeIndex != -1) {
            setState(() {
              _currentlyReadingIndex = headOfficeIndex;
            });
          }

          String firstSpeech = hoName;
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

          // Step 2: Read next in the list as sub office name then head office name
          for (int i = 0; i < min(_displayOffices.length, limit); i++) {
            if (!_isSpeaking || !mounted) break;
            if (i == headOfficeIndex) continue; // Already read the Head Office in Step 1

            setState(() {
              _currentlyReadingIndex = i;
            });

            final po = _displayOffices[i];
            final String subOfficeName = po['Name'] ?? '';
            final String speechText = hoName.isNotEmpty
                ? '$subOfficeName, $hoName.'
                : subOfficeName;

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
          // =========================================================
          // SCENARIO 2: Pincode is associated with Sub Office
          // Read: Sub Office name then pincode, then branch office name 1
          // then sub office name, then branch office name 2 then sub office name, ...
          // =========================================================
          Map<String, dynamic>? subOffice;
          int subOfficeIndex = -1;

          // Check _displayOffices first for Sub Office (rank 1)
          for (int i = 0; i < _displayOffices.length; i++) {
            if (getOfficeRank(_displayOffices[i]) == 1) {
              subOfficeIndex = i;
              subOffice = _displayOffices[i];
              break;
            }
          }
          // If not in _displayOffices (e.g. filtered view), check _offices
          if (subOffice == null) {
            for (final po in _offices) {
              if (getOfficeRank(po) == 1) {
                subOffice = po;
                break;
              }
            }
          }
          // Fallback if no Sub Office found (e.g. only Branch Offices)
          if (subOffice == null && _displayOffices.isNotEmpty) {
            subOfficeIndex = 0;
            subOffice = _displayOffices[0];
          }

          final String soName = subOffice != null ? (subOffice['Name'] ?? '') : '';
          final String soPin = (subOffice != null ? (subOffice['Pincode'] ?? (is6DigitQuery ? currentQuery : '')) : (is6DigitQuery ? currentQuery : '')).toString().trim();
          final String formattedPin = _formatPincodeDigitByDigit(soPin);

          // Step 1: Read Sub Office name then pincode
          if (subOfficeIndex != -1) {
            setState(() {
              _currentlyReadingIndex = subOfficeIndex;
            });
          }

          String firstSpeech = soName;
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

          // Step 2: Read next in the list as branch office name then sub office name
          for (int i = 0; i < min(_displayOffices.length, limit); i++) {
            if (!_isSpeaking || !mounted) break;
            if (i == subOfficeIndex) continue; // Already read the Sub Office in Step 1

            setState(() {
              _currentlyReadingIndex = i;
            });

            final po = _displayOffices[i];
            final String branchOfficeName = po['Name'] ?? '';
            final String speechText = soName.isNotEmpty
                ? '$branchOfficeName, $soName.'
                : branchOfficeName;

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
      } else {
        // --- DIFFERENT PINCODES LIST ---
        // Helper to find associated parent office (Head Office if present, else Sub Office) for a given pincode
        String findParentOfficeName(String pin) {
          // First check for Head Office
          for (final po in _offices) {
            if (po['Pincode'] == pin && getOfficeRank(po) == 0) {
              return po['Name'] ?? '';
            }
          }
          final cached = _cache[pin.toLowerCase()];
          if (cached != null) {
            for (final po in cached) {
              if (getOfficeRank(po) == 0) return po['Name'] ?? '';
            }
          }
          // Second check for Sub Office
          for (final po in _offices) {
            if (po['Pincode'] == pin && getOfficeRank(po) == 1) {
              return po['Name'] ?? '';
            }
          }
          if (cached != null) {
            for (final po in cached) {
              if (getOfficeRank(po) == 1) return po['Name'] ?? '';
            }
          }
          return '';
        }

        // For each item in the list:
        // If it's a Head Office or Sub Office: read office name then pincode
        // If it's a Branch Office: read branch office name then parent office name
        for (int i = 0; i < limit; i++) {
          if (!_isSpeaking || !mounted) break;

          setState(() {
            _currentlyReadingIndex = i;
          });

          final po = _displayOffices[i];
          final String name = po['Name'] ?? '';
          final String pincode = po['Pincode'] ?? '';
          final String formattedPin = _formatPincodeDigitByDigit(pincode);
          final int rank = getOfficeRank(po);

          String speechText;
          if (rank == 0 || rank == 1) {
            // Head Office or Sub Office: office name then pincode
            speechText = name;
            if (formattedPin.isNotEmpty) {
              speechText += ', Pincode $formattedPin.';
            } else {
              speechText += '.';
            }
          } else {
            // Branch Office: branch office name then parent office name
            final String parentOffice = findParentOfficeName(pincode);
            if (parentOffice.isNotEmpty && parentOffice != name) {
              speechText = '$name, $parentOffice.';
            } else if (formattedPin.isNotEmpty) {
              speechText = '$name, Pincode $formattedPin.';
            } else {
              speechText = '$name.';
            }
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
              const TopBannerAdWidget(),
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
              const BottomBannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeSelectorDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ThemeSelectorScreen(),
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
            'Independent Directory & PIN Code Finder • By Shree Lakshmi Ventures',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: currentTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Search offices by Name or Pincode in real-time',
            style: TextStyle(
              fontSize: 11.5,
              color: currentTheme.textHint,
            ),
          ),
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
            textInputAction: TextInputAction.search,
            onSubmitted: (val) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _performSearch(val);
            },
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
                        setState(() {
                          _currentRangeQuery = null;
                          _loadingMessage = null;
                        });
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
          if (_currentRangeQuery != null && _offices.isNotEmpty && !_isLoading && _errorMessage == null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: currentTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: currentTheme.primary.withOpacity(0.35), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.linear_scale_rounded, size: 14, color: currentTheme.primary),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Pincode Range: ${_currentRangeQuery!.$1} - ${_currentRangeQuery!.$2} (${_displayOffices.length} unique offices)',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: currentTheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_searchController.text.isNotEmpty && !_isLoading && _errorMessage == null && _offices.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: currentTheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: currentTheme.primary.withOpacity(0.35),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list_rounded, size: 14, color: currentTheme.primary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedOfficeTypeFilter,
                              isDense: true,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, size: 16, color: currentTheme.primary),
                              dropdownColor: currentTheme.cardBg,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: currentTheme.primary,
                              ),
                              items: const [
                                DropdownMenuItem(value: 'All Offices', child: Text('All Offices', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'NSH', child: Text('NSH', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'ICH', child: Text('ICH', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'PH', child: Text('PH', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'L1 Offices', child: Text('L1 Offices', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'L2 Offices', child: Text('L2 Offices', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'Head Office', child: Text('Head Office', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'Sub Office', child: Text('Sub Office', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'Branch Office', child: Text('Branch Office', overflow: TextOverflow.ellipsis)),
                              ],
                              onChanged: _onOfficeTypeFilterChanged,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: Tooltip(
                    message: 'Export to Excel',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _handleExportWithAd,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: currentTheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: currentTheme.primary.withOpacity(0.35),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.file_download_outlined, size: 15, color: currentTheme.primary),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Export',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: currentTheme.primary,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: Tooltip(
                    message: _isSpeaking && _currentlyReadingIndex == -1
                        ? 'Stop Dictation'
                        : 'Read / Dictate Table',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _dictateTableData,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: (_isSpeaking && _currentlyReadingIndex == -1)
                                ? Colors.redAccent.withOpacity(0.12)
                                : currentTheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: (_isSpeaking && _currentlyReadingIndex == -1)
                                  ? Colors.redAccent.withOpacity(0.5)
                                  : currentTheme.primary.withOpacity(0.35),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isSpeaking && _currentlyReadingIndex == -1
                                    ? Icons.stop_circle_outlined
                                    : Icons.record_voice_over_outlined,
                                size: 15,
                                color: _isSpeaking && _currentlyReadingIndex == -1
                                    ? Colors.redAccent
                                    : currentTheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _isSpeaking && _currentlyReadingIndex == -1 ? 'Stop' : 'Read',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: _isSpeaking && _currentlyReadingIndex == -1
                                        ? Colors.redAccent
                                        : currentTheme.primary,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(currentTheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              _loadingMessage ?? 'Searching postal database...',
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
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
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
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: currentTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: currentTheme.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: currentTheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Independent Directory App. Not affiliated with, endorsed by, or representing India Post or the Government of India.',
                      style: TextStyle(
                        fontSize: 11,
                        color: currentTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Cross-application discovery section
            YouMayAlsoLikeWidget(
              recommendationService: _recommendationService,
              primaryColor: currentTheme.primary,
              cardBgColor: currentTheme.cardBg,
              borderColor: currentTheme.border,
              textColor: currentTheme.textPrimary,
              subtextColor: currentTheme.textSecondary,
            ),
          ],
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
                      final bool canTriggerPopup = isBranchOffice;
                      final bool isRowSpeaking = _isSpeaking && _currentlyReadingIndex == index;

                      return DataRow(
                        color: isRowSpeaking
                            ? MaterialStateProperty.all(currentTheme.primary.withOpacity(0.15))
                            : null,
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AssociatedOfficeScreen(
          po: po,
          onDictate: () => _dictateSingleOffice(po, -2),
        ),
      ),
    );
  }

  void _showAppInfoDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AppInfoScreen(),
      ),
    );
  }
}

class ThemeSelectorScreen extends StatelessWidget {
  const ThemeSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: themeNotifier,
      builder: (context, currentKey, child) {
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
                  const TopBannerAdWidget(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: currentTheme.textPrimary),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
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
                                'Color Palette & Themes',
                                style: TextStyle(
                                  color: currentTheme.textPrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Choose millions of colors or preset themes',
                                style: TextStyle(
                                  color: currentTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: currentTheme.border, height: 1),
                  const Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      child: ThemePaletteContent(),
                    ),
                  ),
                  const BottomBannerAdWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ThemePaletteContent extends StatelessWidget {
  const ThemePaletteContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: themeNotifier,
      builder: (context, currentKey, child) {
        final isCustom = currentKey == 'custom';
        final hexString = '#${customThemeColor.value.toRadixString(16).substring(2).toUpperCase()}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: Millions of Colors Circle Picker Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: currentTheme.inputFill.withOpacity(0.6),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isCustom ? currentTheme.primary : currentTheme.border,
                  width: isCustom ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const SweepGradient(
                                colors: [
                                  Colors.red,
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.cyan,
                                  Colors.blue,
                                  Colors.purple,
                                  Colors.red,
                                ],
                              ),
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Millions of Colors Wheel',
                            style: TextStyle(
                              color: currentTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: customThemeColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: customThemeColor.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          hexString,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: customThemeColor.computeLuminance() > 0.55 ? Colors.black87 : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Touch or drag across the circle to choose any custom theme color.',
                    style: TextStyle(
                      color: currentTheme.textSecondary,
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: CircleColorPicker(
                      initialColor: customThemeColor,
                      size: 170,
                      onColorChanged: (color) {
                        applyAppCustomColor(color);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            applyAppCustomColor(customThemeColor, brightness: Brightness.dark);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: isCustom && customThemeBrightness == Brightness.dark
                                  ? currentTheme.primary.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isCustom && customThemeBrightness == Brightness.dark
                                    ? currentTheme.primary
                                    : currentTheme.border,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.dark_mode_outlined, size: 14, color: currentTheme.textPrimary),
                                const SizedBox(width: 6),
                                Text(
                                  'Dark Style',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: currentTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            applyAppCustomColor(customThemeColor, brightness: Brightness.light);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: isCustom && customThemeBrightness == Brightness.light
                                  ? currentTheme.primary.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isCustom && customThemeBrightness == Brightness.light
                                    ? currentTheme.primary
                                    : currentTheme.border,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.light_mode_outlined, size: 14, color: currentTheme.textPrimary),
                                const SizedBox(width: 6),
                                Text(
                                  'Light Style',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: currentTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.palette_outlined, size: 16, color: currentTheme.primary),
                const SizedBox(width: 6),
                Text(
                  'Preset Curated Themes',
                  style: TextStyle(
                    color: currentTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const PresetThemesGrid(),
          ],
        );
      },
    );
  }
}

class PresetThemesGrid extends StatelessWidget {
  const PresetThemesGrid({super.key});

  @override
  Widget build(BuildContext context) {
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
              onTap: () => changeAppTheme(key),
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
}

class AssociatedOfficeScreen extends StatelessWidget {
  final Map<String, dynamic> po;
  final VoidCallback onDictate;

  const AssociatedOfficeScreen({
    super.key,
    required this.po,
    required this.onDictate,
  });

  Widget _buildRow(String label, String value, {Color? valueColor, Color? badgeColor}) {
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

  @override
  Widget build(BuildContext context) {
    final String name = po['Name'] ?? 'Unknown';
    final String pincode = po['Pincode'] ?? '';
    final String type = getOfficeTypeLabel(po);
    final String division = po['Division'] ?? 'N/A';
    final String region = po['Region'] ?? 'N/A';
    final String circle = po['Circle'] ?? 'N/A';
    final String district = po['District'] ?? 'N/A';
    final String state = po['State'] ?? 'N/A';
    final String delivery = po['DeliveryStatus'] ?? 'N/A';
    final Color badgeColor = getBadgeColor(type);

    return ValueListenableBuilder<String>(
      valueListenable: themeNotifier,
      builder: (context, themeKey, child) {
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
                  const TopBannerAdWidget(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: currentTheme.textPrimary),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: currentTheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.account_balance,
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
                                'Associated Main Office',
                                style: TextStyle(
                                  color: currentTheme.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                name,
                                style: TextStyle(
                                  color: currentTheme.textPrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: currentTheme.border, height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: currentTheme.cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: currentTheme.border),
                          boxShadow: [
                            BoxShadow(
                              color: currentTheme.shadow,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildRow('Office Type', type, badgeColor: badgeColor),
                            const SizedBox(height: 12),
                            _buildRow('Pincode', pincode, valueColor: currentTheme.primary),
                            const SizedBox(height: 12),
                            _buildRow(
                              'Delivery Status',
                              delivery,
                              valueColor: delivery.toLowerCase() == 'delivery'
                                  ? currentTheme.secondary
                                  : const Color(0xFFEF4444),
                            ),
                            const SizedBox(height: 12),
                            _buildRow('District', district),
                            const SizedBox(height: 12),
                            _buildRow('State', state),
                            const SizedBox(height: 12),
                            _buildRow('Division', division),
                            const SizedBox(height: 12),
                            _buildRow('Region', region),
                            const SizedBox(height: 12),
                            _buildRow('Circle', circle),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: currentTheme.scaffoldBgStart.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: currentTheme.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.source_outlined, size: 16, color: currentTheme.primary),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Data Source Attribution',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: currentTheme.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    po['isLocal'] == true
                                        ? 'Source: Department of Posts Sortation Hub Directory (Catchment Parcel Routing).'
                                        : 'Source: Public Postal Directory via api.postalpincode.in (derived from Open Government Data Platform India, data.gov.in).',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: currentTheme.textSecondary,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  InkWell(
                                    onTap: () => launchAppUrl('https://www.indiapost.gov.in'),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.open_in_new, size: 12, color: currentTheme.secondary),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Verify on Official India Post: indiapost.gov.in',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: currentTheme.secondary,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: onDictate,
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
                                    child: const Text('Back to Search', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const BottomBannerAdWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: themeNotifier,
      builder: (context, themeKey, child) {
        return DefaultTabController(
          length: 4,
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
                child: Column(
                  children: [
                    const TopBannerAdWidget(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: currentTheme.textPrimary),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
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
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Version $appLocalVersion (Build $appLocalBuild)',
                                  style: TextStyle(
                                    color: currentTheme.textHint,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: currentTheme.border, height: 1),
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
                      ],
                    ),
                    Divider(color: currentTheme.border, height: 1),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Tab 1: About
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444).withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.gavel, color: Color(0xFFEF4444), size: 18),
                                          SizedBox(width: 8),
                                          Text(
                                            'Non-Affiliation Disclaimer',
                                            style: TextStyle(
                                              color: Color(0xFFEF4444),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'India Post Offices is an independent utility application developed by Shree Lakshmi Ventures. This app is NOT affiliated with, endorsed by, sponsored by, or an official application of India Post or the Government of India. The application does not represent any government entity and does not provide official government services.',
                                        style: TextStyle(
                                          color: currentTheme.textSecondary,
                                          fontSize: 12,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
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
                                  'India Post Offices is a lookup utility that helps users find postal PIN codes, office names, delivery statuses, branch types, and postal administrative divisions across India.',
                                  style: TextStyle(
                                    color: currentTheme.textSecondary,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Information Sources & Field Coverage',
                                  style: TextStyle(
                                    color: currentTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Government-related postal information in this application is compiled from publicly accessible open sources:',
                                  style: TextStyle(
                                    color: currentTheme.textSecondary,
                                    fontSize: 12.5,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Source 1: India Post
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: currentTheme.scaffoldBgStart.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: currentTheme.border),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '1. Department of Posts (India Post)',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: currentTheme.textPrimary),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Official authority for PIN code allocation, postal circles, and administrative divisions.',
                                        style: TextStyle(fontSize: 11.5, color: currentTheme.textSecondary),
                                      ),
                                      const SizedBox(height: 4),
                                      InkWell(
                                        onTap: () => launchAppUrl('https://www.indiapost.gov.in'),
                                        child: Text(
                                          'URL: https://www.indiapost.gov.in',
                                          style: TextStyle(fontSize: 11, color: currentTheme.primary, decoration: TextDecoration.underline),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Source 2: Open Government Data
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: currentTheme.scaffoldBgStart.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: currentTheme.border),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '2. Open Government Data (OGD) Platform India',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: currentTheme.textPrimary),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Publisher of the All India Pincode Directory dataset under Government Open Data License - India (GODL).',
                                        style: TextStyle(fontSize: 11.5, color: currentTheme.textSecondary),
                                      ),
                                      const SizedBox(height: 4),
                                      InkWell(
                                        onTap: () => launchAppUrl('https://data.gov.in'),
                                        child: Text(
                                          'URL: https://data.gov.in',
                                          style: TextStyle(fontSize: 11, color: currentTheme.primary, decoration: TextDecoration.underline),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Source 3: Postal PIN Code API
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: currentTheme.scaffoldBgStart.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: currentTheme.border),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '3. Postal PIN Code API (Community API)',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: currentTheme.textPrimary),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Public directory API endpoint supplying search records: Post Office Name, PIN Code, Branch Type (HO/SO/BO), Delivery Status, Circle, District, Division, Region, Taluk/Block, and State.',
                                        style: TextStyle(fontSize: 11.5, color: currentTheme.textSecondary),
                                      ),
                                      const SizedBox(height: 4),
                                      InkWell(
                                        onTap: () => launchAppUrl('https://api.postalpincode.in'),
                                        child: Text(
                                          'URL: https://api.postalpincode.in',
                                          style: TextStyle(fontSize: 11, color: currentTheme.primary, decoration: TextDecoration.underline),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Source 4: Department of Posts Sortation Hub Directory
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: currentTheme.scaffoldBgStart.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: currentTheme.border),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '4. Department of Posts Sortation Hub Directory',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: currentTheme.textPrimary),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Offline parcel sortation master schema mapping PIN code ranges to Level 1 / Level 2 Parcel Hubs and Circles (Sortplan Id, L1 Office Name, L2 Office Name, Hub Level, Circle Name, From Pin, To Pin).',
                                        style: TextStyle(fontSize: 11.5, color: currentTheme.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Note: Individual records in this app are provided for informational reference and are not individually certified or officially verified by India Post. For official postal bookings or services, visit indiapost.gov.in.',
                                  style: TextStyle(
                                    color: currentTheme.textHint,
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
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
                          const SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(16),
                            child: ThemePaletteContent(),
                          ),
                          // Tab 3: Privacy Policy
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(16),
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
                                  onPressed: () => launchAppUrl('https://policies.google.com/privacy'),
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
                                _buildPrivacySubHeading('7. Government Disclaimer & Information Sources'),
                                _buildPrivacyText(
                                  'India Post Offices is an independent utility application developed by Shree Lakshmi Ventures and is NOT affiliated with, endorsed by, sponsored by, or an official application of India Post or the Government of India. The application does not represent any government entity or provide official government services.\n\n'
                                  'Government-related postal directory information presented within the app is sourced from public data platforms:\n'
                                  '• Department of Posts, Government of India: https://www.indiapost.gov.in (Official postal administration authority)\n'
                                  '• Open Government Data (OGD) Platform India: https://data.gov.in (All India Pincode Directory dataset under GODL-India)\n'
                                  '• Postal PIN Code API: https://api.postalpincode.in (Public community API)\n'
                                  '• Department of Posts Sortation Hub Directory (Catchment Parcel Routing master dataset)',
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
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
                                      onPressed: () => launchAppUrl('https://www.indiapost.gov.in'),
                                    ),
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        side: BorderSide(color: currentTheme.primary.withOpacity(0.5)),
                                      ),
                                      icon: Icon(Icons.open_in_new, size: 14, color: currentTheme.primary),
                                      label: Text(
                                        'Data.gov.in Portal',
                                        style: TextStyle(fontSize: 11.5, color: currentTheme.primary),
                                      ),
                                      onPressed: () => launchAppUrl('https://data.gov.in'),
                                    ),
                                  ],
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
                                  onPressed: () => launchAppUrl('https://github.com/Lokanath862001/India-Post-Offices/blob/main/PRIVACY_POLICY.md'),
                                ),
                              ],
                            ),
                          ),
                          // Tab 4: Features
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(16),
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
                        ],
                      ),
                    ),
                    const BottomBannerAdWidget(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
