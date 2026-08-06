abstract class AuthState {}

class AuthInitial extends AuthState {}

class EmailAuthSuccess extends AuthState {
  final String userId;
  EmailAuthSuccess({required this.userId});
}

class EmailAuthLoading extends AuthState {}

class EmailAuthFailure extends AuthState {
  final String message;

  EmailAuthFailure(this.message);
}

class GoogleAuthSuccess extends AuthState {
  final String userId;
  GoogleAuthSuccess({required this.userId});
}

class GoogleAuthLoading extends AuthState {}

class GoogleAuthFailure extends AuthState {
  final String message;

  GoogleAuthFailure(this.message);
}

class GoogleNewUserAuthSuccess extends AuthState {
  final String userId;
  final String userName;
  final String userEmail;
  GoogleNewUserAuthSuccess({
    required this.userName,
    required this.userEmail,
    required this.userId,
  });
}

// ========================================== Register ==========================================

class SelectAge extends AuthState {}

class SelectGender extends AuthState {}

class SelectWeight extends AuthState {}

class SelectHeight extends AuthState {}

class RegisterAuthSuccess extends AuthState {
  final String userId;
  RegisterAuthSuccess({required this.userId});
}

class RegisterAuthLoading extends AuthState {}

class RegisterAuthFailure extends AuthState {
  final String message;

  RegisterAuthFailure(this.message);
}

class GoogleRegisterAuthSuccess extends AuthState {
  final String userId;
  GoogleRegisterAuthSuccess({required this.userId});
}

class GoogleRegisterAuthLoading extends AuthState {}

class GoogleRegisterAuthFailure extends AuthState {
  final String message;

  GoogleRegisterAuthFailure(this.message);
}

class ResetPasswordEmailSuccess extends AuthState {}

class ResetPasswordEmailLoading extends AuthState {}

class ResetPasswordEmailFailure extends AuthState {
  final String message;

  ResetPasswordEmailFailure(this.message);
}

class ResetPasswordSuccess extends AuthState {}

class ResetPasswordLoading extends AuthState {}

class ResetPasswordFailure extends AuthState {
  final String message;

  ResetPasswordFailure(this.message);
}
