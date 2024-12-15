import 'package:flutter/material.dart';
import 'package:op_expense/core/theme/app_colors.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;
  const AppSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.light80,
        activeTrackColor: AppColors.violet100,
        inactiveThumbColor: AppColors.light80,
        inactiveTrackColor: AppColors.violet20,
      ),
    );
  }
}
