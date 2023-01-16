part of '../screens/my_notes.dart';

class _LoadingProgess extends StatelessWidget {
  const _LoadingProgess();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
