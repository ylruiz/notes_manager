import 'package:equatable/equatable.dart';

/// Possible types of [SharedPrefException].
enum SharedPrefExceptionType {
  unableToGetInstance,
  unableToReadData,
  unableToSaveData,
  unableToDeleteData,
}

/// Exception that should be thrown when something goes wrong
/// while trying to access, read, save or delete from the local
/// memeory.
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
