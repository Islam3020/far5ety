

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:toury/core/functions/navigation.dart';
import 'package:toury/core/services/local_storage.dart';
import 'package:toury/core/utils/colors.dart';
import 'package:toury/core/widgets/custom_button.dart';
import 'package:toury/featuers/auth/presentation/pages/login_view.dart';
import 'package:toury/featuers/intro/pages/onboarding/data/intro_model.dart';
import 'package:toury/featuers/intro/pages/onboarding/presentation/widgets/boarding_item.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // عشان الديسكتوب
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: introPages.length,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return BoardingItem(model: introPages[index]);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0.w),
                child: SizedBox(
                  height: 60.h,
                  child: Row(
                    children: [
                      SmoothPageIndicator(
                        controller: pageController,
                        count: introPages.length,
                        effect: WormEffect(
                          dotHeight: 8.h,
                          dotWidth: 16.w,
                          activeDotColor: AppColors.color1,
                          dotColor: AppColors.greyColor,
                          spacing: 8.w,
                        ),
                      ),
                      const Spacer(),
                      if (currentPage == introPages.length - 1)
                        CustomButton(
                          height: 45.h,
                          width: 100.w,
                          text: 'هيا بنا',
                          onPressed: () {
                            AppLocalStorage.cacheData(key: AppLocalStorage.isOnboardingShown, value: true);
                           pushReplacement(context,const LoginView()); 
                          },
                        ),
                        if (currentPage != introPages.length - 1)
                        CustomButton(
                          height: 45.h,
                          width: 100.w,
                          text: 'التالي',
                          onPressed: () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 750),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
