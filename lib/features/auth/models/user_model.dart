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
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
    };
  }
}
