import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:psycho_care/models/emotional_state/emotional_state_model.dart';
import 'package:psycho_care/services/http/base_service.dart';
import 'package:psycho_care/services/service_locator.dart';

class EmotionalStatesService extends BaseService {
  final Dio dio = serviceLocator.get<Dio>();

  Future<void> addEmotionalSate(EmotionalStateModel emotionalSate) {
    return apiAction(() async {
      String json = jsonEncode(emotionalSate.toJson());
      await dio.post("/EmotionalStates", data: json);
    });
  }

  Future<List<EmotionalStateModel>> fetchEmotionalStates() {
    return apiAction<List<EmotionalStateModel>>(() async {
      Response response = await dio.get("/EmotionalStates/all");
      List<EmotionalStateModel> emotionalStates = (response.data as List<dynamic>)
          .map(
            (x) => EmotionalStateModel.fromJson(x),
          )
          .toList();

      return emotionalStates;
    });
  }

  Future<List<EmotionalStateModel>> fetchEmotionalStatesForUser(String token) {
    return apiAction<List<EmotionalStateModel>>(() async {
      Response response = await dio.get("/EmotionalStates/allForUser?targetUserToken=$token");
      List<EmotionalStateModel> emotionalStates = (response.data as List<dynamic>)
          .map(
            (x) => EmotionalStateModel.fromJson(x),
          )
          .toList();

      return emotionalStates;
    });
  }
}
