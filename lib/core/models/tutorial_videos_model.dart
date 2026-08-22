import 'package:lift_log/core/extensions/muscle_group.dart';
import 'package:lift_log/core/utils/app_enums.dart';

class TutorialVideosModel {
  final String? id;
  final String? title;
  final String? description;
  final String? videoUrl;
  final String? thumbnailUrl;
  final MuscleGroup? muscleGroup;
  final DateTime? createdAt;

  TutorialVideosModel({
    this.id,
    this.title,
    this.description,
    this.videoUrl,
    this.thumbnailUrl,
    this.muscleGroup,
    this.createdAt,
  });

  factory TutorialVideosModel.fromJson(Map<String, dynamic> json) {
    return TutorialVideosModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      videoUrl: json['video_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      muscleGroup: json['muscle_group'] != null
          ? MuscleGroupExtension.fromString(json['muscle_group'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'muscle_group': muscleGroup?.toJson(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  TutorialVideosModel copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    MuscleGroup? muscleGroup,
    DateTime? createdAt,
  }) {
    return TutorialVideosModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
