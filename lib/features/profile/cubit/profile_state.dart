import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/user_model.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.user,
    this.isLoggingOut = false,
    this.isDeletingAccount = false,
    this.actionError,
  });

  final UserModel user;
  final bool isLoggingOut;
  final bool isDeletingAccount;
  final String? actionError;

  ProfileLoaded copyWith({
    UserModel? user,
    bool? isLoggingOut,
    bool? isDeletingAccount,
    String? actionError,
    bool clearActionError = false,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      actionError: clearActionError ? null : actionError ?? this.actionError,
    );
  }

  @override
  List<Object?> get props => [
    user,
    isLoggingOut,
    isDeletingAccount,
    actionError,
  ];
}

final class ProfileLoggedOut extends ProfileState {
  const ProfileLoggedOut();
}

final class ProfileAccountDeleted extends ProfileState {
  const ProfileAccountDeleted();
}

final class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
