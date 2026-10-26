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

sealed class ProfileUserState extends ProfileState {
  const ProfileUserState(this.user);

  final UserModel user;

  @override
  List<Object?> get props => [user];
}

final class ProfileLoaded extends ProfileUserState {
  const ProfileLoaded(super.user);
}

final class ProfileLoggingOut extends ProfileUserState {
  const ProfileLoggingOut(super.user);
}

final class ProfileDeletingAccount extends ProfileUserState {
  const ProfileDeletingAccount(super.user);
}

final class ProfileActionError extends ProfileUserState {
  const ProfileActionError({required UserModel user, required this.message})
    : super(user);

  final String message;

  @override
  List<Object?> get props => [user, message];
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
