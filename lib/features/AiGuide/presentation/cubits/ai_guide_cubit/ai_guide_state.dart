import 'package:op_expense/features/AiGuide/domain/entities/message.dart';

enum AiGuideStatus {
  aiGuideInitialState,
  aiGuideLoadingState,
  aiGuideErrorState,
  aiGuideAnsweredState
}

extension AiGuideStatusExtension on AiGuideStatus {
  bool get isInitialState => this == AiGuideStatus.aiGuideInitialState;
  bool get isLoadingState => this == AiGuideStatus.aiGuideLoadingState;
  bool get isErrorState => this == AiGuideStatus.aiGuideErrorState;
  bool get isAnsweredState => this == AiGuideStatus.aiGuideAnsweredState;
}

class AiGuideState {
  final AiGuideStatus currentAiGuideState;
  final List<Message> messages;
  final String? error;
  AiGuideState(
      {required this.currentAiGuideState, required this.messages, this.error});

  AiGuideState copyWith({
    AiGuideStatus? currentAiGuideState,
    List<Message>? messages,
    String? error,
  }) {
    return AiGuideState(
      currentAiGuideState: currentAiGuideState ?? this.currentAiGuideState,
      messages: messages ?? this.messages,
      error: error ?? this.error,
    );
  }
}
