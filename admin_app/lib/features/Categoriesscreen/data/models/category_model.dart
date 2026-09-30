class AdminCategoryModel {
  final String id;
  final String name;
  final String image;

  const AdminCategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory AdminCategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}