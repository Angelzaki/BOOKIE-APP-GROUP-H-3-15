// import 'package:bookieapp/domain/entities/user.dart';
import 'package:bookieapp/domain/repository/auth_repository.dart';

class SendIdToken {
  AuthRepository authRepository;

  SendIdToken(this.authRepository);
  

  Future<void> call({required String idToken}) async{
    return await authRepository.sendIdToken(idToken: idToken);
  }
}