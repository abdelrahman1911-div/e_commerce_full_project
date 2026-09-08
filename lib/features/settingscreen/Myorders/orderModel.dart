import 'package:e_commerce_full_project/features/home/product/product_model.dart';

class OrderModel {
  final String id;
  final List<ProductModel> products;
  final double totalPrice;
  final String address;
  final String status;
  final DateTime date;
  final String paymentMethod; 
  OrderModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.address,
    required this.status,
    required this.date, 
   required this.paymentMethod,

  });
}