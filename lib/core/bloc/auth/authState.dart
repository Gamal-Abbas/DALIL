abstract class Authstate {}
class AuthInitial extends Authstate {}
class AuthLoading extends Authstate {}
class AuthSuccess extends Authstate {
  final bool? Google;
  AuthSuccess({ this.Google});
}
class emailEmpty extends Authstate {}
class verifySent extends Authstate {
  final String email;
  verifySent({required this.email});
}

class authVerified extends Authstate {
  final bool isVerified;

  authVerified({required this.isVerified,
    });

}
class AuthError extends Authstate {
  final String message;
  AuthError({required this.message});
}

class AuthDeleted  extends Authstate {
  final String message;
  AuthDeleted({required this.message});
}