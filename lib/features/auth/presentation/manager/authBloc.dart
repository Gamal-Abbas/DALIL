import 'package:depi_dalil/features/auth/data/repositories/auth_Repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'authState.dart';


class authBloc extends Cubit<Authstate> {
  final IEmailAuth _iEmailAuth;
  final ISocialAuth _iSocialAuth;
  final Token _token;
  authBloc(super.initialState,
      {required IEmailAuth iEmailAuth,
        required ISocialAuth iSocialAuth, required Token token})
      : _token = token, _iEmailAuth = iEmailAuth,
        _iSocialAuth = iSocialAuth;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    final status = await _iEmailAuth.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    emit(status);
  }
  Future<void> autoLogin() async {
    final savedUid = await _token.storage.read(key: 'token'); // ✅ بس قراءة
    if (savedUid != null) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.emailVerified) {
        emit(AuthSuccess());
        return;
      }
    }
    emit(UnAuthenticated());
  }

  Future<void> saveToken(String token) async {
    try {
      await _token.storage.write(key: 'token', value: token);
      // تأكيد الكتابة
      String? check = await _token.storage.read(key: 'token');
      print('✅ Token saved and verified: $check');
    } catch (e) {
      print('❌ Error saving token: $e');
    }
  }///

  Future<void> loginEmail({required String email, required String password}) async {
    emit(AuthLoading());
    final status = await _iEmailAuth.checkVerification(email: email,
        password: password);

    if (status is AuthSuccess) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) saveToken(user.uid);
    }
    emit(status);
  }

  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading());
    emit(await _iEmailAuth.resetPassword(email: email));
  }

  Future<void> deleteToken() async {
    await _token.storage.delete(key: 'token');
  }

  Future<void> signOut() async {
    await _iEmailAuth.signOut();
  }


  Future<void> signupEmail({required String email, required String password, required String name}) async {
    emit(AuthLoading());
    emit(await _iEmailAuth.signUp(email: email, password: password, name: name));
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    final userCredential = await _iSocialAuth.signIn();
    if (userCredential?.user?.uid != null) {
      saveToken(userCredential!.user!.uid);
      emit(AuthSuccess(Google: true));
    } else {
      emit(AuthError(message: 'فشل تسجيل الدخول'));
    }
  }
}