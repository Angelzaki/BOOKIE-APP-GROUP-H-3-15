

import 'package:bookieapp/data/dto/library_dto.dart';
import 'package:bookieapp/domain/entities/story.dart';
import 'package:bookieapp/domain/models/Story.dart';
import 'package:bookieapp/domain/repository/story_repository.dart';

import 'network/api.dart';

abstract class StoryRemoteDataSource {
  Future<List<StoryDto>> loadStory({int id = 0});
}

/*Aqui vamos a ejeucta nuestros enpoint especifico para poder realizar las acciones en
 en el servidor*/
class StoryDataSourceImpl implements StoryRemoteDataSource {
  Api api;

  StoryDataSourceImpl(this.api);

  @override
  Future<List<StoryDto>> loadStory({int id = 0}) async {
    Map<String, dynamic> jsonResponse = await api.get("library/$id");

    // Verificamos si la respuesta es una lista
    if (jsonResponse is List) {
      return (jsonResponse as List).map((storyMaper) => StoryDto.toObject(storyMaper)).toList();
    } else {
      return [];
    }
  }
}





