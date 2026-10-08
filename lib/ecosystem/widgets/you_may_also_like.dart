import 'package:flutter/material.dart';
import '../models/ecosystem_app.dart';
import '../services/recommendation_service.dart';
import 'ecosystem_app_card.dart';

/// The "You May Also Like" cross-application discovery widget.
/// Renders ONLY the eligible apps from the fixed 4-app list.
class YouMayAlsoLikeWidget extends StatefulWidget {
  final RecommendationService recommendationService;
  final Color primaryColor;
  final Color cardBgColor;
  final Color borderColor;
  final Color textColor;
  final Color subtextColor;

  const YouMayAlsoLikeWidget({
    super.key,
    required this.recommendationService,
    required this.primaryColor,
    required this.cardBgColor,
    required this.borderColor,
    required this.textColor,
    required this.subtextColor,
  });

  @override
  State<YouMayAlsoLikeWidget> createState() => _YouMayAlsoLikeWidgetState();
}

class _YouMayAlsoLikeWidgetState extends State<YouMayAlsoLikeWidget> {
  late final List<VerifiedEcosystemApp> _recommendations;

  @override
  void initState() {
    super.initState();
    // Load & randomize fixed eligible applications once per session
    _recommendations = widget.recommendationService.getRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    if (_recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    final int appCount = _recommendations.length;

    return Container(
      margin: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Divider
          Divider(color: widget.borderColor.withOpacity(0.6), thickness: 1),
          const SizedBox(height: 12),

          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You May Also Like',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                  color: widget.textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'More apps by the same developer',
                style: TextStyle(fontSize: 11.5, color: widget.subtextColor),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Adaptive Grid Layout based on EXACT number of verified apps
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 550;
              final crossAxisCount = (appCount == 1)
                  ? 1
                  : (isWide
                        ? (appCount == 2 ? 2 : (appCount == 3 ? 3 : 4))
                        : 2);

              final aspectRatio = (appCount == 1) ? 2.8 : (isWide ? 1.4 : 1.25);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: _recommendations.length,
                itemBuilder: (context, index) {
                  final app = _recommendations[index];
                  return EcosystemAppCard(
                    app: app,
                    primaryColor: widget.primaryColor,
                    cardBgColor: widget.cardBgColor,
                    borderColor: widget.borderColor,
                    textColor: widget.textColor,
                    subtextColor: widget.subtextColor,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
