
import 'package:bookieapp/data/source/auth_data.dart';
import 'package:bookieapp/domain/repository/auth_repository.dart';
// import 'package:bookieapp/domain/use_cases/send_id_token.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSourceImpl _authDataSourceImpl;

  AuthRepositoryImpl({required AuthDataSourceImpl
  authDataSourceImpl}):_authDataSourceImpl = authDataSourceImpl;
  @override
  Future<void> sendIdToken({required String idToken}) async {
    final fetchPost = await _authDataSourceImpl.sendIdToken(idToken: idToken);
    return fetchPost;
  }

}
