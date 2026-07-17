import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import 'api_exception.dart';

/// Thin wrapper around a configured [Dio] instance.
///
/// Centralises base URL, timeouts, logging (debug only) and converts every
/// [DioException] into a typed [ApiException] via an interceptor so data
/// sources can rely on a consistent error type.
///
/// The Postman mock API responds with `Content-Type: text/html`, so Dio does
/// not auto-decode the JSON body. A response interceptor decodes any string
/// body into JSON, and the request methods intentionally return
/// `Response<dynamic>` (not a strict generic) to avoid a premature `as T` cast
/// failing before that decoding runs.
class DioClient {
  DioClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio
      ..options.baseUrl = ApiConstants.baseUrl
      ..options.connectTimeout = ApiConstants.connectTimeout
      ..options.receiveTimeout = ApiConstants.receiveTimeout
      ..options.responseType = ResponseType.json
      ..options.headers = {'Content-Type': 'application/json'};

    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          final data = response.data;
          if (data is String && data.isNotEmpty) {
            try {
              response.data = jsonDecode(data);
            } catch (_) {
              // Not JSON; leave the raw body untouched.
            }
          }
          handler.next(response);
        },
        onError: (error, handler) {
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: ApiException.fromDioException(error),
              type: error.type,
              response: error.response,
            ),
          );
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }

  final Dio _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<dynamic>(path, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
  }) {
    return _dio.post<dynamic>(path, data: data);
  }
}
