part of 'notes_bloc.dart';

enum LoadedState {
  initial,
  loading,
  loaded,
  searched,
  error,
}

class NotesState extends Equatable {
  const NotesState({
    this.loadedState = LoadedState.initial,
    this.notes = const [],
    this.searchTag = '',
    this.useLocalMemory = true,
  });

  final LoadedState loadedState;
  final List<NoteModel> notes;
  final String searchTag;
  final bool useLocalMemory;

  @override
  List<Object> get props => [
        loadedState,
        notes,
        searchTag,
        useLocalMemory,
      ];

  NotesState copyWith({
    LoadedState? loadedState,
    List<NoteModel>? notes,
    String? searchTag,
    bool? useLocalMemory,
  }) {
    return NotesState(
      loadedState: loadedState ?? this.loadedState,
      notes: notes ?? this.notes,
      searchTag: searchTag ?? this.searchTag,
      useLocalMemory: useLocalMemory ?? this.useLocalMemory,
    );
  }
}
