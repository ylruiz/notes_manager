part of '../screens/my_notes.dart';

class _MyNotesBody extends StatelessWidget {
  const _MyNotesBody();

  @override
  Widget build(BuildContext context) {
    final loca = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (_, state) {
          switch (state.loadedState) {
            case LoadedState.initial:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _useLocalMemory(true),
                      child: Text(loca.useLocalMemory.toUpperCase()),
                    ),
                    ElevatedButton(
                      onPressed: () => _useLocalMemory(false),
                      child: Text(loca.useRemoteApi.toUpperCase()),
                    ),
                  ],
                ),
              );
            case LoadedState.loading:
              return const Center(child: _LoadingProgess());
            case LoadedState.loaded:
              return state.notes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('You have not created any note yet'),
                          ElevatedButton(
                            onPressed: () => _goToNoteDetailsScreen(context),
                            child: Text('Add first note'.toUpperCase()),
                          ),
                        ],
                      ),
                    )
                  : _NoteList(notes: state.notes);
            case LoadedState.searched:
              return _NoteList(notes: state.notes);
            case LoadedState.error:
              return const Text('Some error happened');
          }
        },
      ),
    );
  }

  void _useLocalMemory(bool value) {
    sl<NotesBloc>().add(LoadNotes(useLocalMemory: value));
  }

  void _goToNoteDetailsScreen(BuildContext context) {
    context.push(Paths.noteDetails);
  }
}
