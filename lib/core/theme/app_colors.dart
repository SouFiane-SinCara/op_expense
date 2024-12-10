import 'package:flutter/material.dart';

class AppColors {
  // Dark Colors
  static const Color dark = Color(0xFF212121);
  static const Color dark25 = Color(0xFF292B2D);
  static const Color dark50 = Color(0xFF212325);
  static const Color dark75 = Color(0xFF161719);
  static const Color dark100 = Color(0xFF9E9E9E);

  // Light Colors
  static const Color light = Color(0xFFFFFFFF);
  static const Color light20 = Color(0xFF91919F);
  static const Color light40 = Color(0xFFDFDFDF);
  static const Color light60 = Color(0xFFF1F1FA);
  static const Color light80 = Color(0xFFFCFCFC);
  static const Color light100 = Color(0xFF757575);

  // Violet Colors
  static const Color violet10 = Color(0xFF8B50FF);
  static const Color violet20 = Color(0xFFEEE5FF);
  static const Color violet40 = Color(0xFFCE93D8);
  static const Color violet60 = Color(0xFFAB47BC);
  static const Color violet80 = Color(0xFF8E24AA);
  static const Color violet100 = Color(0xFF7F3DFF);

  // Red Colors
  static const Color red20 = Color(0xFFFFCDD2);
  static const Color red40 = Color(0xFFEF9A9A);
  static const Color red60 = Color(0xFFF44336);
  static const Color red80 = Color(0xFFD32F2F);
  static const Color red100 = Color(0xFFFD3C4A);

  // Green Colors
  static const Color green20 = Color(0xFFC8E6C9);
  static const Color green40 = Color(0xFF81C784);
  static const Color green60 = Color(0xFF4CAF50);
  static const Color green80 = Color(0xFF00A86B);
  static const Color green100 = Color(0xFF00A86B);

  // Yellow Colors
  static const Color yellow20 = Color(0xFFFFF9C4);
  static const Color yellow40 = Color(0xFFFFF59D);
  static const Color yellow60 = Color(0xFFFFEB3B);
  static const Color yellow80 = Color(0xFFFBC02D);
  static const Color yellow100 = Color(0xFFF57F17);

  // Blue Colors
  static const Color blue20 = Color(0xFFBBDEFB);
  static const Color blue40 = Color(0xFF64B5F6);
  static const Color blue60 = Color(0xFF2196F3);
  static const Color blue80 = Color(0xFF1976D2);
  static const Color blue100 = Color(0xFF0D47A1);

  //!----------- linear gradient colors --------------!//
  static const Gradient linear1 = LinearGradient(
    colors: [Color(0xFFFFF6E5), Color(0x00F7ECD7)],
    begin: Alignment(-0.06, -1.00),
    end: Alignment(0.06, 1),
  );
  static Gradient linear2 = LinearGradient(
    colors: [
      const Color(0xFF8B50FF).withOpacity(0.24),
      const Color(0xFF8B50FF).withOpacity(0),
    ],
    begin: const Alignment(-0.06, -1.00),
    end: const Alignment(0.06, 1),
  );
}
