
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:toury/core/enum/user_type_enum.dart';
// import 'package:toury/core/functions/navigation.dart';
// import 'package:toury/core/utils/colors.dart';
// import 'package:toury/core/utils/text_style.dart';
// import 'package:toury/featuers/auth/presentation/pages/login_view.dart';


// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(color: AppColors.color2.withOpacity(.4)),
//           PositionedDirectional(
//             top: 100,
//             start: 25,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('اهلا بيك', style: getTitleStyle(fontSize: 38.sp)),
//                 Gap(15.h),
//                 Text('سجل الان واطلب اوردرك', style: getBodyStyle()),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 80.h,
//             left: 25.w,
//             right: 25.w,
//             child: Container(
//               padding: EdgeInsets.all(15.w),
//               decoration: BoxDecoration(
//                 color: AppColors.color1.withOpacity(.5),
//                 borderRadius: BorderRadius.circular(20.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(.3),
//                     blurRadius: 15.r,
//                     offset: const Offset(5, 5),
//                   )
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     'سجل دلوقتي كــ',
//                     style: getBodyStyle(fontSize: 18, color: AppColors.white),
//                   ),
//                   SizedBox(height: 40.h),
//                   Column(
//                     children: [
//                       // زر الأدمن
//                       GestureDetector(
//                         onTap: () {
//                           pushAndRemoveUntil(context,const LoginView(userType: UserType.admin));
//                         },
//                         child: Container(
//                           height: 70.h,
//                           decoration: BoxDecoration(
//                             color: AppColors.accentColor.withOpacity(.7),
//                             borderRadius: BorderRadius.circular(20.r),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'أدمن',
//                               style: getTitleStyle(color: AppColors.black),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 15.h),
//                       // زر العميل
//                       GestureDetector(
//                         onTap: () {
//                           pushAndRemoveUntil(context,const LoginView(userType: UserType.customer));
//                         },
//                         child: Container(
//                           height: 70.h,
//                           decoration: BoxDecoration(
//                             color: AppColors.accentColor.withOpacity(.7),
//                             borderRadius: BorderRadius.circular(20.r),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'عميل',
//                               style: getTitleStyle(color: AppColors.black),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }