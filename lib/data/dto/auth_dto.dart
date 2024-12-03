import 'package:bookieapp/domain/entities/user.dart';

class AuthDto extends User{
  AuthDto({
    super.idToken
  });

  factory AuthDto.toObject(Map<String, dynamic>json){
    return AuthDto(
      idToken: json["idToken"]
    );
  }

  Map<String, dynamic>toMap()=>{
    'idToken': idToken
  };
}

