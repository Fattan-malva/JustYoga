class Trainer {
  final String id;
  final String name;
  final String avatar;
  final String bio;
  final List<String> specialties;

  Trainer({
    required this.id,
    required this.name,
    required this.avatar,
    required this.bio,
    required this.specialties,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
    id: json['id'].toString(),
    name: json['name'] ?? '',
    avatar: json['avatar'] ?? '',
    bio: json['bio'] ?? '',
    specialties: List<String>.from(json['specialties'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar,
    'bio': bio,
    'specialties': specialties,
  };
}
