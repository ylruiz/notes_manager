import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:notes_manager/core/injection/injection.dart';
import 'package:notes_manager/core/network/api_manager.dart';
import 'package:notes_manager/features/notes/presentation/blocs/feedback_cubit/feedback_cubit.dart';
import 'package:notes_manager/features/notes/presentation/blocs/notes_bloc/notes_bloc.dart';
import 'package:notes_manager/features/notes/repositories/local.dart';
import 'package:notes_manager/features/notes/repositories/remote.dart';

import 'mock_utils.mocks.dart';

@GenerateMocks([
  FeedbackCubit,
  NotesBloc,
  NotesRemoteRepo,
  NotesLocalRepo,
  Dio,
  ApiManager,
])
class MockUtils {
  static void setUpMockedBloc() {
    sl.registerLazySingleton<FeedbackCubit>(() => FeedbackCubit());
    sl.registerLazySingleton<NotesBloc>(() => MockNotesBloc());
  }

  static void setUpInjectioBloc() {
    sl.registerLazySingleton<FeedbackCubit>(() => FeedbackCubit());
    sl.registerLazySingleton<NotesBloc>(() => NotesBloc());
  }
}
