// import 'package:arquitectura_limpia/domain/entity/character.dart';
/*Creamos clases abstractas donde especificamos las acciones que haremos por ejemplo:
Consultar, Crear, Actualizar, eliminar, etc.
*/
import 'package:bookieapp/domain/entities/story.dart';

abstract class StoryRepository{
  Future<List<Story>> getStories({int id=0});
}