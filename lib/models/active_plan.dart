class ActivePlan {
  final String name;
  final String productName;
  final bool status;
  final String productID;
  final String contractID;
  final String startDate;
  final String endDate;

  ActivePlan({
    required this.name,
    required this.productName,
    required this.status,
    required this.productID,
    required this.contractID,
    required this.startDate,
    required this.endDate,
  });

  factory ActivePlan.fromJson(Map<String, dynamic> json) {
    return ActivePlan(
      name: json['name'] ?? '',
      productName: json['productName'] ?? '',
      status: json['status'] ?? false,
      productID: json['productID'] ?? '',
      contractID: json['contractID'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }
}
