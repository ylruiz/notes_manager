import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/string_extension.dart';
import '../../../../core/injection/injection.dart';
import '../../models/note_model.dart';
import '../blocs/notes_bloc/notes_bloc.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({
    super.key,
    this.note,
  });

  final NoteModel? note;

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _description = '';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    final note = widget.note;
    if (note != null) {
      _titleController.text = note.title;
      _descriptionController.text = note.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loca = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(loca.note),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: loca.title,
                    ),
                    validator: (value) => _titleNotWhitespace(
                      value,
                      loca.titleNoEmpty,
                    ),
                    onFieldSubmitted: _setTitleControllerValue,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: loca.markdown,
                        hintText: _description,
                      ),
                      validator: (value) => _descNotWhitespace(
                        value,
                        loca.descNotEmpty,
                      ),
                      onChanged: _setDescValue,
                      onFieldSubmitted: _setDescriptionControllerValue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: MarkdownBody(
                      data: _description,
                      shrinkWrap: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.note != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            onPressed: () => _deleteNote(
                              loca.deletedFeedbackMessage(widget.note!.title),
                            ),
                            child: Text(loca.delete),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: () => _saveNote(loca),
                        child: Text(loca.save),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String? _titleNotWhitespace(
    String? value,
    String validationMessage,
  ) {
    return value.isNullOrWhitespace() ? validationMessage : null;
  }

  static String? _descNotWhitespace(
    String? value,
    String validationMessage,
  ) {
    return value.isNullOrWhitespace() ? validationMessage : null;
  }

  void _setTitleControllerValue(String value) {
    setState(() => _titleController.text = value);
  }

  void _setDescriptionControllerValue(String value) {
    setState(() => _descriptionController.text = value);
  }

  void _setDescValue(String value) {
    setState(() => _description = value);
  }

  void _saveNote(AppLocalizations loca) {
    if (_formKey.currentState?.validate() ?? true) {
      final note = widget.note;
      final title = _titleController.text;
      final desc = _descriptionController.text;
      if (note == null) {
        sl<NotesBloc>().add(
          CreateNote(
            title: title,
            description: desc,
            feedbackMessage: loca.savedNoteFeedback,
          ),
        );
      } else {
        final updatedNote = note.copyWith(
          title: title,
          description: desc,
          updatedAt: () => DateTime.now(),
        );
        sl<NotesBloc>().add(
          UpdateNote(
            updatedNote: updatedNote,
            feedbackMessage: loca.updatedNoteFeedback(title),
          ),
        );
      }
      context.pop();
    }
  }

  void _deleteNote(String feedbackMessage) {
    final note = widget.note;
    assert(note != null, 'Trying to delete note using a null note');
    sl<NotesBloc>().add(
      DeleteOneNote(
        noteId: note!.id,
        feedbackMessage: feedbackMessage,
      ),
    );
    context.pop();
  }
}
