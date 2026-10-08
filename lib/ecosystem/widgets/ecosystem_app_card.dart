import 'package:flutter/material.dart';
import '../models/ecosystem_app.dart';
import '../services/play_store_service.dart';

/// Card displaying an individual application from the fixed cross-promotion list.
class EcosystemAppCard extends StatelessWidget {
  final VerifiedEcosystemApp app;
  final Color primaryColor;
  final Color cardBgColor;
  final Color borderColor;
  final Color textColor;
  final Color subtextColor;

  const EcosystemAppCard({
    super.key,
    required this.app,
    required this.primaryColor,
    required this.cardBgColor,
    required this.borderColor,
    required this.textColor,
    required this.subtextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header Row: App Icon + Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAppIcon(),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  app.name,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Action Button: Opens the EXACT assigned Play Store URL
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: () {
                PlayStoreService.openPlayStore(
                  packageName: app.applicationId,
                  explicitUrl: app.playStoreUrl,
                );
              },
              child: const Text(
                'GET APP',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon() {
    IconData iconData = Icons.apps_rounded;
    if (app.applicationId.contains('indiaPostOffices')) {
      iconData = Icons.local_post_office_rounded;
    } else if (app.applicationId.contains('babylearning')) {
      iconData = Icons.child_care_rounded;
    } else if (app.applicationId.contains('mindsphereai')) {
      iconData = Icons.psychology_rounded;
    } else if (app.applicationId.contains('daily_inspire_ai')) {
      iconData = Icons.auto_awesome_rounded;
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: Center(child: Icon(iconData, size: 24, color: primaryColor)),
    );
  }
}
