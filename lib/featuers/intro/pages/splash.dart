

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toury/core/functions/navigation.dart';
import 'package:toury/core/services/local_storage.dart';
import 'package:toury/core/utils/text_style.dart';
import 'package:toury/featuers/admin/admin_nav_bar.dart';
import 'package:toury/featuers/auth/presentation/pages/login_view.dart';
import 'package:toury/featuers/customer/customer_nav_bar.dart';
import 'package:toury/featuers/intro/pages/onboarding/presentation/screen/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
 void initState() {
  super.initState();
  navigateAfterSplash();
}

Future<void> navigateAfterSplash() async {
  await Future.delayed(const Duration(seconds: 4));
  
  bool isOnboardingShown = await AppLocalStorage.getData(key: AppLocalStorage.isOnboardingShown) == true;
  

  if (AppLocalStorage.getData(key: AppLocalStorage.userType) != null) {
    if (AppLocalStorage.getData(key: AppLocalStorage.userType) == 'admin') {
      if (mounted) pushAndRemoveUntil(context, const AdminNavBar());
    } else {
      if (mounted) pushReplacement(context, const CustomerNavBar());
    }
  } else {
    if (isOnboardingShown) {
      if (mounted) pushReplacement(context, const LoginView());
    } else {
      if (mounted) pushReplacement(context, const OnboardingScreen());
    }
  }
}

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/images/logo.json",
              width: 200.w,
              height: 200.h 
            ),
            SizedBox(height: 20.h), 
            Text(
              "طيور الزهراء",
              style: getTitleStyle(), 
            ),
            SizedBox(height: 10.h), 
            Text(
              "أهلاً بيك في طيور الزهراء 🐔",
              style: getSmallStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
