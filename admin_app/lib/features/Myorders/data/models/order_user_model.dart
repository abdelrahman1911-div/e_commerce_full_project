class OrderUserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String address;
  const OrderUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });
  factory OrderUserModel.fromMap({
    required String uid,
    required Map<String, dynamic> data,
  }) {
    return OrderUserModel(
      uid: uid,
      name: data['name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
    );
  }
}
