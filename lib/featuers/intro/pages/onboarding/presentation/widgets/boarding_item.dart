
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadow_clip/shadow_clip.dart';
import 'package:toury/core/utils/colors.dart';
import 'package:toury/core/utils/text_style.dart';
import 'package:toury/featuers/intro/pages/onboarding/data/intro_model.dart';

class BoardingItem extends StatelessWidget {
  const BoardingItem({super.key, this.model});
  final IntroModel? model;

  @override
  Widget build(BuildContext context) {
    // نجيب أبعاد الشاشة ونستخدم نسب
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final imageHeight = screenHeight * 0.5; // 50% من ارتفاع الشاشة
    final imageWidth = screenWidth;         // العرض بالكامل

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: imageHeight,
          width: imageWidth,
          child: ClipShadow(
            clipper: CliperClass(),
            boxShadow: [
              BoxShadow(
                blurRadius: 10.r,
                spreadRadius: 10.r,
                color: AppColors.color1.withOpacity(0.3),
              ),
            ],
            child: Image.asset(
              model!.image,
              fit: BoxFit.cover,
              width: imageWidth,
              height: imageHeight,
            ),
          ),
        ),
     Padding(
  padding: EdgeInsets.all(20.0.w),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        model!.title,
        style: getTitleStyle(),
        textAlign: TextAlign.start,
        softWrap: true,
      ),
      
      Text(
        model!.description,
        style: getBodyStyle(),
        textAlign: TextAlign.start,
        softWrap: true,
      ),
    ],
  ),
),

      ],
    );
  }
}

class CliperClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.width);
    path.quadraticBezierTo(
        size.width / 9, size.height, size.width / 4, size.height);
    path.quadraticBezierTo(size.width - (size.width / 2), size.height,
        size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
