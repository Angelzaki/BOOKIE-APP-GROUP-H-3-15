// import 'package:bookieapp/app/injection_container.dart';
// import 'package:bookieapp/data/source/network/api.dart';

// abstract class AuthRepo {
//   Future<String>login(String idToken);
// }

// class AuthRepoImpl extends AuthRepo{
//   final Api _api = sl<Api>();

//   @override
//   bool operator ==(Object other) {
//     // TODO: implement ==
//     return super == other;
//   }
// }


abstract class AuthRepository {
  Future<void> sendIdToken({required String idToken});
}