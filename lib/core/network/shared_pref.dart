import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_pref_exception.dart';

/// Manages the access to shared preferences
abstract class SharedPref {
  /// Reads form shared preferences getting the respective data
  static Future<Either<SharedPrefException, String>> read(String key) async {
    final loadedInstance = await _getInstance(key);
    return loadedInstance.fold(
      (error) => const Left(SharedPrefException.unableToGetInstance()),
      (prefs) {
        try {
          prefs.reload();
          return Right(prefs.getString(key) ?? '');
        } catch (error) {
          return const Left(SharedPrefException.unableToReadData());
        }
      },
    );
  }

  /// Saves data in shared preferences
  static Future<Either<SharedPrefException, bool>> save(
    String key,
    List<Map<String, dynamic>> value,
  ) async {
    final loadedInstance = await _getInstance(key);
    return loadedInstance.fold(
      (error) => const Left(SharedPrefException.unableToGetInstance()),
      (prefs) async {
        try {
          final saved = await prefs.setString(key, json.encode(value));
          return Right(saved);
        } catch (error) {
          return const Left(SharedPrefException.unableToSaveData());
        }
      },
    );
  }

  /// Removes data from shared preferences
  static Future<Either<SharedPrefException, bool>> remove(String key) async {
    final loadedInstance = await _getInstance(key);
    return loadedInstance.fold(
      (error) => const Left(SharedPrefException.unableToGetInstance()),
      (prefs) async {
        try {
          final removed = await prefs.remove(key);
          return Right(removed);
        } catch (error) {
          return const Left(SharedPrefException.unableToDeleteData());
        }
      },
    );
  }

  static Future<Either<SharedPrefException, SharedPreferences>> _getInstance(
    String key,
  ) async {
    try {
      final loadedInstance = await SharedPreferences.getInstance();
      return Right(loadedInstance);
    } catch (error) {
      log('Please use a valid token format. The key $key does not allow '
          'the SharedPreference package to get the instance');
      return const Left(SharedPrefException.unableToGetInstance());
    }
  }
}
