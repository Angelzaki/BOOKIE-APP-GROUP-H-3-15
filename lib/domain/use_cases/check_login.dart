import 'package:bookieapp/domain/repository/auth_repository.dart';

class CheckLoginStatusUseCase {
  AuthRepository authRepository;
  
  CheckLoginStatusUseCase(this.authRepository);

  Future<bool> call(){
    return authRepository.isLoggedIn();
  }


}
