import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/features/home/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController addressController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  bool isLoadingUserData = true;

  bool isadressEditing = false;
  bool isPhoneEditing = false;
  bool isNameEditing = false;

  final orderId = DateTime.now().millisecondsSinceEpoch.toString();

  String deliveryway = "";

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        log('No authenticated user found.');
        return;
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        log('User document does not exist.');
        return;
      }

      final data = userDoc.data();

      if (data == null) {
        log('User data is null.');
        return;
      }

      final String name = data['name']?.toString() ?? '';

      final String phone = data['phone']?.toString() ?? '';

      final String address = data['address']?.toString() ?? '';

      if (!mounted) return;
      setState(() {
        nameController.text = name;
        phoneController.text = phone;
        addressController.text = address;

        isLoadingUserData = false;
      });

      log('User checkout data loaded successfully.');
      log('Name: $name');
      log('Phone: $phone');
      log('Address: $address');
    } catch (e, stackTrace) {
      log(
        'Failed to load user checkout data',
        error: e,
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        isLoadingUserData = false;
      });
    }
  }

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
  void initState() {
    super.initState();

    _loadUserData();
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
        child: isLoadingUserData
            ? const Center(child: CircularProgressIndicator())
            : BlocBuilder<CartCubit, CartState>(
                builder: (context, cartState) {
                  if (cartState is CartInitial || cartState is CartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (cartState is CartError) {
                    return Center(
                      child: Text(
                        cartState.message,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (cartState is CartLoaded) {
                    final List<CartItemModel> cartItems = cartState.items;
                    if (cartItems.isEmpty) {
                      return NoItemsWidget(mainText: 'your_cart_is_empty'.tr());
                    }
                    double total = 0;
                    for (final cartItem in cartItems) {
                      final price = cartItem.product.currentPrice;
                      final quantity = cartItem.quantity;
                      total += price * quantity;
                    }
                    final subtotal = total + delivery;
                    return ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      children: [
                        ...cartItems.map(
                          (cartItem) => CartItemWidget(carti: cartItem),
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
                          controller: nameController,
                          isPhone: false,
                          isName: true,
                        ),
                        SizedBox(height: 20.h),
                        ChoosePayment(
                          onChangePayment: _changePaymentPreference,
                        ),
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
                        BlocBuilder<
                          PaymentPreferenceCubit,
                          PaymentPreferenceState
                        >(
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
                              onPressed: () async {
                                final paymentState = context
                                    .read<PaymentPreferenceCubit>()
                                    .state;
                                String selectedPayment = 'cash';
                                if (paymentState is PaymentPreferenceSuccess) {
                                  selectedPayment =
                                      paymentState.selectedPayment;
                                }
                                if (deliveryway.isEmpty) {
                                  log("Select delivery way");

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'please_select_payment_and_delivery'
                                            .tr(),
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

                                if (addressController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please select your shipping address.',
                                      ),
                                    ),
                                  );

                                  return;
                                }

                                if (nameController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter your name.'),
                                    ),
                                  );

                                  return;
                                }
                                if (phoneController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter your phone number.',
                                      ),
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
                                  context.push(
                                    AppRoutes.orderScreen,
                                    extra: orderId,
                                  );
                                  await context.read<CartCubit>().clearCart();
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to place order: $e',
                                      ),
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
    ));
  }
}
