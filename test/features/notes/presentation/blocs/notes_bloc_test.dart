import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notes_manager/core/injection/injection.dart';
import 'package:notes_manager/core/network/shared_pref_exception.dart';
import 'package:notes_manager/features/notes/presentation/blocs/notes_bloc/notes_bloc.dart';
import 'package:notes_manager/features/notes/repositories/local.dart';

import '../../../../utils/mocks/mock_utils.dart';
import '../../../../utils/mocks/mock_utils.mocks.dart';

void main() {
  MockUtils.setUpInjectioBloc();

  group('LoadSoccerClubs', () {
    final notesLocalRepo = MockNotesLocalRepo();

    setUpAll(() => sl.registerSingleton<NotesLocalRepo>(notesLocalRepo));

    blocTest<NotesBloc, NotesState>(
      '''NotesBloc |
       Add LoadNotes event |
       Should verify that LoadNotes is added.''',
      build: () {
        when(notesLocalRepo.loadNotes(any))
            .thenAnswer((_) => Future.value(const Right([])));
        return NotesBloc();
      },
      act: (bloc) => bloc.add(LoadNotes()),
      expect: () => [
        const NotesState(loadedState: LoadedState.loading),
        const NotesState(
          loadedState: LoadedState.loaded,
          notes: [],
        )
      ],
    );

    blocTest<NotesBloc, NotesState>(
      '''SoccerClubsBloc |
       Add LoadNotes event |
       Should verify that the LoadNotes is added.''',
      build: () {
        when(notesLocalRepo.loadNotes(any)).thenAnswer(
          (_) => Future.value(
            const Left(SharedPrefException.unableToReadData()),
          ),
        );
        return NotesBloc();
      },
      act: (bloc) => bloc.add(LoadNotes()),
      expect: () => [
        const NotesState(loadedState: LoadedState.loading),
        const NotesState(loadedState: LoadedState.error),
      ],
    );
  });

  // TODO: Add tests for the rest of the events.
}
