import 'package:bookieapp/domain/entities/story.dart';

class StoryModel extends Story {

  StoryModel({
    required int id,
    required String title,
   });

  // Método para convertir un JSON en un objeto Chapter
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'],
      title: json['title'],
    );
  }

  // Método para convertir un objeto Chapter a JSON (opcional)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,

    };
  }
}
