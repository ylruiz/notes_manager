import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../core/network/shared_pref.dart';
import '../../../core/network/shared_pref_exception.dart';
import '../models/note_model.dart';
import '../models/success_model.dart';

/// [NotesLocalRepo] acts as an intermediary between the [NotesBloc] and
/// the [SharedPref]  to get the needed data from the local memory.
///
/// See also:
///  *[SharedPref], which handles the api connections.
///  *[NotesBloc], which manages the states of [MyNotesScreen]
class NotesLocalRepo {
  static const String notesKey = 'notes';

  // Returns the list of notes from local memory when possible. Otherwise, it
  // returns an exception [SharedPrefException]
  ///
  /// ```dart
  /// final loadedNotes = await sl<NotesLocalRepo>().loadNotes();
  /// ```
  Future<Either<SharedPrefException, List<NoteModel>>> loadNotes(
      String searchTag) async {
    final response = await SharedPref.read(notesKey);
    return response.fold(
      (error) => Left(error),
      (data) {
        if (data.isEmpty) {
          return const Right([]);
        } else {
          List<NoteModel> notes = json
              .decode(data)
              .map<NoteModel>((note) => NoteModel.fromJson(note))
              .toList();
          if (searchTag.isNotEmpty) {
            notes =
                notes.where((note) => note.title.contains(searchTag)).toList();
          }
          return Right(notes);
        }
      },
    );
  }

  // Adds a new note to the notes storaged in the  local memory when possible.
  // Otherwise, it returns an exception [SharedPrefException]
  ///
  /// ```dart
  /// final response = await sl<NotesLocalRepo>().createNote();
  /// ```
  Future<Either<SharedPrefException, SuccessResponse>> createNote(
    List<NoteModel> notes,
    NoteModel newNote,
  ) async {
    var tempNotes = List.of(notes);
    tempNotes = [newNote] + notes;
    tempNotes.add(newNote);
    final response = await SharedPref.save(notesKey, _notesToJson(tempNotes));
    return response.fold(
      (error) => Left(error),
      (_) => const Right(SuccessResponse(true)),
    );
  }

  // Updates an exited note from the notes storaged in the  local memory when
  // possible. Otherwise, it returns an exception [SharedPrefException]
  ///
  /// ```dart
  /// final response = await sl<NotesLocalRepo>().updateNote();
  /// ```
  Future<Either<SharedPrefException, SuccessResponse>> updateNote(
      List<NoteModel> notes, NoteModel editedNote) async {
    final editedNoteIndex =
        notes.indexWhere((note) => note.id == editedNote.id);
    final tempNotes = List.of(notes);
    tempNotes[editedNoteIndex] = editedNote;
    final response = await SharedPref.save(
      notesKey,
      _notesToJson(tempNotes),
    );
    return response.fold(
      (error) => Left(error),
      (_) => const Right(SuccessResponse(true)),
    );
  }

  // Deletes an exited note from the notes storaged in the local memory when
  // possible. Otherwise, it returns an exception [SharedPrefException]
  ///
  /// ```dart
  /// final response = await sl<NotesLocalRepo>().deleteOneNote();
  /// ```
  Future<Either<SharedPrefException, SuccessResponse>> deleteOneNote(
    List<NoteModel> notes,
    String noteId,
  ) async {
    final noteIdIndex = notes.indexWhere((note) => note.id == noteId);
    final tempNotes = List.of(notes);
    tempNotes.removeAt(noteIdIndex);
    final response = await SharedPref.save(notesKey, _notesToJson(tempNotes));
    return response.fold(
      (error) => Left(error),
      (_) => const Right(SuccessResponse(true)),
    );
  }

  // Deletes all the notes storaged in the local memory when possible.
  // Otherwise, it returns an exception [SharedPrefException]
  ///
  /// ```dart
  /// final response = await sl<NotesLocalRepo>().deleteAllNotes();
  /// ```
  Future<Either<SharedPrefException, SuccessResponse>> deleteAllNotes() async {
    final response = await SharedPref.remove(notesKey);
    return response.fold(
      (error) => Left(error),
      (_) => const Right(SuccessResponse(true)),
    );
  }

  List<Map<String, dynamic>> _notesToJson(List<NoteModel> notes) {
    return notes.map<Map<String, dynamic>>((note) => note.toJson()).toList();
  }
}
