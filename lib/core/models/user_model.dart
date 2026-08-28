class UserModel {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int age;
  final double height;
  final double weight;
  final String gender;

  UserModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      age: (json['age'] as num).toInt(),
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      gender: json['gender'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? age,
    double? height,
    double? weight,
    String? gender,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
    );
  }
}
