import 'cross_promotion_apps.dart';

/// Represents a validated cross-promotion application bound immutably to its exact Play Store URL.
class VerifiedEcosystemApp {
  final String applicationId;
  final String name;
  final String playStoreUrl;

  const VerifiedEcosystemApp({
    required this.applicationId,
    required this.name,
    required this.playStoreUrl,
  });

  /// Factory from fixed configuration record.
  factory VerifiedEcosystemApp.fromFixed(CrossPromotionApp app) {
    return VerifiedEcosystemApp(
      applicationId: app.applicationId,
      name: app.name,
      playStoreUrl: app.playStoreUrl,
    );
  }

  /// Strict URL & ID Integrity check.
  bool isValid({required String currentApplicationId}) {
    final cleanId = applicationId.trim();
    if (cleanId.isEmpty || cleanId == currentApplicationId.trim()) {
      return false;
    }

    if (!allowedApplicationIds.contains(cleanId)) {
      return false;
    }

    if (!allowedPlayStoreUrls.contains(playStoreUrl.trim())) {
      return false;
    }

    // Verify exact immutable 1-to-1 pairing
    for (final fixed in crossPromotionApps) {
      if (fixed.applicationId == cleanId) {
        return fixed.playStoreUrl == playStoreUrl && fixed.name == name;
      }
    }

    return false;
  }
}
