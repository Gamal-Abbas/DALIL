import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../../core/utils/validateHelper.dart';
import '../../presentation/manager/authState.dart';

abstract class IEmailAuth {
  Future<Authstate> checkVerification({
    // 🆕
    required String email,
    required String password,
  });
  Future<Authstate> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<Authstate> resetPassword({required String email});

  Future<UserCredential> signIn({required email, required password});
  Future<Authstate> signUp({
    required String email,
    required String password,
    required String name,
  });
  Future<void> signOut();
}

abstract class ISocialAuth {
  Future<UserCredential?> signIn();
  Future<void> signOut();
}

class EmailAuth implements IEmailAuth {
  final IUserStorage _user;
  EmailAuth(this._user);
  @override
  @override
  Future<Authstate> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return AuthError(message: 'error'.tr());

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return AuthSuccess();
    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'wrong-password' || 'invalid-credential' => 'wrong_password'.tr(),
        'weak-password' => 'passwordLength'.tr(),
        'network-request-failed' => 'no_internet'.tr(),
        _ => 'error'.tr(),
      };
      return AuthError(message: message);
    } catch (e) {
      return AuthError(message: 'error'.tr());
    }
  }

  @override
  Future<Authstate> checkVerification({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await signIn(email: email, password: password);
      final user = userCredential.user;
      if (user == null) return AuthError(message: 'Error');
      await user.reload();
      if (user.emailVerified) return AuthSuccess();
      return await _handleUnVerified(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        return AuthError(message: 'invalidCredentials'.tr());
      } else if (e.code == 'network-request-failed') {
        return AuthError(message: 'No Internet Connection'.tr());
      }
      return AuthError(message: e.message ?? 'An error occurred'.tr());
    }
  }

  Future<Authstate> _handleUnVerified(User user) async {
    final difference = DateTime.now().difference(user.metadata.creationTime!);
    if (difference.inDays >= 3) {
      await user.delete();
      return AuthDeleted(
        message: "حسابك القديم انتهت صلاحية تفعيله، برجاء التسجيل من جديد.",
      );
    }
    await user.sendEmailVerification();
    await signOut();
    return authVerified(isVerified: false);
  }

  Future<Authstate> resetPassword({required String email}) async {
    final String _email = email.trim();
    print('reset===================');

    try {
      print('reset===================');

      if (_email.isEmpty) {
        return emailEmpty();
        // emit(emailEmpty());
      } else {
        final validator = ValidationHelper.validateEmail(_email);
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
      print('errroi===================');

      return AuthError(message: e.toString());
    }
  }

  @override
  Future<Authstate> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // emit(AuthLoading());

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        _user.storeUserData(
          email: email,
          name: name,
          userCredential: credential,
        );
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

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<UserCredential> signIn({required email, required password}) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

class GoogleAuth implements ISocialAuth {
  final IUserStorage _iUserStorage;
  final Token _token;
  GoogleAuth(this._token, this._iUserStorage);

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  @override
  Future<UserCredential?> signIn() async {
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
      await _iUserStorage.storeUserData(
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

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        FirebaseAuth.instance.signOut(),
        GoogleSignIn.instance.disconnect(),
        _token.deleteToken(),
      ]);
    } catch (e) {
      throw e.toString();
    }
  }
}

abstract class IUserStorage {
  Future<void> storeUserData({
    required UserCredential userCredential,
    required String email,
    required String name,
  });
}

class FirestoreUserStorage implements IUserStorage {
  @override
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
}

class Token {
  final storage = FlutterSecureStorage();

  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }
}
