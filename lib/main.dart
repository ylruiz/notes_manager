import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/injection/injection.dart';
import 'core/navigation/router.dart';
import 'features/notes/presentation/blocs/feedback_cubit/feedback_cubit.dart';
import 'features/notes/presentation/blocs/notes_bloc/notes_bloc.dart';

void main() async {
  await setUpServiceLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NotesBloc>.value(value: sl<NotesBloc>()),
        BlocProvider<FeedbackCubit>.value(value: sl<FeedbackCubit>()),
      ],
      child: const NotesManagerApp(),
    ),
  );
}

class NotesManagerApp extends StatelessWidget {
  const NotesManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Notes Manager',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xff1e90ff),
        ),
      ),
      routerConfig: router(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
