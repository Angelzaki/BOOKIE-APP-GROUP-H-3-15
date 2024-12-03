import 'package:bookieapp/ui/store/main_store.dart';
import 'package:mobx/mobx.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../domain/use_cases/send_id_token.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final MainStore main;
  final SendIdToken sendTokenUseCase;

  _AuthStore({required this.main, required this.sendTokenUseCase});

  @observable
  bool loading = false;

  @observable
  bool hasSession = false;

  @observable
  bool success = false;

  // Método para iniciar sesión
  @action
  Future<void> signInWithGoogle() async {
    loading = true;
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        clientId: '166753661653-bretvp5d4f10bk70rimqiqdlcriveevn.apps.googleusercontent.com',
        scopes: ['email', 'openid'],
      );
      // await _googleSignIn.signOut();
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final GoogleSignInAuthentication auth = await user.authentication;
        final String? idToken = auth.idToken;
        if (idToken != null) {
          await sendTokenUseCase(idToken: idToken);
          success = true;
          hasSession = true;
        }
      }
    } catch (e) {
      success = false;
      hasSession = false;
      print('Error al iniciar sesión con Google: $e');
    } finally {
      loading = false;
    }
  }

  // Método para cerrar sesión
  @action
  Future<void> logOut() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      success = false;
      hasSession = false;
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
}
