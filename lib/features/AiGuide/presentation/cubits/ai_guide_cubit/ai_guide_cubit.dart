import 'package:bloc/bloc.dart';
import 'package:op_expense/features/AiGuide/domain/entities/message.dart';
import 'package:op_expense/features/AiGuide/domain/repositories/ai_guide_repository.dart';
import 'package:op_expense/features/AiGuide/presentation/cubits/ai_guide_cubit/ai_guide_state.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';

class AiGuideCubit extends Cubit<AiGuideState> {
  final AiGuideRepository aiGuideRepository;
  AiGuideCubit({required this.aiGuideRepository})
      : super(
          AiGuideState(
            currentAiGuideState: AiGuideStatus.aiGuideInitialState,
            messages: [],
          ),
        );

  Future sendMessage(
      {required Message message,
      required List<PaymentSource> paymentSources,
      required List<Transaction> transactions}) async {
    // emit the loading state and add the new message to the messages to show it before making the request
    emit(state.copyWith(
        currentAiGuideState: AiGuideStatus.aiGuideLoadingState,
        messages: [...state.messages, message]));
    // make the request to the repository
    final response = await aiGuideRepository.sendMessage(
        paymentSources: paymentSources,
        messages: state.messages,
        transactions: transactions);
    response.fold(
      (failure) {
        // if the request fails, emit the error state
        emit(state.copyWith(
            currentAiGuideState: AiGuideStatus.aiGuideErrorState,
            error: failure.message));
      },
      (message) {
        // if the request is successful, emit the answered state and add the response to the messages
        emit(state.copyWith(
            //add the response to the messages
            messages: [...state.messages, message],
            currentAiGuideState: AiGuideStatus.aiGuideAnsweredState));
      },
    );
  }
}
