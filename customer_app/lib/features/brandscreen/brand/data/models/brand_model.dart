class BrandModel {
  final String id;
  final String name;
  final String image;

  const BrandModel({required this.id, required this.name, required this.image});

  BrandModel copyWith({String? id, String? name, String? image}) {
    return BrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}
