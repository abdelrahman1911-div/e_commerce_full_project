import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/pay_pref_states.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/payment_preference_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ChoosePayment extends StatefulWidget {
  final VoidCallback onChangePayment;
  const ChoosePayment({required this.onChangePayment, super.key});
  @override
  State<ChoosePayment> createState() => _ChoosePaymentState();
}

class _ChoosePaymentState extends State<ChoosePayment> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedBorderColor = isDark ? Colors.white : Colors.black;
    final unselectedBorderColor = isDark
        ? Colors.grey.shade700
        : Colors.grey.shade300;
    final cardColor = isDark ? theme.cardColor : Colors.white;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('payment'.tr(), style: theme.textTheme.titleMedium),
            TextButton(
              onPressed: widget.onChangePayment,
              child: Text(
                'change'.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        BlocBuilder<PaymentPreferenceCubit, PaymentPreferenceState>(
          builder: (context, paymentState) {
            String selectedPayment = 'cash';
            if (paymentState is PaymentPreferenceSuccess) {
              selectedPayment = paymentState.selectedPayment;
            }
            return Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () {
                    context.read<PaymentPreferenceCubit>().selectPayment(
                      'card',
                    );
                  },
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: selectedPayment == "card"
                            ? selectedBorderColor
                            : unselectedBorderColor,

                        width: selectedPayment == "card" ? 2 : 1,
                      ),
                    ),

                    child: Row(
                      children: [
                        SizedBox(width: 10.w),

                        Container(
                          height: 35.h,
                          width: 60.w,

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(10.r),
                          ),

                          child: SvgPicture.asset("assets/master-svg.svg"),
                        ),

                        SizedBox(width: 15.w),

                        Text(
                          "*************397",

                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Radio<String>(
                          value: "card",
                          groupValue: selectedPayment,
                          activeColor: selectedBorderColor,
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            context
                                .read<PaymentPreferenceCubit>()
                                .selectPayment(value);
                          },
                        ),
                        SizedBox(width: 5.w),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () {
                    context.read<PaymentPreferenceCubit>().selectPayment(
                      'cash',
                    );
                  },
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor,

                      borderRadius: BorderRadius.circular(16.r),

                      border: Border.all(
                        color: selectedPayment == "cash"
                            ? selectedBorderColor
                            : unselectedBorderColor,

                        width: selectedPayment == "cash" ? 2 : 1,
                      ),
                    ),

                    child: Row(
                      children: [
                        SizedBox(width: 10.w),

                        Container(
                          height: 35.h,
                          width: 60.w,

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(10.r),
                          ),

                          child: SvgPicture.asset("assets/dollar-icon.svg"),
                        ),

                        SizedBox(width: 15.w),

                        Text(
                          'cash_on_delivery'.tr(),

                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),

                        const Spacer(),

                        Radio<String>(
                          value: "cash",

                          groupValue: selectedPayment,

                          activeColor: selectedBorderColor,

                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }

                            context
                                .read<PaymentPreferenceCubit>()
                                .selectPayment(value);
                          },
                        ),

                        SizedBox(width: 5.w),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
