import 'package:bookieapp/app/injection_container.dart';
import 'package:bookieapp/domain/use_cases/check_login.dart';
import 'package:bookieapp/domain/use_cases/get_all_stories.dart';
import 'package:bookieapp/domain/use_cases/logout_case.dart';
import 'package:bookieapp/ui/store/auth/auth_store.dart';
import 'package:bookieapp/ui/store/story/story_store.dart';
import 'package:mobx/mobx.dart';
import '../../../domain/use_cases/send_id_token.dart'; // Importa el caso de uso

part 'main_store.g.dart';

class MainStore = _MainStoreBase with _$MainStore;

abstract class _MainStoreBase with Store {
  late AuthStore authStore;
  late StoryStore storyStore;

  _MainStoreBase() {
    // Pasa sendTokenUseCase al inicializar authStore
    authStore = AuthStore(main: this as MainStore, sendTokenUseCase: sl<SendIdToken>(), checkLoginStatusUseCase: sl<CheckLoginStatusUseCase>(), logOutUseCase: sl<LogOutUseCase>());
    storyStore = StoryStore(main: this as MainStore, getAllStories: sl<GetAllStories>());
  }
}
