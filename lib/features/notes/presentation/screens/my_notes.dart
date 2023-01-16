import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/date_time_format.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/navigation/paths.dart';
import '../../models/note_model.dart';
import '../blocs/feedback_cubit/feedback_cubit.dart';
import '../blocs/note_bloc/notes_bloc.dart';

part '../widgets/local_memory_filter_chip.dart';
part '../widgets/my_notes_body.dart';
part '../widgets/loading_progress.dart';
part '../widgets/search_input.dart';
part '../widgets/note_list.dart';
part '../widgets/note.dart';

class MyNotesScreen extends StatelessWidget {
  const MyNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackCubit, FeedbackState>(
      listener: (_, state) {
        if (state.message.isNotEmpty) {
          final snackBar = SnackBar(
            content: Row(
              children: [
                state.isError
                    ? const Icon(Icons.error, color: Colors.red)
                    : const Icon(Icons.check, color: Colors.green),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(state.message),
                )),
              ],
            ),
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.gotIt.toUpperCase(),
              onPressed: () => context.canPop() ? context.pop() : {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (_, state) {
          final isStateLoaded = state.loadedState == LoadedState.loaded;
          final showActions = isStateLoaded && state.notes.isNotEmpty;

          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(AppLocalizations.of(context)!.myNotes),
              actions: showActions
                  ? [
                      IconButton(
                        onPressed: _deleteNotes,
                        icon: const Icon(Icons.delete),
                      ),
                    ]
                  : [],
            ),
            bottomNavigationBar: state.loadedState == LoadedState.loaded
                ? Row(
                    children: const [
                      Spacer(),
                      _LocalMemoryFilterChip(),
                    ],
                  )
                : const SizedBox(),
            body: const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: _MyNotesBody(),
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteNotes() {
    sl<NotesBloc>().add(DeleteNotes(
      feedbackMessage: 'You have deleted all your notes',
    ));
  }
}
