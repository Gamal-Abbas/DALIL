import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalil/core/bloc/auth/authState.dart';
import 'package:dalil/features/Auth/validateHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepo {
  Future<void> signOut_Email() async {
    await Future.wait([FirebaseAuth.instance.signOut()]);
  }

  Future<void> signOut_google() async {
    await Future.wait([GoogleSignIn.instance.disconnect()]);
  }

  Future<Authstate> handleResetPassword({
    required String email,
    required BuildContext context,
  }) async {
    final String _email = email.trim();

    try {
      if (_email.isEmpty) {
        return emailEmpty();
        // emit(emailEmpty());
      } else {
        final validator = ValidationHelper.validateEmail(context, _email);
        if (validator != null) {
          print('1=========');
          return AuthError(message: validator);
          // emit(AuthError(message: 'Email is invalid'));
        } else {
          // AuthLoading();
          // emit(AuthLoading());

          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          return verifySent(email: email);
          // emit(verifySent(email: email));
        }
      }
    } on FirebaseAuthException catch (e) {
      print('2=========');

      return AuthError(message: e.toString());
      // emit(AuthError(message: e.toString()));
    } catch (e) {
      return AuthError(message: e.toString());
    }
  }

  Future<Authstate> checkVerication({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await loginEmail(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        await user.reload();

        if (!(user.emailVerified)) {
          DateTime creationTime = user.metadata.creationTime!;
          DateTime now = DateTime.now();
          Duration difference = now.difference(creationTime);

          if (difference.inDays >= 3) {
            try {
              await user.delete();
              return AuthDeleted(
                message:
                    "حسابك القديم انتهت صلاحية تفعيله، برجاء التسجيل من جديد.",
              );
            } catch (e) {
              return AuthDeleted(message: e.toString());
            }
          } else {
            await user.sendEmailVerification();
            await signOut_Email();
            return authVerified(isVerified: false);
          }
        } else {
          return AuthSuccess(Google: true);
        }
      } else {
        return AuthError(message: 'Error');
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg;
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        errorMsg = 'invalidCredentials'.tr();
      } else if (e.code == 'network-request-failed') {
        errorMsg = 'No Internet Connection'.tr();
      } else {
        errorMsg = e.message ?? 'An error occurred'.tr();
      }
      return AuthError(message: errorMsg);
    }
  }

  Future<UserCredential> loginEmail({required email, required password}) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////
  Future<Authstate> signupEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // emit(AuthLoading());

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        storeUserData(email: email, name: name, userCredential: credential);
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        return AuthSuccess();
        // emit(AuthSuccess());
        // FirebaseAuth.instance.currentUser!.sendEmailVerification();
      } else {
        return AuthError(message: 'user=null');
        // emit(AuthError(message: 'User=null'));
      }
    } on FirebaseAuthException catch (e) {
      var error;
      if (e.code == 'email-already-in-use') {
        error = "البريد الإلكتروني ده مسجل عندنا فعلاً، جرب تسجل دخول.";
      } else if (e.code == 'invalid-email') {
        error = "صيغة البريد الإلكتروني غير صحيحة.";
      } else if (e.code == 'weak-password') {
        print('كلمة السر ضعيفة جداً.');
      } else {
        "invalidCredentials".tr();
        // لأي خطأ تاني غير متوقع
      }
      return AuthError(message: error.toString());
      // emit(AuthError(message: error.toString()));
    } catch (e) {
      return AuthError(message: e.toString());

      // emit(AuthError(message: e.toString()));
      // print(e);
    }
  }

  Future<void> storeUserData({
    required UserCredential userCredential,
    required String email,
    required String name,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
          'uid': userCredential.user!.uid,
          'name': name,
          'email': email,
          'createdAt': DateTime.now(),
        });

    print('=' * 50);
    print(
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid),
    );
    print('=' * 50);
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<UserCredential?> signInWithGoogle() async {
    final x = _googleSignIn.initialize(
      clientId:
          '641080345679-7lhqpd058ub38c7t5krfc232348an5o1.apps.googleusercontent.com',
      serverClientId:
          '641080345679-7lhqpd058ub38c7t5krfc232348an5o1.apps.googleusercontent.com',
    );
    print('signInWithGoogle==================');
    try {
      // emit(AuthLoading());
      print('try==================');

      // First, sign out any existing user to avoid reauth issues
      await _googleSignIn.signOut();

      // Trigger the authentication flow
      final googleUser = await _googleSignIn.authenticate();

      // Check if authentication was successful
      if (googleUser == null) {
        return null;
        // return AuthError(message: 'googleUser == null');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Check if we have the required tokens
      if (googleAuth.idToken == null) {
        return null;
        // return AuthError(message: 'googleUser == null');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      // saveToken(userCredential.user!.uid);
      await storeUserData(
        email: googleUser.email,
        name: googleUser.displayName ?? "No name",
        userCredential: userCredential,
      );
      return userCredential;
      // emit(AuthSuccess());
    } catch (e) {
      print('catch==================');
      print(e.toString());

      if (kDebugMode) {
        debugPrint('Error signing in with Google: $e');
      }
      return null;
      // return AuthError(message: e.toString());
      // emit(AuthError(message: e.toString()));
    }
  }
}
