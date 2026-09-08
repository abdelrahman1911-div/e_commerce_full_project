import 'dart:developer';
import 'package:e_commerce_full_project/core/widgets/No_items_widget.dart';
import 'package:e_commerce_full_project/features/CheckOut/widgets/address_widget.dart';
import 'package:e_commerce_full_project/features/CheckOut/widgets/choose_payment.dart';
import 'package:e_commerce_full_project/features/CheckOut/widgets/delivery_widget.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/pay_pref_states.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/payment_preference_services.dart';
import 'package:e_commerce_full_project/features/home/mycart/widget/Fees_widget.dart';
import 'package:e_commerce_full_project/features/home/mycart/widget/cart_item_widget.dart';
import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/cubit/order_cubit.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/paymentPerferences_screen.dart';
import 'package:e_commerce_full_project/features/home/mycart/cubit/mycart_cubit.dart';
import 'package:e_commerce_full_project/features/CheckOut/order_success/order_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        child: BlocBuilder<CartCubit, List<ProductModel>>(
          builder: (context, cartProducts) {
            if (cartProducts.isEmpty) {
              return NoItemsWidget(mainText: 'your_cart_is_empty'.tr());
            }
            double total = 0;
            for (final product in cartProducts) {
              final price =
                  double.tryParse(
                    product.currentPrice.toString().replaceAll('\$', '').trim(),
                  ) ??
                  0;
              final quantity = product.quantity;
              total += price * quantity;
            }
            final subtotal = total + delivery;
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              children: [
                ...cartProducts.map(
                  (product) => CartItemWidget(product: product),
                ),
                SizedBox(height: 20.h),
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
                  isPhone: false,
                  controller: nameController,
                  isName: true,
                ),
                SizedBox(height: 20.h),
                ChoosePayment(onChangePayment: _changePaymentPreference),
                SizedBox(height: 20.h),
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
                      onPressed: () {
                        final paymentState = context
                            .read<PaymentPreferenceCubit>()
                            .state;
                        String selectedPayment = 'cash';
                        if (paymentState is PaymentPreferenceSuccess) {
                          selectedPayment = paymentState.selectedPayment;
                        }
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
                        final cartCubit = context.read<CartCubit>();
                        final cart = cartCubit.state;
                        if (cart.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('your_cart_is_empty'.tr())),
                          );
                          return;
                        }
                        context.read<OrderCubit>().addOrder(
                          products: cart,
                          id: orderId,
                          totalPrice: subtotal,
                          address: addressController.text,
                          paymentMethod: selectedPayment,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderSuccessScreen(orderId: orderId),
                          ),
                        );
                        log(
                          "Order is placed: "
                          "$subtotal | "
                          "Payment: "
                          "$selectedPayment | "
                          "Delivery: "
                          "$deliveryway",
                        );
                        context.read<CartCubit>().clearCart();
                      },
                    );
                  },
                ),
                SizedBox(height: 30.h),
              ],
            );
          },
        ),
      ),
    );
  }
}
