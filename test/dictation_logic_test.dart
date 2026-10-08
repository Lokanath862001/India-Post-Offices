import 'package:flutter_test/flutter_test.dart';

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
      name.contains(' SO ') ||
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

String formatPincodeDigitByDigit(String pincode) {
  final cleanPin = pincode.replaceAll(RegExp(r'\D'), '');
  if (cleanPin.isEmpty) return pincode;
  return cleanPin.split('').join(', ');
}

List<String> generateDictationSequence({
  required List<Map<String, dynamic>> displayOffices,
  required List<Map<String, dynamic>> allOffices,
  required bool isSamePincode,
}) {
  final List<String> speechSequence = [];

  if (isSamePincode) {
    Map<String, dynamic>? headOffice;
    int headOfficeIndex = -1;

    for (int i = 0; i < displayOffices.length; i++) {
      if (getOfficeRank(displayOffices[i]) == 0) {
        headOfficeIndex = i;
        headOffice = displayOffices[i];
        break;
      }
    }
    if (headOffice == null) {
      for (final po in allOffices) {
        if (getOfficeRank(po) == 0) {
          headOffice = po;
          break;
        }
      }
    }

    if (headOffice != null) {
      // Scenario 1: Pincode associated with Head Office
      // Pincode is read once only and associated to Head Office only
      final String hoName = headOffice['Name'] ?? '';
      final String hoPin = headOffice['Pincode'] ?? '';
      final String formattedPin = formatPincodeDigitByDigit(hoPin);

      String firstSpeech = hoName;
      if (formattedPin.isNotEmpty) {
        firstSpeech += ', Pincode $formattedPin.';
      } else {
        firstSpeech += '.';
      }
      speechSequence.add(firstSpeech);

      // Sub offices read as sub office name then head office name (NO pincode)
      for (int i = 0; i < displayOffices.length; i++) {
        if (i == headOfficeIndex) continue;
        final po = displayOffices[i];
        final String subOfficeName = po['Name'] ?? '';
        final String speechText = hoName.isNotEmpty
            ? '$subOfficeName, $hoName.'
            : subOfficeName;
        speechSequence.add(speechText);
      }
    } else {
      // Scenario 2: Pincode associated with Sub Office
      Map<String, dynamic>? subOffice;
      int subOfficeIndex = -1;

      for (int i = 0; i < displayOffices.length; i++) {
        if (getOfficeRank(displayOffices[i]) == 1) {
          subOfficeIndex = i;
          subOffice = displayOffices[i];
          break;
        }
      }
      if (subOffice == null) {
        for (final po in allOffices) {
          if (getOfficeRank(po) == 1) {
            subOffice = po;
            break;
          }
        }
      }
      if (subOffice == null && displayOffices.isNotEmpty) {
        subOfficeIndex = 0;
        subOffice = displayOffices[0];
      }

      final String soName = subOffice != null ? (subOffice['Name'] ?? '') : '';
      final String soPin = subOffice != null ? (subOffice['Pincode'] ?? '') : '';
      final String formattedPin = formatPincodeDigitByDigit(soPin);

      String firstSpeech = soName;
      if (formattedPin.isNotEmpty) {
        firstSpeech += ', Pincode $formattedPin.';
      } else {
        firstSpeech += '.';
      }
      speechSequence.add(firstSpeech);

      for (int i = 0; i < displayOffices.length; i++) {
        if (i == subOfficeIndex) continue;
        final po = displayOffices[i];
        final String branchOfficeName = po['Name'] ?? '';
        final String speechText = soName.isNotEmpty
            ? '$branchOfficeName, $soName.'
            : branchOfficeName;
        speechSequence.add(speechText);
      }
    }
  }

  return speechSequence;
}

