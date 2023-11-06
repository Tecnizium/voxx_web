import 'dart:convert';

import 'package:commons/commons.dart';
import 'package:commons/data/const/endpoints_const.dart';
import 'package:commons_dependencies/commons_dependencies.dart';

class LoginApiProvider {
  final Dio dio = Dio();

  Future<Response> signIn(String username, String password) async {
    try {
      return await dio.post(AppEndpoints.GuardianGateUserSignIn,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Access-Control-Allow-Origin': '*',
              'Authorization':
                  'Basic ${base64Encode(utf8.encode("tWgR44A4Bs:BpD63GcT8c"))}'
            },
          ),
          data: {'username': username, 'password': base64Encode(utf8.encode(password))});
    } on DioException catch (e) {
      return e.response as Response;
    }
  }

  Future<Response> signUp(String firstName, String lastName, String username, String email, String password) async {
    UserModel user = UserModel(firstName: firstName, lastName: lastName, username: username, email: email, password: base64Encode(utf8.encode(password)), role: 1);
    try {
      return await dio.post(AppEndpoints.GuardianGateUserSignUp,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization':
                  'Basic ${base64Encode(utf8.encode("tWgR44A4Bs:BpD63GcT8c"))}'
            },
          ),
          data: user.toJsonWithoutId());
    } on DioException catch (e) {
      return e.response as Response;
    }
  }

  Future<Response> getUser(String jwtToken) async {
    return await dio.get(AppEndpoints.GuardianGateUserGetUser,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $jwtToken'
          },
        ));
}
}