import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/injection/injection.dart';
import '../../../models/note_model.dart';
import '../../../repositories/local.dart';
import '../feedback_cubit/feedback_cubit.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(const NotesState()) {
    on<LoadNotes>((event, emit) async {
      var currentState = state;
      currentState = currentState.copyWith(
        loadedState: LoadedState.loading,
        useLocalMemory: event.useLocalMemory,
      );
      emit(currentState);
      if (event.useLocalMemory) {
        emit(await _loadNotesFromLocalMemory(event.searchTag));
      } else {
        emit(await _loadNotesFromRemoteApi());
      }
    });
    on<CreateNote>(
      (event, emit) async {
        if (state.useLocalMemory) {
          emit(await _createNoteLocaMemory(
            event.title,
            event.description,
            event.feedbackMessage,
          ));
        } else {
          emit(await _createNoteRemoteApi(
            event.title,
            event.description,
            event.feedbackMessage,
          ));
        }
      },
    );
    on<UpdateNote>((event, emit) async {
      if (state.useLocalMemory) {
        emit(await _updateNoteLocaMemory(
          event.updatedNote,
          event.feedbackMessage,
        ));
      } else {
        emit(await _updateNoteRemoteApi(
          event.updatedNote,
          event.feedbackMessage,
        ));
      }
    });
    on<DeleteOneNote>(((event, emit) async {
      if (state.useLocalMemory) {
        emit(await _deleteOneNoteLocalMemory(
          event.noteId,
          event.feedbackMessage,
        ));
      } else {
        emit(await _deleteOneNoteRemoteApi(
          event.noteId,
          event.feedbackMessage,
        ));
      }
    }));
    on<DeleteNotes>(((event, emit) async {
      if (state.useLocalMemory) {
        emit(await _deleteNotesFromLocalMemory(event.feedbackMessage));
      } else {
        emit(await _deleteNotesFromRemoteApi(event.feedbackMessage));
      }
    }));
  }

  Future<NotesState> _loadNotesFromLocalMemory(String searchTag) async {
    final loadedNotes = await sl<NotesLocalRepo>().loadNotes(searchTag);
    return loadedNotes.fold(
      (error) {
        sl<FeedbackCubit>().showFailureFeedback(error.type.name);
        return state.copyWith(loadedState: LoadedState.error);
      },
      (loadedNotes) => state.copyWith(
        loadedState: LoadedState.loaded,
        notes: loadedNotes,
        searchTag: searchTag,
      ),
    );
  }

  Future<NotesState> _loadNotesFromRemoteApi() async {
    throw UnimplementedError('_loadNotesFromRemoteApi is not implemented yet');
  }

  Future<NotesState> _createNoteLocaMemory(
    String title,
    String description,
    String feedbackMessage,
  ) async {
    final newNote = NoteModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    final isSaved = await sl<NotesLocalRepo>().createNote(state.notes, newNote);
    return isSaved.fold(
      (error) {
        sl<FeedbackCubit>().showFailureFeedback(error.type.name);
        return state.copyWith(loadedState: LoadedState.error);
      },
      (loadedNotes) {
        sl<FeedbackCubit>().showSuccessfulFeedback(feedbackMessage);
        return state.copyWith(
          loadedState: LoadedState.loaded,
          notes: [newNote] + state.notes,
        );
      },
    );
  }

  Future<NotesState> _createNoteRemoteApi(
    String title,
    String description,
    String feedbackMessage,
  ) async {
    throw UnimplementedError('_saveNoteRemoteApi is not implemented yet');
  }

  Future<NotesState> _updateNoteLocaMemory(
    NoteModel editedNote,
    String feedbackMessage,
  ) async {
    final isSaved =
        await sl<NotesLocalRepo>().updateNote(state.notes, editedNote);
    return isSaved.fold(
      (error) {
        sl<FeedbackCubit>().showFailureFeedback(error.type.name);
        return state.copyWith(loadedState: LoadedState.error);
      },
      (loadedNotes) {
        sl<FeedbackCubit>().showSuccessfulFeedback(feedbackMessage);
        final tempNotes = List.of(state.notes);
        final noteIndex =
            tempNotes.indexWhere((note) => note.id == editedNote.id);
        tempNotes[noteIndex] = editedNote;
        return state.copyWith(
          loadedState: LoadedState.loaded,
          notes: tempNotes,
        );
      },
    );
  }

  Future<NotesState> _updateNoteRemoteApi(
    NoteModel updatedNote,
    String feedbackMessage,
  ) async {
    final isSaved =
        await sl<NotesLocalRepo>().updateNote(state.notes, updatedNote);
    return isSaved.fold(
      (error) {
        sl<FeedbackCubit>().showFailureFeedback(error.type.name);
        return state.copyWith(loadedState: LoadedState.error);
      },
      (loadedNotes) {
        final tempNotes = List.of(state.notes);
        final noteIndex =
            tempNotes.indexWhere((note) => note.id == updatedNote.id);
        tempNotes[noteIndex] = updatedNote;
        return state.copyWith(
          loadedState: LoadedState.loaded,
          notes: tempNotes,
        );
      },
    );
  }

  Future<NotesState> _deleteOneNoteLocalMemory(
    String noteId,
    String feedbackMessage,
  ) async {
    final isSaved =
        await sl<NotesLocalRepo>().deleteOneNote(state.notes, noteId);
    return isSaved.fold(
      (error) {
        sl<FeedbackCubit>().showFailureFeedback(error.type.name);
        return state.copyWith(loadedState: LoadedState.error);
      },
      (loadedNotes) {
        sl<FeedbackCubit>().showSuccessfulFeedback(feedbackMessage);
        final tempNotes = List.of(state.notes);
        final noteIndex = tempNotes.indexWhere((note) => note.id == noteId);
        tempNotes.removeAt(noteIndex);
        return state.copyWith(
          loadedState: LoadedState.loaded,
          notes: tempNotes,
        );
      },
    );
  }

  Future<NotesState> _deleteOneNoteRemoteApi(
    String noteId,
    String feedbackMessage,
  ) async {
    throw UnimplementedError('_deleteOneNoteRemoteApi is not implemented yet');
  }

  Future<NotesState> _deleteNotesFromLocalMemory(String feedbackMessage) async {
    final isDeleted = await sl<NotesLocalRepo>().deleteAllNotes();
    return isDeleted.fold(
      (error) {
        sl<FeedbackCubit>().showFailureFeedback(error.type.name);
        return state.copyWith(loadedState: LoadedState.error);
      },
      (_) {
        sl<FeedbackCubit>().showSuccessfulFeedback(feedbackMessage);
        return state.copyWith(
          loadedState: LoadedState.loaded,
          notes: [],
        );
      },
    );
  }

  Future<NotesState> _deleteNotesFromRemoteApi(String feedbackMessage) async {
    throw UnimplementedError(
      '_deleteNotesFromRempteApi is not implemented yet',
    );
  }
}
