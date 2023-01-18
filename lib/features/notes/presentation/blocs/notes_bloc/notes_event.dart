part of 'notes_bloc.dart';

abstract class NotesEvent {
  const NotesEvent();
}

class LoadNotes extends NotesEvent {
  LoadNotes({
    this.useLocalMemory = true,
    this.searchTag = '',
  });

  final bool useLocalMemory;
  final String searchTag;
}

class CreateNote extends NotesEvent {
  CreateNote({
    required this.title,
    required this.description,
    required this.feedbackMessage,
  });

  final String title;
  final String description;
  final String feedbackMessage;
}

class UpdateNote extends NotesEvent {
  UpdateNote({
    required this.updatedNote,
    required this.feedbackMessage,
  });

  final NoteModel updatedNote;
  final String feedbackMessage;
}

class DeleteOneNote extends NotesEvent {
  DeleteOneNote({
    required this.noteId,
    required this.feedbackMessage,
  });

  final String noteId;
  final String feedbackMessage;
}

class DeleteNotes extends NotesEvent {
  DeleteNotes({required this.feedbackMessage});
  final String feedbackMessage;
}
