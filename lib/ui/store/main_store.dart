import 'package:bookieapp/app/injection_container.dart';
import 'package:bookieapp/ui/store/auth/auth_store.dart';
import 'package:mobx/mobx.dart';
import '../../../domain/use_cases/send_id_token.dart'; // Importa el caso de uso

part 'main_store.g.dart';

class MainStore = _MainStoreBase with _$MainStore;

abstract class _MainStoreBase with Store {
  late AuthStore authStore;

  _MainStoreBase() {
    // Pasa sendTokenUseCase al inicializar authStore
    authStore = AuthStore(main: this as MainStore, sendTokenUseCase: sl<SendIdToken>());
  }
}
