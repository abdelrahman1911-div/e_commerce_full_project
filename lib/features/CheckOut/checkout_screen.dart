import 'dart:developer';

import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/core/widgets/No_items_widget.dart';
import 'package:e_commerce_full_project/features/CheckOut/order_success/order_success_screen.dart';
import 'package:e_commerce_full_project/features/CheckOut/widgets/address_widget.dart';
import 'package:e_commerce_full_project/features/CheckOut/widgets/choose_payment.dart';
import 'package:e_commerce_full_project/features/CheckOut/widgets/delivery_widget.dart';
import 'package:e_commerce_full_project/features/home/mycart/cubit/mycart_cubit.dart';
import 'package:e_commerce_full_project/features/home/mycart/data/model/cart_item_model.dart';
import 'package:e_commerce_full_project/features/home/mycart/widget/Fees_widget.dart';
import 'package:e_commerce_full_project/features/home/mycart/widget/cart_item_widget.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/order_cubit.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/pay_pref_states.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/payment_preference_services.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/paymentPerferences_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final double delivery = 45.0;

  final String selectedAddress = '8295 / 2 el maraag el sofly Cairo, Egypt';

  final TextEditingController addressController = TextEditingController(
    text: "Atletico Madrid znzana 7",
  );

  final TextEditingController phoneController = TextEditingController(
    text: '+201000000000',
  );

  final TextEditingController nameController = TextEditingController(
    text: "Julian Alvarez",
  );

  bool isadressEditing = false;
  bool isPhoneEditing = false;
  bool isNameEditing = false;

  final orderId = DateTime.now().millisecondsSinceEpoch.toString();

  String deliveryway = "";

  Future<void> _changePaymentPreference() async {
    final cubit = context.read<PaymentPreferenceCubit>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const PaymentPreferenceScreen(),
        ),
      ),
    );

    if (!mounted) return;
  }

  @override
  void dispose() {
    addressController.dispose();
    phoneController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('checkout'.tr(), style: AppTextStyles.headline(context)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.horizontal(),
          ),
        ),
      ),

      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            // =========================
            // Loading
            // =========================

            if (cartState is CartInitial || cartState is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // =========================
            // Error
            // =========================

            if (cartState is CartError) {
              return Center(
                child: Text(cartState.message, textAlign: TextAlign.center),
              );
            }

            // =========================
            // Cart Loaded
            // =========================

            if (cartState is CartLoaded) {
              final List<CartItemModel> cartItems = cartState.items;

              // Empty cart
              if (cartItems.isEmpty) {
                return NoItemsWidget(mainText: 'your_cart_is_empty'.tr());
              }

              // =========================
              // Calculate total
              // =========================

              double total = 0;

              for (final cartItem in cartItems) {
                final price = cartItem.product.currentPrice;

                final quantity = cartItem.quantity;

                total += price * quantity;
              }

              final subtotal = total + delivery;

              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                children: [
                  // =========================
                  // Cart Items
                  // =========================
                  ...cartItems.map(
                    (cartItem) => CartItemWidget(carti: cartItem),
                  ),
                  SizedBox(height: 20.h),

                  // =========================
                  // Shipping Address
                  // =========================
                  Text(
                    'shipping_address'.tr(),
                    style: theme.textTheme.titleMedium,
                  ),

                  SizedBox(height: 2.h),

                  AddressWidget(
                    controller: addressController,
                    isPhone: false,
                    isName: false,
                  ),

                  AddressWidget(
                    controller: phoneController,
                    isPhone: true,
                    isName: false,
                  ),

                  AddressWidget(
                    controller: nameController,
                    isPhone: false,
                    isName: true,
                  ),

                  SizedBox(height: 20.h),

                  // =========================
                  // Payment
                  // =========================
                  ChoosePayment(onChangePayment: _changePaymentPreference),

                  SizedBox(height: 20.h),

                  // =========================
                  // Delivery
                  // =========================
                  DeliveryWidget(
                    deliveryway: deliveryway,

                    fedexClick: () {
                      setState(() {
                        deliveryway = "fedex";
                      });
                    },

                    dhlClick: () {
                      setState(() {
                        deliveryway = "dhl";
                      });
                    },
                  ),

                  SizedBox(height: 30.h),

                  // =========================
                  // Fees + Checkout
                  // =========================
                  BlocBuilder<PaymentPreferenceCubit, PaymentPreferenceState>(
                    builder: (context, paymentState) {
                      String selectedPayment = 'cash';

                      if (paymentState is PaymentPreferenceSuccess) {
                        selectedPayment = paymentState.selectedPayment;
                      }

                      return FeesWidget(
                        buttonText: 'check_out'.tr(),
                        isCheckOut: true,

                        firstWord: 'total'.tr(),
                        firstValue: '\$${total.toStringAsFixed(2)}',

                        secondWord: 'delivery_fees'.tr(),
                        secondValue: '\$${delivery.toStringAsFixed(2)}',

                        thirdWord: 'delivered_by'.tr(),

                        thirdValue: deliveryway.isEmpty
                            ? 'not_selected'.tr()
                            : deliveryway == "fedex"
                            ? 'fedex'.tr()
                            : 'dhl'.tr(),

                        fourWord: 'subtotal'.tr(),
                        fourValue: '\$${subtotal.toStringAsFixed(2)}',

                        fiveWord: 'payment_method'.tr(),

                        fiveValue: selectedPayment == "card"
                            ? 'card'.tr()
                            : 'cash'.tr(),

                        // =========================
                        // Place Order
                        // =========================
                        onPressed: () async {
                          final paymentState = context
                              .read<PaymentPreferenceCubit>()
                              .state;

                          String selectedPayment = 'cash';

                          if (paymentState is PaymentPreferenceSuccess) {
                            selectedPayment = paymentState.selectedPayment;
                          }

                          // -------------------------
                          // Check delivery
                          // -------------------------

                          if (deliveryway.isEmpty) {
                            log("Select delivery way");

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'please_select_payment_and_delivery'.tr(),
                                ),
                              ),
                            );

                            return;
                          }
                          if (cartItems.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('your_cart_is_empty'.tr()),
                              ),
                            );

                            return;
                          }
                          try {
                            await context.read<OrderCubit>().addOrder(
                              products: cartItems,
                              id: orderId,
                              totalPrice: subtotal,
                              address: addressController.text.trim(),
                              paymentMethod: selectedPayment,
                            );
                            if (!context.mounted) return;
                            context.push(AppRoutes.orderScreen, extra: orderId);
                            await context.read<CartCubit>().clearCart();
                          } catch (e) {
                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to place order: $e'),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
