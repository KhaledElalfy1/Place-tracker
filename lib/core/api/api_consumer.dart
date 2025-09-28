abstract class ApiConsumer {
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    Map<String, String>? headers,
  });
  post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    Map<String, String>? headers,
  });
  get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    Map<String, String>? headers,
  });
  patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    Map<String, String>? headers,
  });

  put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    Map<String, String>? headers,
  });
}
