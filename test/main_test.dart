import 'package:flutter_test/flutter_test.dart';
import 'package:notes_manager/core/injection/injection.dart';
import 'package:notes_manager/core/navigation/paths.dart';
import 'package:notes_manager/features/notes/presentation/blocs/notes_bloc/notes_bloc.dart';
import 'package:notes_manager/features/notes/presentation/screens/my_notes.dart';

import 'utils/mocks/mock_utils.dart';
import 'utils/pump_app.dart';

void main() {
  MockUtils.setUpInjectioBloc();

  setUpAll(() {
    final notesBloc = sl<NotesBloc>();
    notesBloc.emit(const NotesState());
  });

  testWidgets(
    'Render MyNotesScreen via Router',
    (tester) async {
      await tester.pumpApp(
        Paths.myNotes,
        (child) => child,
      );
      expect(find.byType(MyNotesScreen), findsOneWidget);
    },
  );
}