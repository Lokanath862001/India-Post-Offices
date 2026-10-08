import 'dart:math';
import '../models/cross_promotion_apps.dart';
import '../models/ecosystem_app.dart';

/// RecommendationService
/// Operates exclusively from the EXACT fixed 4-app configuration.
/// 1. Excludes current application.
/// 2. Randomizes the remaining eligible apps (entire record moves together: name + id + exact URL).
/// 3. Never generates URLs or discovers outside applications.
class RecommendationService {
  final String currentApplicationId;
  final Random _random;

  RecommendationService({required this.currentApplicationId, Random? random})
    : _random = random ?? Random();

  /// Retrieve eligible recommendations from the fixed list.
  List<VerifiedEcosystemApp> getRecommendations() {
    final eligible = crossPromotionApps
        .map((app) => VerifiedEcosystemApp.fromFixed(app))
        .where((app) => app.isValid(currentApplicationId: currentApplicationId))
        .toList();

    // Randomize order of complete records
    eligible.shuffle(_random);
    return eligible;
  }
}
