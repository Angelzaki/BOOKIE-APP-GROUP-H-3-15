import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*Nosotros nos conectaremos en el api con la url base y tambien definiremos los metodos http
get - Obtener datos
post - Crear
Put - Modificar un objeto completo
patch - Modificar pero un dato de un objeto completo
delete - Eliminar
* */
class Api{
  late Dio dio;
  Api(){
    dio = Dio(
      BaseOptions(
        baseUrl: "https://bookie-app-group-h-3-15.onrender.com/api/",
        connectTimeout: const Duration(seconds: 30000),
        receiveTimeout: const Duration(seconds: 30000),
        validateStatus: (status){
          return true;
        }
      )
    );
  }

  // Guardar el Access Token
  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  // Obtener el Access Token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Agregar el Access Token al encabezado
  void addAuthHeader() async {
    String? accessToken = await getAccessToken();
    if (accessToken != null) {
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  // Solicitud POST para obtener el Access Token (Ejemplo de login)
  Future<Map<String, dynamic>> login(String endpoint, Map<String, dynamic> body) async {
    try {
      final Response response = await dio.post(endpoint, data: body);
      final Map<String, dynamic> responseData = validateRResponse(response);

      if (responseData.containsKey('accessToken')) {
        await saveAccessToken(responseData['accessToken']);
      }

      return responseData;
    } on DioException catch (error) {
      throw Exception("Error interno $error");
    }
  }


  Future<Map<String,dynamic>> get(String endpoint)async{
    try{
      addAuthHeader();
      final Response response = await dio.get(endpoint);
      final Map<String,dynamic> responseData = validateRResponse(response);
      return responseData;
    }on DioException catch(error){
      throw Exception("Error interno $error");
    }
  }

  Future<Map<String,dynamic>> post(String endpoint,Map<String,dynamic> body)async{
    try{
      addAuthHeader();
      final Response response = await dio.post(endpoint,data: body);
      final Map<String,dynamic> responseData = validateRResponse(response);
      return responseData;
    }on DioException catch(error){
      throw Exception("Error interno $error");
    }
  }

  //Validamos la respuesta del servidor para validar si hay algun error o recibimos los datos.
  Map<String,dynamic> validateRResponse(Response response){
    switch(response.statusCode){
      case 200:
      case 201:
        return response.data as Map<String, dynamic>;
      case 400:
      case 401:
        throw Exception(response.data["error"]).toString();
      case 500:
      default:
        throw Exception("Error en el servidor ${response.statusCode.toString()}");
    }
  }
}