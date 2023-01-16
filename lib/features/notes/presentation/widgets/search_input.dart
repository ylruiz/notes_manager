part of '../screens/my_notes.dart';

class _SearchInput extends StatefulWidget {
  const _SearchInput();

  @override
  State<_SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<_SearchInput> {
  final TextEditingController _searchTagController = TextEditingController();

  @override
  void initState() {
    _searchTagController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _searchTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _searchTagController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Search Note',
        suffixIcon: IconButton(
          onPressed: _searchNote,
          icon: const Icon(Icons.search),
        ),
      ),
      onFieldSubmitted: _setSearchTagController,
    );
  }

  void _setSearchTagController(String value) {
    setState(() => _searchTagController.text = value);
  }

  void _searchNote() {
    sl<NotesBloc>().add(LoadNotes(searchTag: _searchTagController.text));
  }
}