void main() {
  group('Dictation Scenarios', () {
    test('Scenario 1: Head Office with Delivery and Non-Delivery Sub Offices - Pincode read once only', () {
      final offices = [
        {'Name': 'New Delhi G.P.O.', 'BranchType': 'Head Post Office', 'DeliveryStatus': 'Delivery', 'Pincode': '110001'},
        {'Name': 'Connaught Place S.O', 'BranchType': 'Sub Post Office', 'DeliveryStatus': 'Non-Delivery', 'Pincode': '110001'},
        {'Name': 'Barakhamba Road S.O', 'BranchType': 'Sub Post Office', 'DeliveryStatus': 'Non-Delivery', 'Pincode': '110001'},
        {'Name': 'Janpath S.O', 'BranchType': 'Sub Post Office', 'DeliveryStatus': 'Non-Delivery', 'Pincode': '110001'},
      ];

      // Verify that Non-Delivery Sub Offices are listed as Sub Office
      expect(getOfficeTypeLabel(offices[1]), 'Sub Office');
      expect(getOfficeTypeLabel(offices[2]), 'Sub Office');
      expect(getOfficeTypeLabel(offices[3]), 'Sub Office');

      final sequence = generateDictationSequence(
        displayOffices: offices,
        allOffices: offices,
        isSamePincode: true,
      );

      expect(sequence.length, 4);
      // 1. Head Office name then pincode (ONCE ONLY)
      expect(sequence[0], 'New Delhi G.P.O., Pincode 1, 1, 0, 0, 0, 1.');
      // 2. Sub Office 1 name then Head Office name (NO pincode)
      expect(sequence[1], 'Connaught Place S.O, New Delhi G.P.O..');
      // 3. Sub Office 2 name then Head Office name (NO pincode)
      expect(sequence[2], 'Barakhamba Road S.O, New Delhi G.P.O..');
      // 4. Sub Office 3 name then Head Office name (NO pincode)
      expect(sequence[3], 'Janpath S.O, New Delhi G.P.O..');

      // Verify no subsequent speech contains "Pincode"
      for (int i = 1; i < sequence.length; i++) {
        expect(sequence[i].contains('Pincode'), isFalse);
      }
    });

    test('Scenario 2: Pincode associated with Sub Office', () {
      final offices = [
        {'Name': 'Malleswaram S.O', 'BranchType': 'Sub Post Office', 'DeliveryStatus': 'Delivery', 'Pincode': '560003'},
        {'Name': 'Vyalikaval B.O', 'BranchType': 'Branch Post Office', 'DeliveryStatus': 'Delivery', 'Pincode': '560003'},
        {'Name': 'Swimming Pool B.O', 'BranchType': 'Branch Post Office', 'DeliveryStatus': 'Non-Delivery', 'Pincode': '560003'},
      ];

      final sequence = generateDictationSequence(
        displayOffices: offices,
        allOffices: offices,
        isSamePincode: true,
      );

      expect(sequence.length, 3);
      // 1. Sub Office name then pincode
      expect(sequence[0], 'Malleswaram S.O, Pincode 5, 6, 0, 0, 0, 3.');
      // 2. Branch Office 1 name then Sub Office name
      expect(sequence[1], 'Vyalikaval B.O, Malleswaram S.O.');
      // 3. Branch Office 2 name then Sub Office name
      expect(sequence[2], 'Swimming Pool B.O, Malleswaram S.O.');

      for (int i = 1; i < sequence.length; i++) {
        expect(sequence[i].contains('Pincode'), isFalse);
      }
    });

    test('6-digit pincode search ordering: Head Office -> Sub Office -> Branch Office -> Other Offices', () {
      final rawList = [
        {'Name': 'Delhi RMS Sorting Hub', 'BranchType': 'Sorting Hub', 'Pincode': '110001'},
        {'Name': 'Janpath B.O', 'BranchType': 'Branch Post Office', 'Pincode': '110001'},
        {'Name': 'New Delhi G.P.O.', 'BranchType': 'Head Post Office', 'Pincode': '110001'},
        {'Name': 'Barakhamba Road B.O', 'BranchType': 'Branch Post Office', 'Pincode': '110001'},
        {'Name': 'Connaught Place S.O', 'BranchType': 'Sub Post Office', 'DeliveryStatus': 'Non-Delivery', 'Pincode': '110001'},
        {'Name': 'Delhi NSH L1', 'BranchType': 'National Sorting Hub', 'Pincode': '110001'},
      ];

      rawList.sort((a, b) {
        final int rankA = getOfficeRank(a);
        final int rankB = getOfficeRank(b);
        if (rankA != rankB) {
          return rankA.compareTo(rankB);
        }
        return (a['Name'] ?? '').toString().compareTo((b['Name'] ?? '').toString());
      });

      // 1. Head Office first (rank 0)
      expect(rawList[0]['Name'], 'New Delhi G.P.O.');
      expect(getOfficeRank(rawList[0]), 0);

      // 2. Sub Office second (rank 1) - including Non-Delivery
      expect(rawList[1]['Name'], 'Connaught Place S.O');
      expect(getOfficeRank(rawList[1]), 1);
      expect(getOfficeTypeLabel(rawList[1]), 'Sub Office');

      // 3. Branch Offices third (rank 2, sorted by Name)
      expect(rawList[2]['Name'], 'Barakhamba Road B.O');
      expect(getOfficeRank(rawList[2]), 2);
      expect(rawList[3]['Name'], 'Janpath B.O');
      expect(getOfficeRank(rawList[3]), 2);

      // 4. Other offices fourth (rank 3, sorted by Name)
      expect(rawList[4]['Name'], 'Delhi NSH L1');
      expect(getOfficeRank(rawList[4]), 3);
      expect(rawList[5]['Name'], 'Delhi RMS Sorting Hub');
      expect(getOfficeRank(rawList[5]), 3);
    });
  });
}
