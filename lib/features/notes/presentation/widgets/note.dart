part of '../screens/my_notes.dart';

class _Note extends StatelessWidget {
  const _Note({required this.note});

  final NoteModel note;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _goToNoteDetailsScreen(context),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          note.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Created at: ${note.createdAt.formatStartWithMonth()}'),
            if (note.updatedAt != null)
              Text('Updated at: ${note.updatedAt!.formatStartWithMonth()}'),
          ],
        ),
        trailing: IconButton(
          onPressed: _deleteNote,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }

  void _goToNoteDetailsScreen(BuildContext context) {
    context.push(Paths.noteDetails, extra: note);
  }

  void _deleteNote() {
    sl<NotesBloc>().add(
      DeleteOneNote(
        noteId: note.id,
        feedbackMessage: 'You have deleted the note with title ${note.title}',
      ),
    );
  }
}
