import 'dart:io';

import 'package:dio/dio.dart';

import '../network/api_exception.dart';

class ErrorHandler {
  ErrorHandler._();

  static ApiException handle(Object error) {
    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is SocketException) {
      return const ApiException(
        message: 'No internet connection. Please check your network.',
      );
    }

    return const ApiException(
      message: 'Something went wrong. Please try again.',
    );
  }

  static ApiException _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = _getServerMessage(error.response?.data);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Request timed out. Please try again.',
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.badResponse:
        return ApiException(
          message: message ?? _getStatusMessage(statusCode),
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled.');

      case DioExceptionType.badCertificate:
        return const ApiException(
          message: 'Unable to establish a secure connection.',
        );

      case DioExceptionType.unknown:
      default:
        return const ApiException(
          message: 'Something went wrong. Please try again.',
        );
    }
  }

  static String? _getServerMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      final message = data['message'];

      if (detail is String && detail.isNotEmpty) {
        return detail;
      }

      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return null;
  }

  static String _getStatusMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'Requested data was not found.';
      case 409:
        return 'This action conflicts with existing data.';
      case 422:
        return 'Please check the entered information.';
      case 500:
      case 501:
      case 502:
      case 503:
        return 'Server error. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
