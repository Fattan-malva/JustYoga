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
      studioID: json['studioID'].toString(),
      roomType: json['RoomType'],
      classID: json['ClassID'],
      classBookingDate: DateTime.parse(json['ClassBookingDate']),
      classBookingTime: json['ClassBookingTime'],
      customerID: json['customerID'],
      contractID: json['ContractID'],
      accessCardNumber: json['AccessCardNumber'],
      isActive: json['isActive'],
      isRelease: json['isRelease'],
      isConfirm: json['isConfirm'],
      classMapNumber: json['ClassMapNumber'],
      createby: json['createby'],
      createdate: DateTime.parse(json['createdate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studioID': studioID,
      'RoomType': roomType,
      'ClassID': classID,
      'ClassBookingDate': classBookingDate.toIso8601String(),
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
