class RoomType {
  final int roomType;
  final String roomName;

  RoomType({
    required this.roomType,
    required this.roomName,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      roomType: json['RoomType'] ?? 0,
      roomName: json['RoomName'] ?? 'Unknown Room',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RoomType': roomType,
      'RoomName': roomName,
    };
  }
}
