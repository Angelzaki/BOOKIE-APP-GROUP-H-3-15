import 'package:bookieapp/domain/entities/story.dart';
import 'package:bookieapp/domain/models/Story.dart';
import 'package:bookieapp/domain/repository/story_repository.dart';

import 'package:bookieapp/data/source/library_data.dart';
 /*En repositorios implementaremos las acciones que definimos en la capa de dominio y aqui vamos a
 * dar funcionalidad conectandonos con el api y realizando lo que corresponde en este caso consultar*/
 class StoryRepositoryImpl implements StoryRepository{
   final StoryDataSourceImpl _storyDataSourceImpl;

   StoryRepositoryImpl({required StoryDataSourceImpl
  storyDataSourceImpl}):_storyDataSourceImpl = storyDataSourceImpl;
   @override
   Future<List<Story>> getStories({int id = 0}) async{
     final fetchList = await _storyDataSourceImpl.loadStory(id: id);
     return fetchList;
   }

 }