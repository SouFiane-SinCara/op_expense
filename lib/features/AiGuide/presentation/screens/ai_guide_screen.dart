import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/core/widgets/app_text_form_field.dart';

class AiGuideScreen extends StatefulWidget {
  const AiGuideScreen({super.key});

  @override
  State<AiGuideScreen> createState() => _AiGuideScreenState();
}

class _AiGuideScreenState extends State<AiGuideScreen> {
  late TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
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
                child: Column(
                  children: [
                    messageCard(isUser: false, message: 'Hello'),
                    messageCard(isUser: true, message: 'Hello'),
                    messageCard(isUser: true, message: 'Hello'),
                    messageCard(
                        isUser: false,
                        message:
                            'Veniam quis est mollit laborum eu dolore nisi. Ex est non proident aute consequat sint et. Incididunt ad id dolor dolor velit irure fugiat ullamco labore elit ea deserunt.'),
                    messageCard(isUser: false, message: 'Hello'),
                    messageCard(
                        isUser: false,
                        message:
                            'Adipisicing laboris enim ad voluptate enim occaecat pariatur ex cupidatat sunt consectetur eu. Eu ullamco aliquip enim non laboris officia dolore amet sit pariatur Lorem ullamco in. Reprehenderit nulla ex cupidatat ut do aute laborum anim eiusmod nisi ipsum exercitation mollit aliqua. Voluptate eiusmod minim laborum adipisicing nostrud officia.'),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AppTextFormField(
                    hintText: 'Ask suggestion',
                    controller: controller,
                  ),
                ),
                Expanded(
                  flex: 1,
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
              ],
            ),
            heightSizedBox(16),
          ],
        ));
  }

  Align messageCard({required bool isUser, required String message}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16.h),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        constraints: BoxConstraints(
          maxWidth: 200.w,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.violet40 : AppColors.violet20,
          borderRadius: BorderRadius.only(
            topLeft: isUser ? Radius.circular(16) : Radius.zero,
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            topRight: isUser ? Radius.zero : Radius.circular(16),
          ),
        ),
        child: Text(
          message,
        ),
      ),
    );
  }
}
