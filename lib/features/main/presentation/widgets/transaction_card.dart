import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:op_expense/core/helpers/app_extensions.dart';
import 'package:op_expense/core/helpers/sized_boxes.dart';
import 'package:op_expense/core/theme/text_styles.dart';
import 'package:op_expense/features/main/domain/entities/transaction.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Row(
        children: [
          transaction.category.icon,
          widthSizedBox(9),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.category.name,
                style: TextStyles.w500Dark25.copyWith(fontSize: 16.sp),
              ),
              Text(
                transaction.description,
                style: TextStyles.w500Light20.copyWith(fontSize: 13.sp),
              ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount.formatNumber(),
                style: transaction.amount.isNegative
                    ? TextStyles.w600Red.copyWith(fontSize: 16.sp)
                    : TextStyles.w600Green.copyWith(fontSize: 16.sp),
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(transaction.createAt),
                style: TextStyles.w500Light20.copyWith(fontSize: 13.sp),
              ),
            ],
          )
        ],
      ),
    );
  }
}
