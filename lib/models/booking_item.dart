class BookingItem {
  final String studioID;
  final int roomType;
  final int classID;
  final DateTime classBookingDate;
  final String classBookingTime;
  final String customerID;
  final String contractID;
  final int accessCardNumber;
  final bool isActive;
  final bool isRelease;
  final bool isConfirm;
  final int classMapNumber;
  final String createby;
  final DateTime createdate;

  BookingItem({
    required this.studioID,
    required this.roomType,
    required this.classID,
    required this.classBookingDate,
    required this.classBookingTime,
    required this.customerID,
    required this.contractID,
    required this.accessCardNumber,
    required this.isActive,
    required this.isRelease,
    required this.isConfirm,
    required this.classMapNumber,
    required this.createby,
    required this.createdate,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) {
    return BookingItem(
      studioID: json['studioID']?.toString() ?? '',
      roomType: json['RoomType'] is int
          ? json['RoomType']
          : int.tryParse(json['RoomType'].toString()) ?? 0,
      classID: json['ClassID'] is int
          ? json['ClassID']
          : int.tryParse(json['ClassID'].toString()) ?? 0,
      classBookingDate:
          DateTime.tryParse(json['ClassBookingDate'].toString()) ??
              DateTime.now(),
      classBookingTime: json['ClassBookingTime']?.toString() ?? '',
      customerID: json['customerID']?.toString() ?? '',
      contractID: json['ContractID']?.toString() ?? '',
      accessCardNumber: json['AccessCardNumber'] is int
          ? json['AccessCardNumber']
          : int.tryParse(json['AccessCardNumber'].toString()) ?? 0,
      isActive: json['isActive'] == true || json['isActive'] == 1,
      isRelease: json['isRelease'] == true || json['isRelease'] == 1,
      isConfirm: json['isConfirm'] == true || json['isConfirm'] == 1,
      classMapNumber: json['ClassMapNumber'] is int
          ? json['ClassMapNumber']
          : int.tryParse(json['ClassMapNumber'].toString()) ?? 0,
      createby: json['createby']?.toString() ?? '',
      createdate:
          DateTime.tryParse(json['createdate'].toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studioID': studioID,
      'RoomType': roomType,
      'ClassID': classID,
      'ClassBookingDate':
          '${classBookingDate.year}-${classBookingDate.month.toString().padLeft(2, '0')}-${classBookingDate.day.toString().padLeft(2, '0')}',
      'ClassBookingTime': classBookingTime,
      'customerID': customerID,
      'ContractID': contractID,
      'AccessCardNumber': accessCardNumber,
      'isActive': isActive,
      'isRelease': isRelease,
      'isConfirm': isConfirm,
      'ClassMapNumber': classMapNumber,
      'createby': createby,
      'createdate': createdate.toIso8601String(),
    };
  }
}
