class Chapter {
  final int storyId;
  final String title;
  final String content;
  final double latitude;
  final double longitude;
  final int numberChapter;

  Chapter({
    required this.storyId,
    required this.title,
    required this.content,
    required this.latitude,
    required this.longitude,
    required this.numberChapter,
  });

  // Método para convertir un JSON en un objeto Chapter
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      storyId: json['storyId'],
      title: json['title'],
      content: json['content'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      numberChapter: json['numberChapter'],
    );
  }

  // Método para convertir un objeto Chapter a JSON (opcional)
  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'title': title,
      'content': content,
      'latitude': latitude,
      'longitude': longitude,
      'numberChapter': numberChapter,
    };
  }
}
