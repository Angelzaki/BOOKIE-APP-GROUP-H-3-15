import 'package:bookieapp/domain/repository/auth_repository.dart';

class LogOutUseCase {
  final AuthRepository authRepository;

  LogOutUseCase(this.authRepository);

  Future<void> call() async {
    await authRepository.logOut();
  }
}
