class UserModel {
  String id;
  String name;
  String email;
  String avatarUrl;
  String customerID;
  String birthDate;
  String phone;
  String noIdentity;
  String lastContractID;
  String toStudioID;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.customerID = '',
    this.birthDate = '',
    this.phone = '',
    this.noIdentity = '',
    this.lastContractID = '',
    this.toStudioID = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        avatarUrl: json['avatarUrl'] ?? '',
        customerID: json['customerID']?.toString() ?? '',
        birthDate: json['birthDate'] ?? '',
        phone: json['phone'] ?? '',
        noIdentity: json['noIdentity'] ?? '',
        lastContractID: json['lastContractID']?.toString() ?? '',
        toStudioID: json['toStudioID']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'customerID': customerID,
        'birthDate': birthDate,
        'phone': phone,
        'noIdentity': noIdentity,
        'lastContractID': lastContractID,
        'toStudioID': toStudioID,
      };
}
