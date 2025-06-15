import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toury/core/services/local_storage.dart';
import 'package:toury/core/utils/themes.dart';
import 'package:toury/featuers/admin/oreder_manager/presentation/cubit/order_manager_cubit.dart';
import 'package:toury/featuers/admin/products_manager/presentation/cubit/product_manager_cubit.dart';
import 'package:toury/featuers/auth/presentation/cubit/auth_cubit.dart';
import 'package:toury/featuers/customer/cart/presentation/cubit/cubit/cart_cubit.dart';
import 'package:toury/featuers/intro/pages/splash.dart';
import 'package:toury/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppLocalStorage.init();
  runApp(const Far5eti());
}

class Far5eti extends StatelessWidget {
  const Far5eti({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(),
            ),
            BlocProvider(
              create: (context) => CartCubit(),
            ),
            BlocProvider(create: (context) => ProductManagerCubit()),

            BlocProvider(create: (context) => OrderManagerCubit()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', ''),
              Locale('en', ''),
            ],
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
