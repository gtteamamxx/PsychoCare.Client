import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:psycho_care/models/auth/auth_model.dart';
import 'package:psycho_care/services/http/base_service.dart';
import 'package:psycho_care/services/service_locator.dart';

class UsersService extends BaseService {
  final Dio dio = serviceLocator.get<Dio>();

  Future<void> registerUser(AuthModel authModel) {
    return apiAction(() async {
      String json = jsonEncode(authModel.toJson());
      await dio.post("/Users/register", data: json);
    });
  }

  Future<String> loginUser(AuthModel authModel) async {
    String token;

    await apiAction(() async {
      String json = jsonEncode(authModel.toJson());
      Response result = await dio.post("/Users/login", data: json);
      token = result.toString();
    });

    return token.toString();
  }
}
