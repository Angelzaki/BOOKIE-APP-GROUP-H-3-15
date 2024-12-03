abstract class AuthRepository {
  Future<void> sendIdToken({required String idToken});

  // Future<bool>
  Future<bool> isLoggedIn();

  Future<void> logOut();
}