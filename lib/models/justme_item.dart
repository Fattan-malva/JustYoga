class JustMeItem {
  final String trxDate;
  final String toStudioID;
  final String tchID;
  final String employeeName;
  final String studioName;
  final int sequence;
  final String timeFrom;
  final String timeTo;
  final bool isBook;
  final String createdDate;
  final String createdBy;

  JustMeItem({
    required this.trxDate,
    required this.toStudioID,
    required this.tchID,
    required this.employeeName,
    required this.studioName,
    required this.sequence,
    required this.timeFrom,
    required this.timeTo,
    required this.isBook,
    required this.createdDate,
    required this.createdBy,
  });

  factory JustMeItem.fromJson(Map<String, dynamic> json) {
    return JustMeItem(
      trxDate: json['TrxDate'],
      toStudioID: json['toStudioID'],
      tchID: json['TchID'],
      employeeName: json['EmployeeName'],
      studioName: json['StudioName'],
      sequence: json['Sequence'],
      timeFrom: json['TimeFrom'],
      timeTo: json['TimeTo'],
      isBook: json['isBook'],
      createdDate: json['CreatedDate'],
      createdBy: json['CreatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TrxDate': trxDate,
      'toStudioID': toStudioID,
      'TchID': tchID,
      'EmployeeName': employeeName,
      'StudioName': studioName,
      'Sequence': sequence,
      'TimeFrom': timeFrom,
      'TimeTo': timeTo,
      'isBook': isBook,
      'CreatedDate': createdDate,
      'CreatedBy': createdBy,
    };
  }
}
