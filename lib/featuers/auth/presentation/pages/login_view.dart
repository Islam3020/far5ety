import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
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
import 'package:toury/featuers/auth/presentation/pages/Register_view.dart';
import 'package:toury/featuers/customer/customer_nav_bar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, });
  

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisible = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            Navigator.pop(context);
            showToast(context, state.error,isError: true);
          } else if (state is AuthLoadingState) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Row(
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(width: 16.w),
                        const Text('جاري تسجيل الدخول...'),
                      ],
                    ),
                  );
                },
              );
          } else if (state is AuthSuccessState) {
            if (_emailController.text== adminEmail) {
              pushAndRemoveUntil(context, const AdminNavBar());
              showToast(context, 'تم تسجيل الدخول بنجاح');
              log('admin');
            } else {
              log('customer');
              pushAndRemoveUntil(context, const CustomerNavBar());
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Lottie.asset("assets/images/logo.json",
                          width: 200.w, height: 200.h),
                      const SizedBox(height: 20),
                      Text(
                        'سجل دخول الان ',
                        style: getTitleStyle(),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(
                          hintText: 'ادخل الايميل',
                          prefixIcon: Icon(Icons.email_rounded),
                        ),
                        textInputAction: TextInputAction.next,
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
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(top: 5, right: 10),
                        child: Text(
                          'نسيت كلمة السر ؟',
                          style: getSmallStyle(),
                        ),
                      ),
                      const Gap(20),
                      CustomButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                          }
                        },
                        text: "تسجيل الدخول",
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ليس لدي حساب ؟',
                              style: getBodyStyle(color: AppColors.black),
                            ),
                            TextButton(
                                onPressed: () {
                                  pushReplacement(context,
                                    const  RegisterView());
                                },
                                child: Text(
                                  'سجل الان',
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
