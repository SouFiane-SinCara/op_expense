
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';

enum TransactionType { income, expense }

enum Category { food, transport, shopping, subscription, salary, others }

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.food:
        return 'Food';
      case Category.transport:
        return 'Transport';
      case Category.shopping:
        return 'Shopping';
      case Category.subscription:
        return 'Subscription';
      case Category.salary:
        return 'Salary';
      case Category.others:
        return 'Others';
    }
  }

  Container get icon {
    switch (this) {
      case Category.food:
        return Container(
          width: 60.w,
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: AppColors.red20,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SvgPicture.asset(
            'lib/core/assets/icons/Magicons/Glyph/Travel/restaurant.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.red100,
              BlendMode.srcIn,
            ),
          ),
        );
      case Category.transport:
        return Container(
          width: 60.w,
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: AppColors.blue20,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SvgPicture.asset(
            'lib/core/assets/icons/Magicons/Glyph/Travel/car.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.blue100,
              BlendMode.srcIn,
            ),
          ),
        );
      case Category.shopping:
        return Container(
          width: 60.w,
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: AppColors.green20,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SvgPicture.asset(
            'lib/core/assets/icons/Magicons/Glyph/Ecommerce & Shopping/shopping-bag.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.green100,
              BlendMode.srcIn,
            ),
          ),
        );
      case Category.subscription:
        return Container(
          width: 60.w,
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: AppColors.blue20,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SvgPicture.asset(
            'lib/core/assets/icons/Magicons/Glyph/Finance/recurring-bill.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.blue100,
              BlendMode.srcIn,
            ),
          ),
        );
      case Category.salary:
        return Container(
          width: 60.w,
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: AppColors.green20,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SvgPicture.asset(
            'lib/core/assets/icons/Magicons/Glyph/Finance/salary.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.green100,
              BlendMode.srcIn,
            ),
          ),
        );
      case Category.others:
        return Container(
          width: 60.w,
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: AppColors.light20,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SvgPicture.asset(
            'lib/core/assets/icons/Magicons/Glyph/User Interface/other.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.light80,
              BlendMode.srcIn,
            ),
          ),
        );
    }
  }
}

class Transaction extends Equatable {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final PaymentSource paymentSource;
  final XFile? attachment;
  final Category category;
  final bool repeat;
  final String? frequency;
  final DateTime? frequencyEndDate;

  const Transaction({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
    required this.paymentSource,
    this.attachment,
    required this.category,
    required this.repeat,
    this.frequency,
    this.frequencyEndDate,
  });

  @override
  List<Object?> get props => [
        id,
        description,
        amount,
        type,
        date,
        paymentSource,
        attachment,
        category,
        repeat,
        frequency,
        frequencyEndDate,
      ];
}
