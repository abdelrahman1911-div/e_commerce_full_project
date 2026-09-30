import 'package:e_commerce_full_project/features/CheckOut/order_success/widgets/celebration_header.dart';
import 'package:e_commerce_full_project/features/CheckOut/order_success/widgets/celebration_widget.dart';
import 'package:e_commerce_full_project/features/home/homescreen.dart';
import 'package:flutter/material.dart';
class OrderSuccessScreen extends StatefulWidget { 
  final String orderId ; 
  const OrderSuccessScreen({super.key , required this.orderId});
  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}
class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      },
      child: Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          CelebrationHeader(orderId: widget.orderId), 
          CelebrationWidget()
        ],
      ),
    )
    );
  }
}