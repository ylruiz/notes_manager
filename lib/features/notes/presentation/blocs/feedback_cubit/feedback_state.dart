part of 'feedback_cubit.dart';

class FeedbackState extends Equatable {
  const FeedbackState({
    this.message = '',
    this.dialogChild,
    this.isError = false,
  });

  final String message;
  final Widget? dialogChild;
  final bool isError;

  @override
  List<Object?> get props => [message, dialogChild, isError];
}
