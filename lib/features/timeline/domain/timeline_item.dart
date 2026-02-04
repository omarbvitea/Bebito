class TimelineItem {
  final String id;
  final String memoryId;
  final DateTime date;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? icon;
  final DateTime createdAt;

  TimelineItem({
    required this.id,
    required this.memoryId,
    required this.date,
    required this.title,
    this.description,
    this.imageUrl,
    this.icon,
    required this.createdAt,
  });

  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    return TimelineItem(
      id: json['id'],
      memoryId: json['memory_id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      icon: json['icon'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memory_id': memoryId,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'icon': icon,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
