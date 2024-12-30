import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:op_expense/core/theme/app_colors.dart';
import 'package:op_expense/features/main/domain/entities/payment_source.dart';

// Entity for transaction attachment
class Attachment extends Equatable {
  XFile? file;
  String? url;
  Attachment({this.file, this.url});

  @override
  List<Object?> get props => [file, url];
}

// ignore: must_be_immutable
class Transaction extends Equatable {
  final String description;
  final double amount;
  final TransactionType type;
  final DateTime createAt;
  final PaymentSource? paymentSource;
  final Attachment? attachment;
  final Category? category;
  final bool repeat;
  final int? frequencyDay;
  final int? frequencyMonth;
  final DateTime? frequencyEndDate;
  final Frequency? frequency;

  const Transaction({
    required this.type,
    required this.description,
    required this.amount,
    required this.frequencyDay,
    required this.frequencyMonth,
    required this.createAt,
    required this.paymentSource,
    required this.attachment,
    required this.frequency,
    required this.category,
    required this.repeat,
    required this.frequencyEndDate,
  });

  @override
  List<Object?> get props => [
        description,
        amount,
        type,
        createAt,
        paymentSource,
        attachment,
        category,
        repeat,
        frequency,
        frequencyEndDate,
        frequencyDay,
        frequencyMonth,
      ];
}

// Enum for transaction type
enum TransactionType { income, expense }

// Enum for transaction category
enum Category { food, transport, shopping, subscription, salary, others }

// Enum for transaction frequency
enum Frequency { yearly, monthly, daily }

// Extension for transaction type help me to get the name of the Category and the icon of the Category
extension CategoryExtension on Category? {
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
      default:
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
      default:
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
