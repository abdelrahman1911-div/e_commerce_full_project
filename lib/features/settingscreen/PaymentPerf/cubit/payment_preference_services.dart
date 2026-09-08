import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/pay_pref_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPreferenceCubit extends Cubit<PaymentPreferenceState> {
  PaymentPreferenceCubit()
      : super(
           PaymentPreferenceSuccess(
            selectedPayment: 'cash',
          ),
        );
  static const String paymentKey = 'selected_payment';
  Future<void> loadPaymentMethod() async {
    emit(PaymentPreferenceLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPayment = prefs.getString(paymentKey);
      final payment = savedPayment == 'card' ? 'card' : 'cash';
      emit(
        PaymentPreferenceSuccess(
          selectedPayment: payment,
        ),
      );
    } catch (e) {
      emit(
        const PaymentPreferenceError(
          'Failed to load payment preference',
        ),
      );
    }
  }
  Future<void> changePaymentMethod(String paymentMethod) async {
    try {
      emit(
        PaymentPreferenceSuccess(
          selectedPayment: paymentMethod,
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        paymentKey,
        paymentMethod,
      );
    } catch (e) {
      emit(
        const PaymentPreferenceError(
          'Failed to save payment preference',
        ),
      );
    }
  }
  Future<void> selectPayment(String paymentMethod) async {
    emit(
      PaymentPreferenceSuccess(
        selectedPayment: paymentMethod,
      ),
    );
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        paymentKey,
        paymentMethod,
      );
    } catch (e) {
      emit(
        const PaymentPreferenceError(
          'Failed to save payment preference',
        ),
      );
    }
  }
}