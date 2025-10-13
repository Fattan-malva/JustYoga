class ScheduleItem {
  final String timeCls;
  final String studioName;
  final String className;
  final String? roomName;
  final String? teacher1;
  final String? teacher2;
  final String? timeClsEnd;
  final int? roomType;
  final int totalMap;
  final String uniqCode;
  final int? studioID;
  final int? classID;

  ScheduleItem({
    required this.timeCls,
    required this.studioName,
    required this.className,
    this.roomName,
    this.teacher1,
    this.teacher2,
    this.timeClsEnd,
    this.roomType,
    required this.totalMap,
    required this.uniqCode,
    this.studioID,
    this.classID,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      timeCls: json['TimeCls'],
      studioName: json['StudioName'],
      className: json['ClassName'],
      roomName: json['RoomName'],
      teacher1: json['Teacher1'],
      teacher2: json['Teacher2'],
      timeClsEnd: json['TimeClsEnd'],
      roomType: json['RoomType'],
      totalMap: json['TotalMap'],
      uniqCode: json['UniqCode'],
      studioID: json['studioID'],
      classID: json['ClassID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TimeCls': timeCls,
      'StudioName': studioName,
      'ClassName': className,
      'RoomName': roomName,
      'Teacher1': teacher1,
      'Teacher2': teacher2,
      'TimeClsEnd': timeClsEnd,
      'RoomType': roomType,
      'TotalMap': totalMap,
      'UniqCode': uniqCode,
      'StudioID': studioID,
      'ClassID': classID,
    };
  }
}
