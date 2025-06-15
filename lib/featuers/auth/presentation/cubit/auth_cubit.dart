import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toury/core/enum/user_type_enum.dart';
import 'package:toury/core/services/local_storage.dart';
import 'package:toury/featuers/auth/presentation/cubit/auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  login(String email, String password) async {
    emit(AuthLoadingState());
    try {
      var userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      AppLocalStorage.cacheData(
          key: AppLocalStorage.userToken, value: user.uid);
      emit(AuthSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthErrorState("الحساب غير موجود"));
      } else if (e.code == 'wrong-password') {
        emit(AuthErrorState("كلمة المرور غير صحيحة"));
      } else {
        emit(AuthErrorState("حدث خطأ ما."));
      }
    } catch (e) {
      emit(AuthErrorState('حدث خطأ ما.'));
    }
  }

  register(
      {required String name,
      required String email,
      required String password,
      required UserType userType}) async {
    emit(AuthLoadingState());
    try {
      var userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      user.updateDisplayName(name);
      // store user data into our database
      if (userType == UserType.customer) {
        await FirebaseFirestore.instance
            .collection("customers")
            .doc(user.uid)
            .set({
          'name': name,
          'image': '',
          
          'email': email,
          'phone': '',
          'adress': '',
          
          'city': '',
          'uid': user.uid,
        });
      } else {
        await FirebaseFirestore.instance
            .collection("admins")
            .doc(user.uid)
            .set({
          'name': name,
          
          
          'rating': 3,
          'email': email,
          'phone1': '',
          'phone2': '',
          'bio': '',
          'openHour': '',
          'closeHour': '',
          'address': '',
          'uid': user.uid,
        });
      }
      AppLocalStorage.cacheData(
          key: AppLocalStorage.userToken, value: user.uid);
      emit(AuthSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthErrorState('كلمة المرور ضعيفة.'));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthErrorState('الحساب مستخدم بالفعل.'));
      }
    } catch (e) {
      emit(AuthErrorState('حدث خطأ ما.'));
    }
  }

  
}