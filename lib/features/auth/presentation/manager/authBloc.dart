
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/repositories/auth_Repo.dart';
import 'authState.dart';

class authBloc extends Cubit<Authstate> {
  final AuthRepo _repository;

  authBloc({required AuthRepo repository})
    : _repository = repository,
      super(AuthInitial());
  final storage = FlutterSecureStorage();

  Future<void> autoLogin() async {
    await storage.delete(key: 'token');

    String? savedUid = await storage.read(key: 'token');
    print('==================================================');
    print(savedUid);
    await Future.delayed(Duration(milliseconds: 500));
    if (savedUid != null) {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null && currentUser.emailVerified) {
        emit(AuthSuccess());
      } else {
        emit(UnAuthenticated());
      }
    } else {
      emit(UnAuthenticated());
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await storage.write(key: 'token', value: token);
      // تأكيد الكتابة
      String? check = await storage.read(key: 'token');
      print('✅ Token saved and verified: $check');
    } catch (e) {
      print('❌ Error saving token: $e');
    }
  }

  Future<void> loginEmail({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final status = await _repository.checkVerication(
      email: email,
      password: password,
    );
    final user = FirebaseAuth.instance.currentUser;
    if (status is AuthSuccess) {
      saveToken(user!.uid);

      // emit(AuthSuccess(Google: true));
    } else if (status is AuthDeleted) {
      // emit(
      //   AuthDeleted(
      //     message: "حسابك القديم انتهت صلاحية تفعيله، برجاء التسجيل من جديد.",
      //   ),
      // );
    } else if (status is authVerified) {
      await user?.sendEmailVerification();
      // emit(authVerified(isVerified: false));
    } else {
      // emit(AuthError(message: 'error'));
    }
    emit(status);
  }

  Future<void> handleResetPassword({
    required String email,
    required BuildContext context,
  }) async {
    print('reset===================');
    emit(AuthLoading());
    final String _email = email.trim();

    final status = await _repository.handleResetPassword(
      email: _email,
      context: context,
    );
    print('resssst============');
    print(status);
    emit(status);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }

  Future <void> signOut()async{
    await _repository.signOut();
  }
  // Future<void> signOut_Email() async {
  //   _repository.signOut_Email();
  //   // await Future.wait([FirebaseAuth.instance.signOut(), deleteToken()]);
  // }
  //
  // Future<void> signOut_Google() async {
  //   _repository.signOut_google();
  //
  //   // await Future.wait([GoogleSignIn.instance.disconnect(), deleteToken()]);
  // }

  Future<void> signupEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());
    final status = await _repository.signupEmail(
      email: email,
      password: password,
      name: name,
    );
    emit(status);
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    final userCredential = await _repository.signInWithGoogle();

    if (userCredential?.user?.uid != null) {
      saveToken(userCredential!.user!.uid);
      emit(AuthSuccess(Google: true));
    } else {
      emit(AuthError(message: 'userCredential==null'));
    }
  }
}
