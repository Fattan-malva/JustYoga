class ScheduleItem {
  final String timeCls;
  final String studioName;
  final String className;
  final String? roomName;
  final String teacher1;
  final String? teacher2;

  ScheduleItem({
    required this.timeCls,
    required this.studioName,
    required this.className,
    this.roomName,
    required this.teacher1,
    this.teacher2,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      timeCls: json['TimeCls'],
      studioName: json['StudioName'],
      className: json['ClassName'],
      roomName: json['RoomName'],
      teacher1: json['Teacher1'],
      teacher2: json['Teacher2'],
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
    };
  }
}
