import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/user_model.dart';

sealed class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

sealed class EditProfileFormState extends EditProfileState {
  const EditProfileFormState({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.isSaving,
  });

  final String name;
  final int? age;
  final String? gender;
  final double? height;
  final double? weight;
  final bool isSaving;

  @override
  List<Object?> get props => [name, age, gender, height, weight, isSaving];
}

final class EditProfileInitial extends EditProfileFormState {
  const EditProfileInitial({
    required super.name,
    required super.age,
    required super.gender,
    required super.height,
    required super.weight,
  }) : super(isSaving: false);
}

final class EditProfileEditing extends EditProfileFormState {
  const EditProfileEditing({
    required super.name,
    required super.age,
    required super.gender,
    required super.height,
    required super.weight,
  }) : super(isSaving: false);
}

final class EditProfileSaving extends EditProfileFormState {
  const EditProfileSaving({
    required super.name,
    required super.age,
    required super.gender,
    required super.height,
    required super.weight,
  }) : super(isSaving: true);
}

final class EditProfileSuccess extends EditProfileState {
  const EditProfileSuccess(this.user);

  final UserModel user;

  @override
  List<Object?> get props => [user];
}

final class EditProfileFailure extends EditProfileState {
  const EditProfileFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
