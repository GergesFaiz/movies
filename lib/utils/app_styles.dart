import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppStyles {
  static TextStyle bold32White = GoogleFonts.montserrat(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
  );

  static TextStyle bold22White = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );
  static const TextStyle bold22Gray = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.gray,
  );

  static TextStyle bold20White = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  static TextStyle bold18White = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  static const TextStyle bold18Gray = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.gray,
  );
  static TextStyle bold16Black = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
  );

  static TextStyle medium16white = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );
  static TextStyle medium16Black = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
  );
  static TextStyle regular16white = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.white,
  );
  static const TextStyle bold16White = TextStyle(
    fontSize: 16,
    color: AppColors.white,
    fontWeight: FontWeight.w600,
  );
  static TextStyle bold15White = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle bold14White = TextStyle(
    fontSize: 14,
    color: AppColors.white,
    fontWeight: FontWeight.w700,

  );
  static TextStyle medium14Gray = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.gray,
    fontWeight: FontWeight.w500,
  );
  static TextStyle medium13Gray = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.gray,
  );
  static TextStyle medium12Gray = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.gray,
  );
}
