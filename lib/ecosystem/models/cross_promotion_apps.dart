/// Strongly typed model for fixed cross-promotion applications.
class CrossPromotionApp {
  final String name;
  final String applicationId;
  final String playStoreUrl;

  const CrossPromotionApp({
    required this.name,
    required this.applicationId,
    required this.playStoreUrl,
  });
}

/// The EXACT, IMMUTABLE fixed cross-promotion production configuration.
/// Absolutely NO dynamic generation, NO external discovery, and NO modified URLs.
const List<CrossPromotionApp> crossPromotionApps = [
  CrossPromotionApp(
    name: 'India Post Offices',
    applicationId: 'com.oedc.indiaPostOffices',
    playStoreUrl:
        'https://play.google.com/store/apps/details?id=com.oedc.indiaPostOffices',
  ),
  CrossPromotionApp(
    name: 'OEDC Baby Learning',
    applicationId: 'com.oedc.babylearning',
    playStoreUrl:
        'https://play.google.com/store/apps/details?id=com.oedc.babylearning',
  ),
  CrossPromotionApp(
    name: 'OEDC MindSphere AI',
    applicationId: 'com.oedc.mindsphereai',
    playStoreUrl:
        'https://play.google.com/store/apps/details?id=com.oedc.mindsphereai',
  ),
  CrossPromotionApp(
    name: 'SLV Daily Inspire AI',
    applicationId: 'com.slv.daily_inspire_ai',
    playStoreUrl:
        'https://play.google.com/store/apps/details?id=com.slv.daily_inspire_ai',
  ),
];

/// Exact set of allowed Play Store URLs.
const Set<String> allowedPlayStoreUrls = {
  'https://play.google.com/store/apps/details?id=com.oedc.indiaPostOffices',
  'https://play.google.com/store/apps/details?id=com.oedc.babylearning',
  'https://play.google.com/store/apps/details?id=com.oedc.mindsphereai',
  'https://play.google.com/store/apps/details?id=com.slv.daily_inspire_ai',
};

/// Exact set of allowed application IDs.
const Set<String> allowedApplicationIds = {
  'com.oedc.indiaPostOffices',
  'com.oedc.babylearning',
  'com.oedc.mindsphereai',
  'com.slv.daily_inspire_ai',
};
