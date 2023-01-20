part of '../screens/my_notes.dart';

class _NoteList extends StatelessWidget {
  const _NoteList({required this.notes});

  final List<NoteModel> notes;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const _SearchInput(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.separated(
                  itemBuilder: (_, index) => _Note(note: notes[index]),
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: notes.length,
                ),
              ),
            ),
          ],
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: ElevatedButton(
            onPressed: () => _goToNoteDetailsScreen(context),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _goToNoteDetailsScreen(BuildContext context) {
    context.push(Paths.noteDetails);
  }
}
