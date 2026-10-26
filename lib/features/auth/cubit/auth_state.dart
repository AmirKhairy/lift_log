import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => const [];
}

class EmailAuthSuccess extends AuthState {
  const EmailAuthSuccess({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class EmailAuthLoading extends AuthState {
  const EmailAuthLoading();

  @override
  List<Object?> get props => const [];
}

class EmailAuthFailure extends AuthState {
  const EmailAuthFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class GoogleAuthSuccess extends AuthState {
  const GoogleAuthSuccess({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class GoogleAuthLoading extends AuthState {
  const GoogleAuthLoading();

  @override
  List<Object?> get props => const [];
}

class GoogleAuthFailure extends AuthState {
  const GoogleAuthFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class GoogleNewUserAuthSuccess extends AuthState {
  const GoogleNewUserAuthSuccess({
    required this.userName,
    required this.userEmail,
    required this.userId,
  });

  final String userId;
  final String userName;
  final String userEmail;

  @override
  List<Object?> get props => [userId, userName, userEmail];
}

class SelectAge extends AuthState {
  const SelectAge();

  @override
  List<Object?> get props => const [];
}

class SelectGender extends AuthState {
  const SelectGender();

  @override
  List<Object?> get props => const [];
}

class SelectWeight extends AuthState {
  const SelectWeight();

  @override
  List<Object?> get props => const [];
}

class SelectHeight extends AuthState {
  const SelectHeight();

  @override
  List<Object?> get props => const [];
}

class RegisterAuthSuccess extends AuthState {
  const RegisterAuthSuccess({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class RegisterAuthLoading extends AuthState {
  const RegisterAuthLoading();

  @override
  List<Object?> get props => const [];
}

class RegisterAuthFailure extends AuthState {
  const RegisterAuthFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class GoogleRegisterAuthSuccess extends AuthState {
  const GoogleRegisterAuthSuccess({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class GoogleRegisterAuthLoading extends AuthState {
  const GoogleRegisterAuthLoading();

  @override
  List<Object?> get props => const [];
}

class GoogleRegisterAuthFailure extends AuthState {
  const GoogleRegisterAuthFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ResetPasswordEmailSuccess extends AuthState {
  const ResetPasswordEmailSuccess();

  @override
  List<Object?> get props => const [];
}

class ResetPasswordEmailLoading extends AuthState {
  const ResetPasswordEmailLoading();

  @override
  List<Object?> get props => const [];
}

class ResetPasswordEmailFailure extends AuthState {
  const ResetPasswordEmailFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ResetPasswordSuccess extends AuthState {
  const ResetPasswordSuccess();

  @override
  List<Object?> get props => const [];
}

class ResetPasswordLoading extends AuthState {
  const ResetPasswordLoading();

  @override
  List<Object?> get props => const [];
}

class ResetPasswordFailure extends AuthState {
  const ResetPasswordFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
