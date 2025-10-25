class BookingListItem {
  final String name;
  final String contractID;
  final int accessCardNumber;
  final String studioName;
  final String roomName;
  final String className;
  final String classBookingDate;
  final String classBookingTime;
  final String timeClsEnd;
  final int classMapNumber;
  final bool isActive;
  final bool isConfirm;
  final bool isRelease;
  final String teacher1Name;
  final String? teacher2Name;

  BookingListItem({
    required this.name,
    required this.contractID,
    required this.accessCardNumber,
    required this.studioName,
    required this.roomName,
    required this.className,
    required this.classBookingDate,
    required this.classBookingTime,
    required this.timeClsEnd,
    required this.classMapNumber,
    required this.isActive,
    required this.isConfirm,
    required this.isRelease,
    required this.teacher1Name,
    this.teacher2Name,
  });

  factory BookingListItem.fromJson(Map<String, dynamic> json) {
    return BookingListItem(
      name: json['name']?.toString() ?? '',
      contractID: json['ContractID']?.toString() ?? '',
      accessCardNumber: json['AccessCardNumber'] is int
          ? json['AccessCardNumber']
          : int.tryParse(json['AccessCardNumber'].toString()) ?? 0,
      studioName: json['StudioName']?.toString() ?? '',
      roomName: json['RoomName']?.toString() ?? '',
      className: json['ClassName']?.toString() ?? '',
      classBookingDate: json['ClassBookingDate']?.toString() ?? '',
      classBookingTime: json['ClassBookingTime']?.toString() ?? '',
      timeClsEnd: json['TimeClsEnd']?.toString() ?? '',
      classMapNumber: json['ClassMapNumber'] is int
          ? json['ClassMapNumber']
          : int.tryParse(json['ClassMapNumber'].toString()) ?? 0,
      isActive: json['isActive'] == true || json['isActive'] == 1,
      isConfirm: json['isConfirm'] == true || json['isConfirm'] == 1,
      isRelease: json['isRelease'] == true || json['isRelease'] == 1,
      teacher1Name: json['Teacher1Name']?.toString() ?? '',
      teacher2Name: json['Teacher2Name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ContractID': contractID,
      'AccessCardNumber': accessCardNumber,
      'StudioName': studioName,
      'RoomName': roomName,
      'ClassName': className,
      'ClassBookingDate': classBookingDate,
      'ClassBookingTime': classBookingTime,
      'TimeClsEnd': timeClsEnd,
      'ClassMapNumber': classMapNumber,
      'isActive': isActive,
      'isConfirm': isConfirm,
      'isRelease': isRelease,
      'Teacher1Name': teacher1Name,
      'Teacher2Name': teacher2Name,
    };
  }

  // Computed status based on the logic
  String get status {
    if (isRelease) {
      return 'Closed';
    } else if (isConfirm) {
      return 'Confirmed';
    } else if (isActive) {
      return 'pending';
    } else {
      return 'Unknown';
    }
  }
}
