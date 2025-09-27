class GymClass {
  final String id;
  final String title;
  final String image;
  final String description;
  final double price;
  final double rating;
  final String trainerId;

  GymClass({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.rating,
    required this.trainerId,
  });

  factory GymClass.fromJson(Map<String, dynamic> json) => GymClass(
    id: json['id'].toString(),
    title: json['title'] ?? '',
    image: json['image'] ?? '',
    description: json['description'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    rating: (json['rating'] ?? 0).toDouble(),
    trainerId: json['trainerId'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image': image,
    'description': description,
    'price': price,
    'rating': rating,
    'trainerId': trainerId,
  };
}
