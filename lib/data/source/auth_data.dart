

import 'network/api.dart';

abstract class AuthDataSource {
  // Future<List<CharacterDto>> loadCharacter({int page = 0});
  Future<void>sendIdToken({required String idToken});
}

/*Aqui vamos a ejeucta nuestros enpoint especifico para poder realizar las acciones en
 en el servidor*/
class AuthDataSourceImpl implements AuthDataSource {
  Api api;

  AuthDataSourceImpl(this.api);

  @override
  Future<void> sendIdToken({required String idToken}) async{ 
    var response = await api.post('auth/google/verify-token', {'idToken': idToken});
  }  
}