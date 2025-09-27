class Booking {
  final String id;
  final String classId;
  final String userId;
  final DateTime date;
  final String status;

  Booking({
    required this.id,
    required this.classId,
    required this.userId,
    required this.date,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'].toString(),
    classId: json['classId'] ?? '',
    userId: json['userId'] ?? '',
    date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    status: json['status'] ?? 'booked',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'classId': classId,
    'userId': userId,
    'date': date.toIso8601String(),
    'status': status,
  };
}
