class AdminBrandModel {
  final String id;
  final String name;
  final String image;

  const AdminBrandModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory AdminBrandModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminBrandModel(
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