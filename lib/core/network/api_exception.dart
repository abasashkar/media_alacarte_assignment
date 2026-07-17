import 'package:dio/dio.dart';

/// Thrown by the network layer and later mapped to a [Failure] by repositories.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.type});

  final String message;
  final int? statusCode;
  final ApiExceptionType? type;

  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException(
          'The request timed out. Please try again.',
          type: ApiExceptionType.timeout,
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          'Could not reach the server. Check your connection.',
          type: ApiExceptionType.network,
        );
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        return ApiException(
          'Server returned an error (${code ?? 'unknown'}).',
          statusCode: code,
          type: ApiExceptionType.server,
        );
      case DioExceptionType.cancel:
        return const ApiException(
          'Request was cancelled.',
          type: ApiExceptionType.cancel,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return ApiException(
          error.message ?? 'An unexpected network error occurred.',
          type: ApiExceptionType.unknown,
        );
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}

enum ApiExceptionType { timeout, network, server, cancel, unknown }
