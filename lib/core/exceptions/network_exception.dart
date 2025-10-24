import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException({
    required this.message,
    this.statusCode,
  });

  factory NetworkException.fromDioError(DioException error) {
    final response = error.response;
    final data = response?.data;

    String message = 'Something went wrong. Please try again.';

    // Safely extract message from response data
    if (data is Map<String, dynamic> && data['message'] is String) {
      message = data['message'];
    } else if (data is String) {
      message = data;
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout. Please try again later.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout. Server is not responding.';
        break;
      case DioExceptionType.badCertificate:
        message = 'Bad SSL Certificate.';
        break;
      case DioExceptionType.badResponse:
      // already handled above, just return with message
        return NetworkException(
          message: message,
          statusCode: response?.statusCode,
        );
      case DioExceptionType.cancel:
        message = 'Request was cancelled.';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection or server unreachable.';
        break;
      case DioExceptionType.unknown:
      default:
        message = 'Unexpected error occurred.';
        break;
    }

    return NetworkException(
      message: message,
      statusCode: response?.statusCode,
    );
  }

  @override
  String toString() => 'NetworkException: $message (Status Code: $statusCode)';
}
