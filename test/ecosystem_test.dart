import 'package:flutter_test/flutter_test.dart';
import 'package:india_post_offices/ecosystem/models/cross_promotion_apps.dart';
import 'package:india_post_offices/ecosystem/models/ecosystem_app.dart';
import 'package:india_post_offices/ecosystem/services/recommendation_service.dart';

void main() {
  group('Fixed 4-App Cross-Promotion Configuration Tests', () {
    test('Config contains EXACTLY four candidate records', () {
      expect(crossPromotionApps.length, 4);
    });

    test('1. OEDC India Post Offices Finder exact URL mapping', () {
      final app = crossPromotionApps.firstWhere(
        (a) => a.applicationId == 'com.oedc.indiaPostOffices',
      );
      expect(app.name, 'OEDC India Post Offices Finder');
      expect(
        app.playStoreUrl,
        'https://play.google.com/store/apps/details?id=com.oedc.indiaPostOffices',
      );
    });

    test('2. OEDC Baby Learning exact URL mapping', () {
      final app = crossPromotionApps.firstWhere(
        (a) => a.applicationId == 'com.oedc.babylearning',
      );
      expect(app.name, 'OEDC Baby Learning');
      expect(
        app.playStoreUrl,
        'https://play.google.com/store/apps/details?id=com.oedc.babylearning',
      );
    });

    test('3. OEDC MindSphere AI exact URL mapping', () {
      final app = crossPromotionApps.firstWhere(
        (a) => a.applicationId == 'com.oedc.mindsphereai',
      );
      expect(app.name, 'OEDC MindSphere AI');
      expect(
        app.playStoreUrl,
        'https://play.google.com/store/apps/details?id=com.oedc.mindsphereai',
      );
    });

    test('4. SLV Daily Inspire AI exact URL mapping', () {
      final app = crossPromotionApps.firstWhere(
        (a) => a.applicationId == 'com.slv.daily_inspire_ai',
      );
      expect(app.name, 'SLV Daily Inspire AI');
      expect(
        app.playStoreUrl,
        'https://play.google.com/store/apps/details?id=com.slv.daily_inspire_ai',
      );
    });

    test('No fifth application exists', () {
      final ids = crossPromotionApps.map((a) => a.applicationId).toSet();
      expect(ids, {
        'com.oedc.indiaPostOffices',
        'com.oedc.babylearning',
        'com.oedc.mindsphereai',
        'com.slv.daily_inspire_ai',
      });
    });

    test('No unverified or external URL exists in allowedPlayStoreUrls', () {
      expect(allowedPlayStoreUrls.length, 4);
      for (final app in crossPromotionApps) {
        expect(allowedPlayStoreUrls, contains(app.playStoreUrl));
      }
    });
  });

  group('Current App Exclusion & Integrity Tests', () {
    test(
      'Current app = com.oedc.indiaPostOffices -> excludes OEDC India Post Offices Finder, returns other 3',
      () {
        final service = RecommendationService(
          currentApplicationId: 'com.oedc.indiaPostOffices',
        );
        final recs = service.getRecommendations();

        expect(recs.length, 3);
        expect(
          recs.any((a) => a.applicationId == 'com.oedc.indiaPostOffices'),
          isFalse,
        );
        expect(
          recs.any((a) => a.applicationId == 'com.oedc.babylearning'),
          isTrue,
        );
        expect(
          recs.any((a) => a.applicationId == 'com.oedc.mindsphereai'),
          isTrue,
        );
        expect(
          recs.any((a) => a.applicationId == 'com.slv.daily_inspire_ai'),
          isTrue,
        );
      },
    );

    test(
      'Current app = com.oedc.babylearning -> excludes OEDC Baby Learning, returns other 3',
      () {
        final service = RecommendationService(
          currentApplicationId: 'com.oedc.babylearning',
        );
        final recs = service.getRecommendations();

        expect(recs.length, 3);
        expect(
          recs.any((a) => a.applicationId == 'com.oedc.babylearning'),
          isFalse,
        );
        expect(
          recs.any((a) => a.applicationId == 'com.oedc.indiaPostOffices'),
          isTrue,
        );
      },
    );

    test(
      'Current app = com.oedc.mindsphereai -> excludes OEDC MindSphere AI, returns other 3',
      () {
        final service = RecommendationService(
          currentApplicationId: 'com.oedc.mindsphereai',
        );
        final recs = service.getRecommendations();

        expect(recs.length, 3);
        expect(
          recs.any((a) => a.applicationId == 'com.oedc.mindsphereai'),
          isFalse,
        );
      },
    );

    test(
      'Current app = com.slv.daily_inspire_ai -> excludes SLV Daily Inspire AI, returns other 3',
      () {
        final service = RecommendationService(
          currentApplicationId: 'com.slv.daily_inspire_ai',
        );
        final recs = service.getRecommendations();

        expect(recs.length, 3);
        expect(
          recs.any((a) => a.applicationId == 'com.slv.daily_inspire_ai'),
          isFalse,
        );
      },
    );

    test('When current app is outside the four -> all four appear', () {
      final service = RecommendationService(
        currentApplicationId: 'com.other.application',
      );
      final recs = service.getRecommendations();

      expect(recs.length, 4);
    });

    test('Cross-mapped or modified URLs fail validation', () {
      // Swapping Baby Learning's URL onto MindSphere AI
      const tamperedApp = VerifiedEcosystemApp(
        applicationId: 'com.oedc.mindsphereai',
        name: 'OEDC MindSphere AI',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.oedc.babylearning', // tampered
      );

      expect(
        tamperedApp.isValid(currentApplicationId: 'com.oedc.indiaPostOffices'),
        isFalse,
      );
    });

    test('Unknown 5th application fails validation', () {
      const fifthApp = VerifiedEcosystemApp(
        applicationId: 'com.oedc.somefutureapp',
        name: 'OEDC Some Future App',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.oedc.somefutureapp',
      );

      expect(
        fifthApp.isValid(currentApplicationId: 'com.oedc.indiaPostOffices'),
        isFalse,
      );
    });
  });
}
