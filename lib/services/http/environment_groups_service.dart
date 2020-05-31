import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:psycho_care/models/environment_group/environment_group_model.dart';
import 'package:psycho_care/services/http/base_service.dart';
import 'package:psycho_care/services/service_locator.dart';

class EnvironmentGroupsService extends BaseService {
  final Dio dio = serviceLocator.get<Dio>();

  Future<int> addEnvironmentGroup(EnvironmentGroupModel environmentGroup) {
    return apiAction(() async {
      String json = jsonEncode(environmentGroup.toJson());
      Response<int> response = await dio.post<int>("/EnvironmentGroups", data: json);
      return response.data;
    });
  }

  Future<List<EnvironmentGroupModel>> fetchEnvironmentGroups() {
    return apiAction<List<EnvironmentGroupModel>>(() async {
      Response response = await dio.get("/EnvironmentGroups/all");
      List<EnvironmentGroupModel> groups = (response.data as List<dynamic>)
          .map(
            (x) => EnvironmentGroupModel.fromJson(x),
          )
          .toList();

      return groups;
    });
  }

  Future<void> deleteEnvironmentGroup(int environmentGroupId) {
    return apiAction(() async {
      await dio.delete("/EnvironmentGroups?environmentGroupId=$environmentGroupId");
    });
  }

  Future<void> editEnvironmentGroup(EnvironmentGroupModel environmentGroup) {
    return apiAction(() async {
      String json = jsonEncode(environmentGroup.toJson());
      await dio.put("/EnvironmentGroups", data: json);
    });
  }
}
