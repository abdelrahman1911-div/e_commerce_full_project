import 'package:e_commerce_delivery_app/core/widgets/couustom_text_field_widget.dart';
import 'package:e_commerce_delivery_app/core/widgets/custom_button.dart';
import 'package:e_commerce_delivery_app/core/widgets/welcome_header_widget_icon.dart';
import 'package:e_commerce_delivery_app/features/auth/presentation/cubit/cubit/auth_cubit.dart';
import 'package:e_commerce_delivery_app/features/auth/presentation/cubit/cubit/state/auth_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
  });

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeHeaderWidgetIcon(
                    headTitle: 'forgot_password'.tr(),
                    subTitle: 'enter_email_to_reset_password'.tr(),
                  ),
                  SizedBox(height: 32.h),
                  CustomTextField(
                    controller: emailController,
                    label: 'email'.tr(),
                    hintText: 'enter_your_email'.tr(),
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'please_enter_email'.tr();
                      }
                      if (!value.contains('@')) {
                        return 'please_enter_valid_email'.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return CustomButton(
                        buttonText: 'send_reset_email'.tr(),
                        icon: Icons.email_outlined,
                        isLoading: isLoading,
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          context
                              .read<AuthCubit>()
                              .sendPasswordResetEmail(
                                emailController.text.trim(),
                              );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
