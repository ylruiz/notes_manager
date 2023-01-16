import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/notes/presentation/blocs/feedback_cubit/feedback_cubit.dart';
import '../../features/notes/presentation/blocs/note_bloc/notes_bloc.dart';
import '../../features/notes/repositories/local.dart';
import '../../features/notes/repositories/remote.dart';
import '../network/api_manager.dart';

final sl = GetIt.instance;

Future<void> setUpServiceLocator() async {
  //! Init note related injections
  sl.registerLazySingleton<NotesBloc>(
    () => NotesBloc(),
  );
  // Local memory injection
  sl.registerLazySingleton<NotesLocalRepo>(
    () => NotesLocalRepo(),
  );
  // Remote injections
  sl.registerLazySingleton<NotesRemoteRepo>(
    () => NotesRemoteRepo(sl<ApiManager>()),
  );
  sl.registerLazySingleton<ApiManager>(
    () => ApiManager(sl()),
  );
  sl.registerLazySingleton(() => Dio());

  //! Init core injections
  sl.registerLazySingleton<FeedbackCubit>(() => FeedbackCubit());
}
