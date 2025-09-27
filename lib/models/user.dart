class UserModel {
  String id;
  String name;
  String email;
  String avatarUrl;

  UserModel({required this.id, required this.name, required this.email, required this.avatarUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'].toString(),
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    avatarUrl: json['avatarUrl'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
  };
}
