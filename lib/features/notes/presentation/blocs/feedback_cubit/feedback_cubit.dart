import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feedback_state.dart';

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
