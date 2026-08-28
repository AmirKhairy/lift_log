import 'package:equatable/equatable.dart';
import 'package:lift_log/core/models/user_model.dart';

sealed class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

final class EditProfileInitial extends EditProfileState {
  const EditProfileInitial({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    this.isSaving = false,
  });

  final String name;
  final int? age;
  final String? gender;
  final double? height;
  final double? weight;
  final bool isSaving;

  EditProfileInitial copyWith({
    String? name,
    int? age,
    String? gender,
    double? height,
    double? weight,
    bool? isSaving,
  }) {
    return EditProfileInitial(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [name, age, gender, height, weight, isSaving];
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
