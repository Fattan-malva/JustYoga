class ActivationModel {
  String customerID;
  String name;
  String birthDate;
  String phone;
  String noIdentity;
  String email;
  String lastContractID;

  ActivationModel({
    required this.customerID,
    required this.name,
    required this.birthDate,
    required this.phone,
    required this.noIdentity,
    required this.email,
    required this.lastContractID,
  });

  factory ActivationModel.fromJson(Map<String, dynamic> json) =>
      ActivationModel(
        customerID: json['customerID']?.toString() ?? '',
        name: json['name'] ?? '',
        birthDate: json['birthDate'] ?? '',
        phone: json['phone'] ?? '',
        noIdentity: json['noIdentity'] ?? '',
        email: json['email'] ?? '',
        lastContractID: json['lastContractID']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'customerID': customerID,
        'name': name,
        'birthDate': birthDate,
        'phone': phone,
        'noIdentity': noIdentity,
        'email': email,
        'lastContractID': lastContractID,
      };
}
