import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toury/core/utils/colors.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'cairo',
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.color1,
      foregroundColor: AppColors.white,
      titleTextStyle: TextStyle(
        fontFamily: 'cairo',
        color: AppColors.white,
        fontSize: 18.0.sp, // هنا استخدمنا sp
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
    ),
    bottomNavigationBarTheme:const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.color1,
      unselectedItemColor: AppColors.black,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.color1,
      onSurface: AppColors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.accentColor,
      filled: true,
      suffixIconColor: AppColors.color1,
      prefixIconColor: AppColors.color1,
      hintStyle: TextStyle(
        fontSize: 15.sp, // هنا برضو sp
        color: AppColors.greyColor,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.r)), // r هنا
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
