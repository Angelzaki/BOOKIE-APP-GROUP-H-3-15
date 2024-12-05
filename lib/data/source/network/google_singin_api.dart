import "package:google_sign_in/google_sign_in.dart";


class GoogleSingInApi{
  static final _googleSignIn = GoogleSignIn(
    clientId: '166753661653-bretvp5d4f10bk70rimqiqdlcriveevn.apps.googleusercontent.com',
    scopes: ['email', 'openid']
  );

  // Iniciar sesión y obtener los datos de autenticación
  static Future<GoogleSignInAccount?> login() async {
    try {
      // Realizar el login con Google
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user == null){
        print("El inicio de sesion fue cancelado por el usuario");
        return null;
      }
      
      final GoogleSignInAuthentication auth = await user.authentication;
      final String? idToken = auth.idToken;
      if (idToken != null) {
        print('ID Token: $idToken'); // Imprimir el ID Token
      } else {
        print("ID Token es null. Verifica tus alcances o configuración.");
      }
      return user;
    } catch (e) {
      print("Error durante el login: $e");
      return null;
    }
  }

  static Future singOut = _googleSignIn.signOut(); 
}