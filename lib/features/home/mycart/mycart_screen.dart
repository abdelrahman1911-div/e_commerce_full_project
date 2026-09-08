import 'package:e_commerce_full_project/core/widgets/List_view_widget.dart';
import 'package:e_commerce_full_project/core/widgets/No_items_widget.dart';
import 'package:e_commerce_full_project/features/home/homescreen.dart';
import 'package:e_commerce_full_project/features/home/mycart/widget/Fees_widget.dart';
import 'package:e_commerce_full_project/features/home/mycart/widget/cart_item_widget.dart';
import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/features/home/mycart/cubit/mycart_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MycartScreen extends StatelessWidget {
  const MycartScreen({super.key});
  static const double delivery = 45.0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'my_cart_title'.tr(),
            style: AppTextStyles.title(context),
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
        ),
        body: SafeArea(
          child: BlocBuilder<CartCubit, List<ProductModel>>(
            builder: (context, cartProducts) {
              if (cartProducts.isEmpty) {
                return NoItemsWidget(mainText: 'your_cart_is_empty'.tr());
              }
              double total = 0;
              for (final product in cartProducts) {
                final price =
                    double.tryParse(
                      product.currentPrice
                          .toString()
                          .replaceAll('\$', '')
                          .trim(),
                    ) ??
                    0;
                final quantity = product.quantity;
                total += price * quantity;
              }
              final subtotal = total + delivery;
              return Column(
                children: [
                  Expanded(
                    child: CustomListView( 
                      Scroll: Axis.vertical,
                      padding: const EdgeInsets.all(16),
                      items: cartProducts,
                      itemBuilder: (context, item, index) {
                        final item = cartProducts[index];
                        return CartItemWidget(product: item);
                      },
                    ),
                  ),
                  FeesWidget( 
                    isCheckOut: false,
                    firstValue: '\$${total.toStringAsFixed(2)}',
                    secondValue: '\$${delivery.toStringAsFixed(2)}',
                    thirdValue: '\$${subtotal.toStringAsFixed(2)}',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
