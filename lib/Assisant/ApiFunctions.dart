import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class ApiFunction {
  static var uri = "http://n5ba.com/Ratingsportal";
  static BaseOptions options = BaseOptions(
      baseUrl: uri,
      responseType: ResponseType.plain,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        }
      });
  static Dio dio = Dio(options);

  static Future<dynamic> _loginUser(String email, String password,int user_role) async {
    try {
      Options options = Options(
        contentType: ContentType.parse('application/json'),
      );

      print(email + ' : '+password);
      Response response = await dio.post('/api/login',
          data: {"email": email, "password": password,'user_role':3}, options: options);

      print('response : '+response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.data);
        return responseJson;
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect Phone/Password");
      } else
        throw Exception('Authentication Error');
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }



}