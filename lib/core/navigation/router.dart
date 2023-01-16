import 'package:go_router/go_router.dart';

import '../../features/notes/models/note_model.dart';
import '../../features/notes/presentation/screens/my_notes.dart';
import '../../features/notes/presentation/screens/note_details.dart';
import 'paths.dart';

GoRouter router({String initialLocation = Paths.myNotes}) => GoRouter(
      initialLocation: initialLocation,
      routes: <GoRoute>[
        GoRoute(
          path: Paths.myNotes,
          builder: (_, __) => const MyNotesScreen(),
        ),
        GoRoute(
          path: Paths.noteDetails,
          builder: (_, state) {
            return NoteDetailsScreen(
              note: state.extra != null ? state.extra as NoteModel : null,
            );
          },
        ),
      ],
    );
