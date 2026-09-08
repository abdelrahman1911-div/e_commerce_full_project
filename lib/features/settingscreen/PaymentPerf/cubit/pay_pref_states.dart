import 'package:equatable/equatable.dart';

abstract class PaymentPreferenceState extends Equatable {
  const PaymentPreferenceState();

  @override
  List<Object?> get props => [];
}


class PaymentPreferenceInitial extends PaymentPreferenceState {}


class PaymentPreferenceLoading extends PaymentPreferenceState {}


class PaymentPreferenceSuccess extends PaymentPreferenceState {
  final String selectedPayment;

  const PaymentPreferenceSuccess({
    required this.selectedPayment,
  });

  @override
  List<Object?> get props => [selectedPayment];
}


class PaymentPreferenceError extends PaymentPreferenceState {
  final String message;

  const PaymentPreferenceError(this.message);

  @override
  List<Object?> get props => [message];
}