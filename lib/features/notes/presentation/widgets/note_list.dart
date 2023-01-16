part of '../screens/my_notes.dart';

class _NoteList extends StatelessWidget {
  const _NoteList({required this.notes});

  final List<NoteModel> notes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        itemBuilder: (_, index) => _Note(note: notes[index]),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: notes.length,
      ),
    );
  }
}
