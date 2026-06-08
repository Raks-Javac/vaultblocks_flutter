import '../result/app_result.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class ApiClient {
  Future<AppResult<JsonMap>> get(
    String path, {
    Map<String, String> headers = const <String, String>{},
  });

  Future<AppResult<JsonMap>> post(
    String path, {
    Map<String, String> headers = const <String, String>{},
    JsonMap body = const <String, dynamic>{},
  });
}

