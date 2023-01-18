import 'package:equatable/equatable.dart';

/// Possible types of [ApiConnectionError].
enum ApiConnectionExceptionType {
  none,
  noInternet,
  redirection,
  clientError,
  serverError,
  undefinedError;
}

/// Exception that should be thrown when the response from the client is NOT
/// successful.
class ApiConnectionException extends Equatable implements Exception {
  const ApiConnectionException({
    required this.errorType,
    required this.statusCode,
    required this.statusMessage,
  });

  final ApiConnectionExceptionType errorType;
  final int statusCode;
  final String statusMessage;

  @override
  List<Object?> get props => [errorType, statusCode, statusMessage];
}
