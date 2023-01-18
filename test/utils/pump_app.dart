import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_manager/core/injection/injection.dart';
import 'package:notes_manager/core/navigation/router.dart';
import 'package:notes_manager/features/notes/presentation/blocs/feedback_cubit/feedback_cubit.dart';
import 'package:notes_manager/features/notes/presentation/blocs/notes_bloc/notes_bloc.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    String location,
    Widget Function(Widget child) builder,
  ) {
    return pumpWidget(
      builder(
        MultiBlocProvider(
          providers: [
            BlocProvider<NotesBloc>.value(value: sl<NotesBloc>()),
            BlocProvider<FeedbackCubit>.value(value: sl<FeedbackCubit>()),
          ],
          child: MaterialApp.router(
            routerConfig: router(initialLocation: location),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          ),
        ),
      ),
    );
  }
}
