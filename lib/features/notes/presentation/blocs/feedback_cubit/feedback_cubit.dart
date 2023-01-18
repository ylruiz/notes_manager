import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feedback_state.dart';

/// Allows to show the respective feedback(failure or success) to
/// the user when the respective state is emites.
///
/// How to use it?
/// ```dart
///  sl<FeedbackCubit>().showFailureFeedback(error.type.name);
/// ```
///
///  ```dart
///  sl<FeedbackCubit>().showSuccessfulFeedback(feedbackMessage);
///  ```
class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(const FeedbackState());

  void showSuccessfulFeedback(String message) {
    emit(FeedbackState(message: message));
    Future.delayed(const Duration(seconds: 3)).then((_) => hideFeedback());
  }

  void showFailureFeedback(String message) {
    emit(FeedbackState(message: message, isError: true));
  }

  void hideFeedback() => emit(const FeedbackState());

  void showFeedbackDialog(Widget widget) {
    emit(FeedbackState(message: '', dialogChild: widget));
  }
}
