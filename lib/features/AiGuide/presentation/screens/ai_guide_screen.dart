import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/services/dependency_injection.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/core/widgets/app_text_form_field.dart';
import 'package:op_expense/core/widgets/snack_bars.dart';
import 'package:op_expense/features/AiGuide/domain/entities/message.dart';
import 'package:op_expense/features/AiGuide/presentation/cubits/ai_guide_cubit/ai_guide_cubit.dart';
import 'package:op_expense/features/AiGuide/presentation/cubits/ai_guide_cubit/ai_guide_state.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';
import 'package:op_expense/features/main/presentation/cubits/payment_sources_cubit/payment_sources_cubit.dart';
import 'package:op_expense/features/main/presentation/cubits/transaction_cubit/transaction_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AiGuideScreen extends StatefulWidget {
  const AiGuideScreen({super.key});

  @override
  State<AiGuideScreen> createState() => _AiGuideScreenState();
}

class _AiGuideScreenState extends State<AiGuideScreen> {
  late TextEditingController userInputController;
  late ScrollController scrollController;
  @override
  void initState() {
    userInputController = TextEditingController();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    userInputController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.light,
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: BlocConsumer<AiGuideCubit, AiGuideState>(
                listener: (context, aiGuideState) {
                  if (aiGuideState.currentAiGuideState.isAnsweredState ||
                      aiGuideState.currentAiGuideState.isLoadingState) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent + 300,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  } else if (aiGuideState.currentAiGuideState ==
                      AiGuideStatus.aiGuideErrorState) {
                    showErrorSnackBar(context, aiGuideState.error!);
                  }
                },
                builder: (context, aiGuideState) {
                  List<Message> messages = aiGuideState.messages;
                  return Column(
                    children: [
                      messageCard(
                        role: Role.model,
                        message:
                            'Hello, I am your AI guide.\nI have access to your expenses and can assist you in managing them effectively.',
                      ),
                      ...messages.map((e) {
                        return messageCard(role: e.role, message: e.message);
                      }),
                      if (aiGuideState.currentAiGuideState.isLoadingState)
                        Skeletonizer(
                            enabled: true,
                            child: messageCard(
                                role: Role.model,
                                message:
                                    '........................................................')),
                    ],
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: AppTextFormField(
                  hintText: 'Ask suggestion',
                  controller: userInputController,
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<AiGuideCubit>(context).sendMessage(
                      transactions:
                          context.read<TransactionCubit>().transactions,
                      paymentSources:
                          context.read<PaymentSourcesCubit>().paymentSources,
                      message: Message(
                        role: Role.user,
                        message: userInputController.text,
                      ),
                    );

                    userInputController.clear();
                  },
                  child: Container(
                    height: 40.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.violet80,
                    ),
                    padding: EdgeInsets.all(4.w),
                    child: SvgPicture.asset(
                        colorFilter: const ColorFilter.mode(
                            AppColors.light, BlendMode.srcIn),
                        'lib/core/assets/icons/Magicons/Glyph/Arrow/arrow-right.svg'),
                  ),
                ),
              ),
            ],
          ),
          heightSizedBox(16),
        ],
      ),
    );
  }

  Widget messageCard({required Role role, required String message}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          role == Role.user ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (role == Role.model)
          Container(
            width: 40.w,
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            margin: EdgeInsets.only(right: 10.w, top: 16.h),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.violet80,
            ),
            child: SvgPicture.asset(
              'lib/core/assets/icons/Magicons/Glyph/User Interface/chat.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.light,
                BlendMode.srcIn,
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16.h),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          constraints: BoxConstraints(
            maxWidth: 250.w,
          ),
          decoration: BoxDecoration(
            color: role == Role.user ? AppColors.violet40 : AppColors.violet20,
            borderRadius: BorderRadius.only(
              topLeft:
                  role == Role.user ? const Radius.circular(16) : Radius.zero,
              bottomRight: const Radius.circular(16),
              bottomLeft: const Radius.circular(16),
              topRight:
                  role == Role.user ? Radius.zero : const Radius.circular(16),
            ),
          ),
          child: Text(
            message,
            style: TextStyles.darkW500.copyWith(fontSize: 16.sp),
          ),
        ),
        if (role == Role.user)
          Container(
            width: 40.w,
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            margin: EdgeInsets.only(left: 10.w, top: 16.h),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.violet80,
            ),
            child: SvgPicture.asset(
              'lib/core/assets/icons/Magicons/Glyph/Ecommerce & Shopping/user.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.light,
                BlendMode.srcIn,
              ),
            ),
          ),
      ],
    );
  }
}
