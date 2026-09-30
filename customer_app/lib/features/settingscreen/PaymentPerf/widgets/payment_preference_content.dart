import 'package:e_commerce_full_project/core/errors/widget/user_error_overlay.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/pay_pref_states.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/payment_preference_services.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/widgets/payment_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentPreferenceContent extends StatelessWidget {
  final String selectedPayment;

  const PaymentPreferenceContent({
    required this.selectedPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'payment_preference.title'.tr(),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'payment_preference.choose_method'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'payment_preference.description'.tr(),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 25),
            BlocBuilder<PaymentPreferenceCubit, PaymentPreferenceState>(
              builder: (context, state) {
                String currentPayment = selectedPayment;
                if (state is PaymentPreferenceSuccess) {
                  currentPayment = state.selectedPayment;
                }
                return Column(
                  children: [
                    PaymentOption(
                      title: 'payment_preference.card'.tr(),
                      subtitle:
                          'payment_preference.card_subtitle'.tr(),
                      icon: Icons.credit_card_outlined,
                      value: 'card',
                      groupValue: currentPayment,

                      onChanged: (value) {
                        context
                            .read<PaymentPreferenceCubit>()
                            .selectPayment(value);
                      },
                    ),
                    const SizedBox(height: 15),
                    PaymentOption(
                      title:
                          'payment_preference.cash_on_delivery'.tr(),
                      subtitle:
                          'payment_preference.cash_on_delivery_subtitle'
                              .tr(),
                      icon: Icons.money_outlined,
                      value: 'cash',
                      groupValue: currentPayment,

                      onChanged: (value) {
                        context
                            .read<PaymentPreferenceCubit>()
                            .selectPayment(value);
                      },
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () { 
                    UserErrorOverlay.show(
        context,
        message: 'payment_pref_saved'.tr(),
        isSuccess: true,
        onPressed: () {
          Navigator.pop(context);
        },
      );
                },
                child: Text(
                  'payment_preference.save_preference'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}