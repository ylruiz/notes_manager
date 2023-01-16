part of '../screens/my_notes.dart';

class _LocalMemoryFilterChip extends StatefulWidget {
  const _LocalMemoryFilterChip();

  @override
  State<_LocalMemoryFilterChip> createState() => _LocalMemoryFilterChipState();
}

class _LocalMemoryFilterChipState extends State<_LocalMemoryFilterChip> {
  bool _useLocalMemory = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 10),
      child: FilterChip(
        label: const Text('Local Memory'),
        selected: _useLocalMemory,
        selectedColor: Colors.green[200],
        onSelected: _setUseLocalMemoryValue,
      ),
    );
  }

  void _setUseLocalMemoryValue(bool value) {
    setState(() => _useLocalMemory = value);
    sl<NotesBloc>().add(LoadNotes(useLocalMemory: value));
  }
}
