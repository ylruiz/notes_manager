import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'api_connection_exception.dart';

/// Should handle the API connections depending on the respective
/// request:
/// - GET [getRequest]
/// - POST [postRequest]
/// - DELETE [deleteRequest]
/// - PUT [putRequest]
class ApiManager {
  ApiManager(this._client);

  final Dio _client;

  Future<Either<ApiConnectionException, Response>> getRequest(
      String url) async {
    try {
      final response = await _client.get(url);
      return await _sendResponse(response);
    } catch (error) {
      return const Left(ApiConnectionException(
        errorType: ApiConnectionErrorType.noInternet,
        statusCode: -1,
        statusMessage: '',
      ));
    }
  }

  Future<Either<ApiConnectionException, Response>> postRequest(
      String url, dynamic model) async {
    try {
      final data = model != null ? jsonEncode(model) : null;
      final response = await _client.post(
        url,
        data: data,
      );
      return await _sendResponse(response);
    } catch (error) {
      return const Left(ApiConnectionException(
        errorType: ApiConnectionErrorType.noInternet,
        statusCode: -1,
        statusMessage: '',
      ));
    }
  }

  Future<Either<ApiConnectionException, Response>> deleteRequest(
      String url) async {
    try {
      final response = await _client.delete(url);
      return await _sendResponse(response);
    } catch (error) {
      return const Left(ApiConnectionException(
        errorType: ApiConnectionErrorType.noInternet,
        statusCode: -1,
        statusMessage: '',
      ));
    }
  }

  Future<Either<ApiConnectionException, Response>> putRequest(
      String url, dynamic model) async {
    try {
      final data = model != null ? jsonEncode(model) : null;
      final response = await _client.put(
        url,
        data: data,
      );
      return await _sendResponse(response);
    } catch (error) {
      return const Left(ApiConnectionException(
        errorType: ApiConnectionErrorType.noInternet,
        statusCode: -1,
        statusMessage: '',
      ));
    }
  }

  Future<Either<ApiConnectionException, Response>> _sendResponse(
    Response response,
  ) async {
    final statusCode = response.statusCode;
    final statusstatusMessage = response.statusMessage;

    if (statusCode != null && statusstatusMessage != null) {
      return _isSuccessResponse(statusCode)
          ? Right(response)
          : Left(
              ApiConnectionException(
                errorType: _getApiConnectionErrorType(statusCode),
                statusCode: statusCode,
                statusMessage: statusstatusMessage,
              ),
            );
    }

    return const Left(
      ApiConnectionException(
        errorType: ApiConnectionErrorType.undefinedError,
        statusCode: -1,
        statusMessage: '',
      ),
    );
  }

  bool _isSuccessResponse(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  ApiConnectionErrorType _getApiConnectionErrorType(int statusCode) {
    if (statusCode >= 300 && statusCode < 399) {
      return ApiConnectionErrorType.redirection;
    }

    if (statusCode >= 400 && statusCode < 499) {
      return ApiConnectionErrorType.clientError;
    }

    if (statusCode >= 500 && statusCode < 599) {
      return ApiConnectionErrorType.serverError;
    }

    return ApiConnectionErrorType.undefinedError;
  }
}
