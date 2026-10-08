import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';

(int, int)? tryParsePincodeRange(String input) {
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

void main() {
  test('Pincode range parsing tests', () {
    expect(tryParsePincodeRange('110001 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001-110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001 - 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001 to 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001 TO 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001, 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001,110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001/110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001..110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001: 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001; 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001_110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001 ~ 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001 | 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110001 -> 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('pin 110001 - 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('pincode 110001 to 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('from 110001 to 110005'), equals((110001, 110005)));
    expect(tryParsePincodeRange('110005 110001'), equals((110001, 110005))); // reversed
    expect(tryParsePincodeRange('  110001   110005  '), equals((110001, 110005)));

    // Non-range inputs
    expect(tryParsePincodeRange('110001'), isNull);
    expect(tryParsePincodeRange('110001 110001'), isNull); // same pin
    expect(tryParsePincodeRange('1100011 110005'), isNull); // 7 digits
    expect(tryParsePincodeRange('New Delhi'), isNull);
    expect(tryParsePincodeRange('Office near 110001 and far from 110005'), isNull);
  });

  test('Process range offices - HO first, SO second, unique pincodes, no pincode repeats', () {
    int getOfficeRank(Map<String, dynamic> po) {
      if (po['isLocal'] == true) return -2;
      final name = (po['Name'] ?? '').toString().toUpperCase();
      final branchType = (po['BranchType'] ?? '').toString().toUpperCase();

      if (branchType.contains('HEAD') ||
          name.contains('H.O.') ||
          name.endsWith(' H.O') ||
          name.contains(' HPO')) {
        return 0;
      }
      if (branchType.contains('SUB') ||
          name.contains('S.O.') ||
          name.endsWith(' S.O') ||
          name.contains(' SO ')) {
        return 1;
      }
      if (branchType.contains('BRANCH') ||
          name.contains('B.O.') ||
          name.endsWith(' B.O') ||
          name.contains(' BO ')) {
        return 2;
      }
      return -1;
    }

    List<Map<String, dynamic>> processRangeOffices(
      List<String> pinStrings,
      Map<String, List<dynamic>> pinResults,
    ) {
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

      return [...headOffices, ...subOffices];
    }

    final pinResults = {
      '560001': [
        {'Name': 'Bangalore G.P.O.', 'BranchType': 'Head Post Office', 'Pincode': '560001', 'DeliveryStatus': 'Delivery'},
        {'Name': 'Bangalore Bazaar S.O', 'BranchType': 'Sub Post Office', 'Pincode': '560001', 'DeliveryStatus': 'Non-Delivery'},
      ],
      '560002': [
        {'Name': 'Bangalore City S.O', 'BranchType': 'Sub Post Office', 'Pincode': '560002', 'DeliveryStatus': 'Delivery'},
      ],
      '560003': [
        {'Name': 'Malleswaram S.O', 'BranchType': 'Sub Post Office', 'Pincode': '560003', 'DeliveryStatus': 'Delivery'},
      ],
      '560004': [
        {'Name': 'Basavanagudi H.O', 'BranchType': 'Head Post Office', 'Pincode': '560004', 'DeliveryStatus': 'Delivery'},
        {'Name': 'Mavalli S.O', 'BranchType': 'Sub Post Office', 'Pincode': '560004', 'DeliveryStatus': 'Non-Delivery'},
      ],
    };

    final result = processRangeOffices(
      ['560001', '560002', '560003', '560004'],
      pinResults,
    );

    // Should have 4 items: exactly 1 per pincode
    expect(result.length, 4);

    // Head offices come first (560001, 560004)
    expect(result[0]['Name'], 'Bangalore G.P.O.');
    expect(result[0]['Pincode'], '560001');
    expect(result[0]['BranchType'], 'Head Post Office');

    expect(result[1]['Name'], 'Basavanagudi H.O');
    expect(result[1]['Pincode'], '560004');
    expect(result[1]['BranchType'], 'Head Post Office');

    // Sub offices come second (560002, 560003)
    expect(result[2]['Name'], 'Bangalore City S.O');
    expect(result[2]['Pincode'], '560002');
    expect(result[2]['BranchType'], 'Sub Post Office');

    expect(result[3]['Name'], 'Malleswaram S.O');
    expect(result[3]['Pincode'], '560003');
    expect(result[3]['BranchType'], 'Sub Post Office');

    // Verify uniqueness: no pincode repeats
    final pincodes = result.map((po) => po['Pincode']).toList();
    expect(pincodes.toSet().length, pincodes.length);
    expect(pincodes, ['560001', '560004', '560002', '560003']);
  });
}
