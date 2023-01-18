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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                    validator: _titleNotWhitespace,
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
                        labelText: 'Enter markdown text here...',
                        hintText: _description,
                      ),
                      validator: _descNotWhitespace,
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
                            onPressed: _deleteNote,
                            child: const Text('Delete Note'),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: _saveNote,
                        child: const Text('Save Note'),
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

  static String? _titleNotWhitespace(String? value) {
    return value.isNullOrWhitespace()
        ? 'Please, verify the title is not empty.'
        : null;
  }

  static String? _descNotWhitespace(String? value) {
    return value.isNullOrWhitespace()
        ? 'Please, verify the description is not empty.'
        : null;
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

  void _saveNote() {
    if (_formKey.currentState?.validate() ?? true) {
      final note = widget.note;
      final title = _titleController.text;
      final desc = _descriptionController.text;
      if (note == null) {
        sl<NotesBloc>().add(
          CreateNote(
            title: title,
            description: desc,
            feedbackMessage: 'You have created a new note successfully',
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
            feedbackMessage: 'You have updated the note $title successfully',
          ),
        );
      }
      context.pop();
    }
  }

  void _deleteNote() {
    final note = widget.note;
    assert(note != null, 'Trying to delete note using a null note');
    sl<NotesBloc>().add(
      DeleteOneNote(
        noteId: note!.id,
        feedbackMessage: 'You have deleted the note with title ${note.title}',
      ),
    );
    context.pop();
  }
}
