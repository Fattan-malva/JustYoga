class PlanHistory {
  final String productName;
  final String startDate;
  final String endDate;
  final String trxDate;

  PlanHistory({
    required this.productName,
    required this.startDate,
    required this.endDate,
    required this.trxDate,
  });

  factory PlanHistory.fromJson(Map<String, dynamic> json) {
    return PlanHistory(
      productName: json['productName'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      trxDate: json['trxDate'] ?? '',
    );
  }
}
