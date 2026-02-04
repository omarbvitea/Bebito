class Memory {
  final String id;
  final DateTime createdAt;
  final String title;
  final String? coverImage;

  Memory({
    required this.id,
    required this.createdAt,
    required this.title,
    this.coverImage,
  });

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      title: json['title'],
      coverImage: json['cover_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'title': title,
      'cover_image': coverImage,
    };
  }
}
