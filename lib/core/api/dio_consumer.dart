import 'package:dio/dio.dart';
import 'package:route_tracker_app/core/api/api_consumer.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio = Dio();

  @override
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameter,
    Map<String, String>? headers,
    bool isFormData = false,
  }) async {
    final response = await dio.delete(
      path,
      data: isFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParameter,
      options: Options(headers: headers ?? {}),
    );
    return response;
  }

  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    Map<String, String>? headers,
  }) async {
    final response = await dio.get(
      path,
      data: data,
      queryParameters: queryParameter,
      options: Options(headers: headers ?? {}),
    );
    return response;
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    Map<String, String>? headers,
  }) async {
    final response = await dio.patch(
      path,
      data: isFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParameter,
      options: Options(headers: headers ?? {}),
    );
    return response;
  }

  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    Map<String, String>? headers,
  }) async {
    final response = await dio.post(
      path,
      data: isFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParameter,
      options: Options(headers: headers),
    );
    return response;
  }

  @override
  put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    Map<String, String>? headers,
  }) async {
    final response = await dio.put(
      path,
      data: isFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParameter,
      options: Options(headers: headers ?? {}),
    );
    return response;
  }
}
