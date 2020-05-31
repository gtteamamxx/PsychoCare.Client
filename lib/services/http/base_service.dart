import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psycho_care/models/response/error_response.dart';

typedef ApiFunction<T> = Future<T> Function();

class BaseService {
  Future<T> apiAction<T>(ApiFunction<T> func) async {
    try {
      var result = await func();
      return result;
    } catch (err) {
      if (err is DioError) {
        if (err.type == DioErrorType.CONNECT_TIMEOUT || err.type == DioErrorType.RECEIVE_TIMEOUT || err.type == DioErrorType.SEND_TIMEOUT) {
          Fluttertoast.showToast(msg: "Upss! Wysyłane żądanie trwało zbyt długo. Spróbuj jeszcze raz.");
          throw err;
        } else if (err.response.statusCode == 500) {
          try {
            ErrorResponse response = ErrorResponse.fromJson(err.response.data);
            if (!response.isError) {
              Fluttertoast.showToast(
                msg: response.message,
                toastLength: Toast.LENGTH_LONG,
              );
              throw err;
            }
          } catch (_) {
            Fluttertoast.showToast(msg: err.response.data);
            throw err;
          }
        }
      }

      Fluttertoast.showToast(msg: "Upss! Wystąpił błąd. Spróbuj jeszcze raz.");
      throw err;
    }
  }
}
