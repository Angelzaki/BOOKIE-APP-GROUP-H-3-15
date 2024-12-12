import 'package:bookieapp/domain/entities/story.dart';
import 'package:bookieapp/domain/use_cases/get_all_stories.dart';
import 'package:bookieapp/ui/store/main_store.dart';
import 'package:mobx/mobx.dart';

part 'story_store.g.dart';

class StoryStore = _StoryStore with _$StoryStore;

// abstract class _AuthStore with Store {
//   final MainStore main;
//   final SendIdToken sendTokenUseCase;
//   final CheckLoginStatusUseCase checkLoginStatusUseCase;
//   final LogOutUseCase logOutUseCase;


//   _AuthStore({required this.main, required this.sendTokenUseCase, required this.checkLoginStatusUseCase, required this.logOutUseCase});

abstract class _StoryStore with Store {
  final MainStore main;
  final GetAllStories getAllStories;

  _StoryStore({required this.main, required this.getAllStories});

  @observable
  List<Story> stories = [];

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = '';

  @action
  Future<void> fetchStories({int id = 0}) async {
    isLoading = true;
    try {
      stories = await getAllStories.call(id: id);
      if (stories.isEmpty) {
        errorMessage = 'No se encontraron historias.';
      } else {
        errorMessage = '';
      }
    } catch (e) {
      errorMessage = 'Failed to load stories';
      stories = [];
    } finally {
      isLoading = false;
    }
  }
}
