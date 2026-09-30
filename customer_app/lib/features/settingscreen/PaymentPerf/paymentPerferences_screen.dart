import 'package:e_commerce_full_project/core/errors/widget/user_error_overlay.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/pay_pref_states.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/payment_preference_services.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/widgets/payment_preference_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentPreferenceScreen extends StatelessWidget {
  const PaymentPreferenceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const _PaymentPreferenceView();
  }
}

class _PaymentPreferenceView extends StatelessWidget {
  const _PaymentPreferenceView();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentPreferenceCubit, PaymentPreferenceState>(
      listener: (context, state) {
        if (state is PaymentPreferenceError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is PaymentPreferenceInitial ||
            state is PaymentPreferenceLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is PaymentPreferenceError) {
          return Scaffold(
            appBar: AppBar(title: Text('payment_preference.title'.tr())),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<PaymentPreferenceCubit>().loadPaymentMethod(); 
               
                },
                child: const Text('Retry'),
              ),
            ),
          );
        }
        if (state is PaymentPreferenceSuccess) {
          return PaymentPreferenceContent(
            selectedPayment: state.selectedPayment,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
