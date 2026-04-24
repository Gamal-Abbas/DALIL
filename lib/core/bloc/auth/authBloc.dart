import 'package:dalil/core/bloc/auth/authState.dart';
import 'package:dalil/features/Auth/validateHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class authBloc extends Cubit<Authstate> {
  authBloc() : super(AuthInitial());

  Future<void> signupEmail({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        emit(AuthSuccess());
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
      } else {



        emit(AuthError(message: 'User=null'));
      }
    } on FirebaseAuthException catch (e) {
      var  error;
      if (e.code == 'email-already-in-use') {
        error="البريد الإلكتروني ده مسجل عندنا فعلاً، جرب تسجل دخول.";
      }  else if (e.code == 'invalid-email') {
        error="صيغة البريد الإلكتروني غير صحيحة.";
      }
     else  if (e.code == 'weak-password') {
        print('كلمة السر ضعيفة جداً.');
      }
      else {
        error="حصل مشكلة: ${e.message}";
        // لأي خطأ تاني غير متوقع
      }
      emit(AuthError(message: error.toString()));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      print(e);
    }
  }

  Future<void> loginEmail({required email, required password}) async {
    try {
      emit(AuthLoading());

      final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
final user=FirebaseAuth.instance.currentUser;
      if (user != null) {

        await user.reload();

        if (!(user.emailVerified)) {

          DateTime creationTime = user.metadata.creationTime!;
          DateTime now = DateTime.now();
          Duration difference = now.difference(creationTime);

          if (difference.inDays >= 3) {
            try {
              // امسح الحساب القديم لأنه أصبح "مهجور"
              await user.delete();

              // قوله يروح يسجل من جديد
            emit(AuthDeleted(
                message:  "حسابك القديم انتهت صلاحية تفعيله، برجاء التسجيل من جديد."));
            } catch (e) {
              // أحياناً الحذف بيطلب re-authentication لو فات وقت طويل
              print("خطأ في الحذف تلقائياً: $e");
            }
          }
          else {
            // لسه قدامه وقت.. ابعتله إيميل تفعيل تاني
            await user.sendEmailVerification();
            emit(authVerified(isVerified: false));
          }

          await FirebaseAuth.instance.signOut();



        }


        else {
          emit(AuthSuccess(Google: true));
        }
      } else {
        emit(AuthError(message: 'Error'));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('لا يوجد مستخدم بهذا البريد.');
      } else if (e.code == 'wrong-password') {
        print('كلمة السر غير صحيحة.');
      } else {
        print(e.toString());
      }
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> handleResetPassword({
    required String email,
    required BuildContext context,
  }) async {
    final String _email = email.trim();

    if (_email.isEmpty) {
      emit(emailEmpty());
    } else {

      try {

        if( ValidationHelper.validateEmail(context,_email)!=null){
          emit(AuthError(message: 'Email is invalid'));

        }
        else{
        emit(AuthLoading());

        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        emit(verifySent(email: email));
      }
      } on FirebaseAuthException catch (e) {
        emit(AuthError(message: e.toString()));
      }
    }
  }

  Future<void> signOut_Email() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signOut_Google() async {
    await GoogleSignIn.instance.disconnect();
  }

  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final x = _googleSignIn.initialize(
    clientId:
        '641080345679-7lhqpd058ub38c7t5krfc232348an5o1.apps.googleusercontent.com',
    serverClientId:
        '641080345679-7lhqpd058ub38c7t5krfc232348an5o1.apps.googleusercontent.com',
  );
  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());
      // First, sign out any existing user to avoid reauth issues
      await _googleSignIn.signOut();

      // Trigger the authentication flow
      final googleUser = await _googleSignIn.authenticate();

      // Check if authentication was successful
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Check if we have the required tokens
      if (googleAuth.idToken == null) {
        return null;
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      emit(AuthSuccess());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error signing in with Google: $e');
      }
      emit(AuthError(message: e.toString()));
    }
  }
}
