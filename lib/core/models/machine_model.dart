import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/utils/app_enums.dart';

class MachineModel {
  final String? id;
  final String? name;
  final String? userId;
  final String? imageUrl;
  final String? tutorialVideoId;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final MuscleGroup? muscleGroup;

  MachineModel({
    this.id,
    this.name,
    this.userId,
    this.imageUrl,
    this.tutorialVideoId,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.muscleGroup,
  });

  factory MachineModel.fromJson(Map<String, dynamic> json) {
    return MachineModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      userId: json['user_id'] as String?,
      imageUrl: json['image_url'] as String?,
      tutorialVideoId: json['tutorial_video_id'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      muscleGroup: json['muscle_group'] != null
          ? MuscleGroupExtension.fromString(json['muscle_group'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_id': userId,
      'image_url': imageUrl,
      'tutorial_video_id': tutorialVideoId,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'muscle_group': muscleGroup?.toJson(),
    };
  }

  MachineModel copyWith({
    String? id,
    String? name,
    String? userId,
    String? imageUrl,
    String? tutorialVideoId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    MuscleGroup? muscleGroup,
  }) {
    return MachineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      tutorialVideoId: tutorialVideoId ?? this.tutorialVideoId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      muscleGroup: muscleGroup ?? this.muscleGroup,
    );
  }
}
