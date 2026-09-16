import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/core/widgets/List_view_widget.dart';
import 'package:e_commerce_full_project/core/widgets/No_items_widget.dart';
import 'package:e_commerce_full_project/features/home/homescreen.dart';
import 'package:e_commerce_full_project/features/home/mycart/cubit/mycart_cubit.dart';
import 'package:e_commerce_full_project/features/home/mycart/widget/Fees_widget.dart';
import 'package:e_commerce_full_project/features/home/mycart/widget/cart_item_widget.dart';
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
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
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
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartInitial ||
                  state is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is CartError) {
                return Center(
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              if (state is CartLoaded) {
                final cartItems = state.items;
                if (cartItems.isEmpty) {
                  return NoItemsWidget(
                    mainText: 'your_cart_is_empty'.tr(),
                  );
                }
                double total = 0;

                for (final cartItem in cartItems) {
                  final price = cartItem.product.currentPrice;
                  final quantity = cartItem.quantity;

                  total += price * quantity;
                }

                final subtotal = total + delivery;

                return Column(
                  children: [
                    Expanded(
                      child: CustomListView(
                        Scroll: Axis.vertical,
                        padding: const EdgeInsets.all(16),
                        items: cartItems,
                        itemBuilder: (context, item, index) {
                          return CartItemWidget(
                            carti: item ,
                          );
                        },
                      ),
                    ),

                    // =========================
                    // FEES
                    // =========================
                    FeesWidget(
                      isCheckOut: false,
                      firstValue:
                          '\$${total.toStringAsFixed(2)}',
                      secondValue:
                          '\$${delivery.toStringAsFixed(2)}',
                      thirdValue:
                          '\$${subtotal.toStringAsFixed(2)}',
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}