import 'package:flutter_test/flutter_test.dart';

// Standalone filter testing helper mirroring the implementation in _displayOffices
List<dynamic> filterOffices(List<dynamic> offices, String selectedFilter) {
  if (selectedFilter == 'All Offices' || selectedFilter == 'All') return offices;

  String getOfficeTypeLabel(Map<String, dynamic> po) {
    final name = (po['Name'] ?? po['name'] ?? '').toString().toUpperCase();
    final branchType = (po['BranchType'] ?? po['branchType'] ?? '').toString().toUpperCase();
    final type = (po['Type'] ?? po['type'] ?? '').toString().toUpperCase();

    if (branchType.contains('HEAD') || type.contains('HEAD') || name.contains('H.O.') || name.endsWith(' H.O') || name.contains(' HPO') || name.contains('HEAD POST OFFICE')) {
      return 'Head Office';
    }
    if (branchType.contains('SUB') || type.contains('SUB') || name.contains('S.O.') || name.endsWith(' S.O') || name.contains(' SO ') || name.contains('SUB POST OFFICE')) {
      return 'Sub Office';
    }
    if (branchType.contains('BRANCH') || type.contains('BRANCH') || name.contains('B.O.') || name.endsWith(' B.O') || name.contains(' BO ') || name.contains('BRANCH POST OFFICE')) {
      return 'Branch Office';
    }
    if (po['isLocal'] == true) {
      final hub = po['HubLevel'] ?? '';
      return hub.isNotEmpty ? 'Local ($hub)' : 'Local Data';
    }
    final bType = (po['BranchType'] ?? po['Type'] ?? '').toString().trim();
    return bType.isNotEmpty ? bType : 'Other Office';
  }

  return offices.where((po) {
    final typeLabel = getOfficeTypeLabel(po).toUpperCase();
    final hub = (po['HubLevel'] ?? po['hubLevel'] ?? '').toString().toUpperCase();
    final l1 = (po['L1OfficeName'] ?? po['l1OfficeName'] ?? '').toString().toUpperCase();
    final l2 = (po['L2OfficeName'] ?? po['l2OfficeName'] ?? '').toString().toUpperCase();
    final name = (po['Name'] ?? po['name'] ?? '').toString().toUpperCase();
    final branchType = (po['BranchType'] ?? '').toString().toUpperCase();

    if (selectedFilter == 'NSH') {
      return l1.contains('NSH') || l2.contains('NSH') || name.contains('NSH') || typeLabel.contains('NSH') || branchType.contains('NSH');
    }
    if (selectedFilter == 'ICH') {
      return l1.contains('ICH') || l2.contains('ICH') || name.contains('ICH') || typeLabel.contains('ICH') || branchType.contains('ICH');
    }
    if (selectedFilter == 'PH') {
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
    if (selectedFilter == 'L1 Offices') {
      return hub == 'L1' || typeLabel.contains('L1');
    }
    if (selectedFilter == 'L2 Offices') {
      return hub == 'L2' || typeLabel.contains('L2');
    }
    return true;
  }).toList();
}

void main() {
  group('Office Type Filter - PH and Parcel', () {
    final sampleOffices = [
      // Parcel hub offices with "Parcel" in name
      {'Name': 'Bengaluru Parcel Hub (Bengaluru Parcel Hub)', 'L1OfficeName': 'Bengaluru Parcel Hub', 'L2OfficeName': 'Bengaluru Parcel Hub', 'isLocal': true, 'HubLevel': 'L1'},
      {'Name': 'Integrated Parcel Hub AMPC', 'L1OfficeName': 'Integrated Parcel Hub AMPC', 'L2OfficeName': 'Integrated Parcel Hub AMPC', 'isLocal': true, 'HubLevel': 'L1'},
      {'Name': 'L1 Parcel Hub Aizawl', 'L1OfficeName': 'L1 Parcel Hub Aizawl', 'L2OfficeName': 'L1 Parcel Hub Aizawl', 'isLocal': true, 'HubLevel': 'L1'},
      {'Name': 'Delhi Parcel Processing Centre', 'BranchType': 'Parcel Hub', 'Pincode': '110001'},
      // PH offices with "PH"
      {'Name': 'Hyderabad PH', 'L1OfficeName': 'Hyderabad PH', 'L2OfficeName': 'Hyderabad PH', 'isLocal': true, 'HubLevel': 'L1'},
      {'Name': 'PH DIBRUGARH', 'L1OfficeName': 'PH DIBRUGARH', 'L2OfficeName': 'PH DIBRUGARH', 'isLocal': true, 'HubLevel': 'L1'},
      {'Name': 'Ananthapur PH (Bengaluru Parcel Hub)', 'L1OfficeName': 'Bengaluru Parcel Hub', 'L2OfficeName': 'Ananthapur PH', 'isLocal': true, 'HubLevel': 'L2'},
      // Other hub offices
      {'Name': 'Delhi NSH L1', 'L1OfficeName': 'Delhi NSH', 'L2OfficeName': 'Delhi NSH', 'isLocal': true, 'HubLevel': 'L1'},
      {'Name': 'Mumbai ICH', 'L1OfficeName': 'Mumbai ICH', 'L2OfficeName': 'Mumbai ICH', 'isLocal': true, 'HubLevel': 'L1'},
      // Non-PH offices that contain letters 'PH' inside unrelated town names
      {'Name': 'Phaltan S.O', 'BranchType': 'Sub Post Office', 'Pincode': '415523'},
      {'Name': 'St. Joseph B.O', 'BranchType': 'Branch Post Office', 'Pincode': '600001'},
      {'Name': 'Phulbani H.O', 'BranchType': 'Head Post Office', 'Pincode': '762001'},
      {'Name': 'Connaught Place S.O', 'BranchType': 'Sub Post Office', 'Pincode': '110001'},
    ];

    test('Selected office type PH displays both PH and Parcel office names', () {
      final filtered = filterOffices(sampleOffices, 'PH');

      final names = filtered.map((po) => po['Name']).toList();

      // Parcel office names must be displayed
      expect(names.contains('Bengaluru Parcel Hub (Bengaluru Parcel Hub)'), isTrue);
      expect(names.contains('Integrated Parcel Hub AMPC'), isTrue);
      expect(names.contains('L1 Parcel Hub Aizawl'), isTrue);
      expect(names.contains('Delhi Parcel Processing Centre'), isTrue);

      // PH offices must be displayed
      expect(names.contains('Hyderabad PH'), isTrue);
      expect(names.contains('PH DIBRUGARH'), isTrue);
      expect(names.contains('Ananthapur PH (Bengaluru Parcel Hub)'), isTrue);

      // Other offices and false positive names containing 'ph' must NOT be displayed
      expect(names.contains('Delhi NSH L1'), isFalse);
      expect(names.contains('Mumbai ICH'), isFalse);
      expect(names.contains('Phaltan S.O'), isFalse);
      expect(names.contains('St. Joseph B.O'), isFalse);
      expect(names.contains('Phulbani H.O'), isFalse);
      expect(names.contains('Connaught Place S.O'), isFalse);

      expect(filtered.length, 7);
    });

    test('Selected office type NSH only displays NSH offices', () {
      final filtered = filterOffices(sampleOffices, 'NSH');
      expect(filtered.length, 1);
      expect(filtered[0]['Name'], 'Delhi NSH L1');
    });

    test('Selected office type All Offices displays all offices', () {
      final filtered = filterOffices(sampleOffices, 'All Offices');
      expect(filtered.length, sampleOffices.length);
    });
  });
}
