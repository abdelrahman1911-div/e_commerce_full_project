import 'package:e_commerce_full_project/features/settingscreen/Myorders/orderModel.dart';
import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCubit extends Cubit<List<OrderModel>> {
  OrderCubit() : super([]);

  void addOrder({
    required List<ProductModel> products, 
    String? id , 
    required double totalPrice,
    required String address,
    required String paymentMethod,
  }) {
    final order = OrderModel(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),

      products: products,

      totalPrice: totalPrice,

      address: address,

      status: 'Processing',

      paymentMethod: paymentMethod,

      date: DateTime.now(),
    );

    emit([
      ...state,
      order,
    ]);
  }

  void removeOrder(String orderId) {
    final updatedOrders = state
        .where(
          (order) => order.id != orderId,
        )
        .toList();

    emit(updatedOrders);
  } 
  List<ProductModel> getOrderProducts(String orderId) {
  try {
    final order = state.firstWhere(
      (order) => order.id == orderId,
    );
    return order.products;
  } catch (e) {
    return [];
  }
}
 
  void clearOrders() {
    emit([]);
  }
}