

/*La clase DTO nos servira para poder convertir los datos del servidor que vienen
en formato Map a Objeto */
import 'package:bookieapp/domain/entities/story.dart';

class StoryDto extends Story{
  StoryDto({
    super.id,
    super.title,
});

  factory StoryDto.toObject(Map<String,dynamic>json){
    return StoryDto(
      id:json["id"],
      title: json["title"],
    );
  }

  Map<String,dynamic>toMap()=>{
    'id': id,
    'title': title,
  };
}