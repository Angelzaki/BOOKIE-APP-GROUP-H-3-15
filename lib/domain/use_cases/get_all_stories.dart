// import 'package:arquitectura_limpia/domain/entity/character.dart';
// import '../repository/character_repository.dart';

/* En useCase Crearemos un archivo por cada accion que realizaremos y este se comunicara
con la capa de datos y presentacion.
*/

import 'package:bookieapp/domain/entities/story.dart';
import 'package:bookieapp/domain/repository/story_repository.dart';

class GetAllStories{
  final StoryRepository _repository;
  GetAllStories(this._repository);


  Future<List<Story>> call({int id=0})async{
    final list = await _repository.getStories(id: id);
    return list;
  }
}