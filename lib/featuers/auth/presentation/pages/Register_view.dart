import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:toury/core/enum/user_type_enum.dart';
import 'package:toury/core/functions/dialogs.dart';
import 'package:toury/core/functions/email_validate.dart';
import 'package:toury/core/functions/navigation.dart';
import 'package:toury/core/utils/colors.dart';
import 'package:toury/core/utils/constants.dart';
import 'package:toury/core/utils/text_style.dart';
import 'package:toury/core/widgets/custom_button.dart';
import 'package:toury/featuers/admin/admin_nav_bar.dart';
import 'package:toury/featuers/auth/presentation/cubit/auth_cubit.dart';
import 'package:toury/featuers/auth/presentation/cubit/auth_state.dart';
import 'package:toury/featuers/auth/presentation/pages/login_view.dart';
import 'package:toury/featuers/customer/customer_nav_bar.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key, });
  

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisible = true;

  // String handleUserType() {
  //   return widget.userType == UserType.admin ? 'أدمن' : 'عميل';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            Navigator.pop(context);
            showErrorDialog(context, state.error);
          } else if (state is AuthLoadingState) {
            const CircularProgressIndicator(
              color: AppColors.color1,
            );
          } else if (state is AuthSuccessState) {
            if (_emailController == adminEmail) {
              pushAndRemoveUntil(context,const AdminNavBar());
              log('Admin signup');
            } else {
              pushAndRemoveUntil(context, const CustomerNavBar());
              log('Customer signup');
            }
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/images/logo.json",
                          width: 200.w, height: 200.h),
                      const SizedBox(height: 20),
                      Text(
                        'سجل حساب جديد',
                        style: getTitleStyle(),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _displayName,
                        style: const TextStyle(color: AppColors.black),
                        decoration: InputDecoration(
                          hintText: 'الاسم',
                          hintStyle: getBodyStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return 'من فضلك ادخل الاسم';
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(
                          hintText: 'الايميل',
                          prefixIcon: Icon(Icons.email_rounded),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل الايميل';
                          } else if (!emailValidate(value)) {
                            return 'من فضلك ادخل الايميل صحيحا';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        textAlign: TextAlign.end,
                        style: const TextStyle(color: AppColors.black),
                        obscureText: isVisible,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: '********',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon((isVisible)
                                  ? Icons.remove_red_eye
                                  : Icons.visibility_off_rounded)),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) return 'من فضلك ادخل كلمة السر';
                          return null;
                        },
                      ),
                      const Gap(30),
                      CustomButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().register(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  name: _displayName.text,
                                  userType: UserType.customer,
                                );
                          }
                        },
                        text: "تسجيل حساب",
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لدي حساب ؟',
                              style: getBodyStyle(color: AppColors.black),
                            ),
                            TextButton(
                                onPressed: () {
                                  pushReplacement(context,
                                    const  LoginView());
                                },
                                child: Text(
                                  'سجل دخول',
                                  style: getBodyStyle(color: AppColors.color1),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
