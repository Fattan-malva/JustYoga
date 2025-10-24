class JustMeHistory {
  final String productName;
  final String startDate;
  final String endDate;
  final int remainSession;

  JustMeHistory({
    required this.productName,
    required this.startDate,
    required this.endDate,
    required this.remainSession,
  });

  factory JustMeHistory.fromJson(Map<String, dynamic> json) {
    return JustMeHistory(
      productName: json['productName'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      remainSession: json['remainSession'] ?? 0,
    );
  }
}
