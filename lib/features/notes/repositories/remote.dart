import 'package:dartz/dartz.dart';

import '../../../core/network/api_connection_exception.dart';
import '../../../core/network/api_manager.dart';
import '../models/note_model.dart';
import '../models/success_model.dart';
import 'api_urls.dart';

/// [NotesRemoteRepo] acts as an intermediary between the [NotesBloc] and
/// the [ApiManager]  to get the needed data from the client.
///
/// See also:
///  *[ApiManager], which handles the api connections.
///  *[NotesBloc], which manages the states of [MyNotesScreen]
class NotesRemoteRepo {
  const NotesRemoteRepo(this._apiManager);

  final ApiManager _apiManager;

  /// Returns the list of notes when the response from the client is
  /// successful. Otherwise, it will return an exception
  /// [ApiConnectionException]
  ///
  /// ```dart
  /// final loadedNotes = await sl<NotesRemoteRepo>().loadNotes();
  /// ```
  Future<Either<ApiConnectionException, List<NoteModel>>> loadNotes() async {
    final response = await _apiManager.getRequest(NoteApiUrls.loadNotesUrl);
    return response.fold(
      (error) => Left(error),
      (success) {
        if (success.data.isEmpty) {
          return const Right([]);
        } else {
          List<NoteModel> notes = success.data
              .map<NoteModel>((note) => NoteModel.fromJson(note))
              .toList();
          return Right(notes);
        }
      },
    );
  }

  /// Adds a new note in the database when the response from the client is
  /// successful. Otherwise, it will return an exception
  /// [ApiConnectionException]
  ///
  /// ```dart
  /// final response = await sl<NotesRemoteRepo>().createNote();
  /// ```
  Future<Either<ApiConnectionException, SuccessResponse>> createNote() async {
    final response = await _apiManager.getRequest(NoteApiUrls.createNoteUrl);
    return response.fold(
      (error) => Left(error),
      (_) => const Right(SuccessResponse(true)),
    );
  }

  /// Updates an exited note in the database when the response from the client
  /// is successful. Otherwise, it will return an exception
  /// [ApiConnectionException]
  ///
  /// ```dart
  /// final response = await sl<NotesRemoteRepo>().updateNote();
  /// ```
  Future<Either<ApiConnectionException, SuccessResponse>> updateNote() async {
    final response = await _apiManager.getRequest(NoteApiUrls.updateNoteUrl);
    return response.fold(
      (error) => Left(error),
      (_) => const Right(SuccessResponse(true)),
    );
  }

  /// Deletes an exited note from the database when the response from the client
  /// is successful. Otherwise, it will return an exception
  /// [ApiConnectionException]
  ///
  /// ```dart
  /// final response = await sl<NotesRemoteRepo>().deleteOneNote();
  /// ```
  Future<Either<ApiConnectionException, SuccessResponse>>
      deleteOneNote() async {
    final response = await _apiManager.getRequest(NoteApiUrls.deleteNoteUrl);
    return response.fold(
      (error) => Left(error),
      (_) => const Right(SuccessResponse(true)),
    );
  }

  /// Deletes all notes from the database when the response from the client
  /// is successful. Otherwise, it will return an exception
  /// [ApiConnectionException]
  ///
  /// ```dart
  /// final response = await sl<NotesRemoteRepo>().deleteAllNotes();
  /// ```
  Future<Either<ApiConnectionException, SuccessResponse>>
      deleteAllNotes() async {
    final response = await _apiManager.getRequest(NoteApiUrls.deleteAllNoteUrl);
    return response.fold(
      (error) => Left(error),
      (_) => const Right(SuccessResponse(true)),
    );
  }
}
