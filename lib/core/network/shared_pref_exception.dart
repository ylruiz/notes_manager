import 'package:equatable/equatable.dart';

enum SharedPrefExceptionType {
  unableToGetInstance,
  unableToReadData,
  unableToSaveData,
  unableToDeleteData,
}

class SharedPrefException extends Equatable {
  const SharedPrefException.unableToGetInstance()
      : type = SharedPrefExceptionType.unableToGetInstance;

  const SharedPrefException.unableToReadData()
      : type = SharedPrefExceptionType.unableToReadData;

  const SharedPrefException.unableToSaveData()
      : type = SharedPrefExceptionType.unableToSaveData;

  const SharedPrefException.unableToDeleteData()
      : type = SharedPrefExceptionType.unableToDeleteData;

  final SharedPrefExceptionType type;

  @override
  List<Object?> get props => [type];
}
