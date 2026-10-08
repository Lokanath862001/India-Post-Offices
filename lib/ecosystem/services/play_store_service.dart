import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service responsible for securely launching Google Play Store listings.
/// Supports both native Play Store market URI scheme (market://details?id=...)
/// and standard official HTTPS fallback (https://play.google.com/store/apps/details?id=...).
class PlayStoreService {
  /// Open an app's Google Play Store listing.
  /// Strictly prevents silent installation and directs user to the official store page.
  static Future<bool> openPlayStore({
    required String packageName,
    String? explicitUrl,
  }) async {
    final cleanPackage = packageName.trim();
    if (cleanPackage.isEmpty) return false;

    final targetUrl = (explicitUrl != null && explicitUrl.isNotEmpty)
        ? explicitUrl
        : 'https://play.google.com/store/apps/details?id=$cleanPackage';

    try {
      final marketUri = Uri.parse('market://details?id=$cleanPackage');
      final webUri = Uri.parse(targetUrl);

      // On Android devices, try native Play Store app first
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        if (await canLaunchUrl(marketUri)) {
          final launched = await launchUrl(
            marketUri,
            mode: LaunchMode.externalApplication,
          );
          if (launched) return true;
        }
      }

      // Universal fallback to official HTTPS Play Store URL
      if (await canLaunchUrl(webUri)) {
        return await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('[PlayStoreService] Error launching Play Store: $e');
    }
    return false;
  }
}
