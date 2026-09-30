import 'package:easy_localization/easy_localization.dart';
import 'package:e_commerce_full_project/core/errors/widget/user_error_overlay.dart';
import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/core/widgets/couustom_text_field_widget.dart';
import 'package:e_commerce_full_project/core/widgets/custom_button.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends StatefulWidget {
  final bool isForgotPassword;

  const ChangePasswordScreen({
    super.key,
    this.isForgotPassword = false,
  });

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldpass = TextEditingController();
  final TextEditingController newpass = TextEditingController();
  final TextEditingController newpassVerified = TextEditingController();

  String oldPasswordError = '';
  String newPasswordError = '';
  String verifyPasswordError = '';

  @override
  void dispose() {
    oldpass.dispose();
    newpass.dispose();
    newpassVerified.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    setState(() {
      oldPasswordError = '';
      newPasswordError = '';
      verifyPasswordError = '';
    });

    bool hasError = false;

    if (!widget.isForgotPassword && oldpass.text.trim().isEmpty) {
      oldPasswordError = 'please_enter_current_password'.tr();
      hasError = true;
    }

    if (newpass.text.trim().isEmpty) {
      newPasswordError = 'please_enter_new_password'.tr();
      hasError = true;
    } else if (newpass.text.length < 8) {
      newPasswordError = 'password_min_eight'.tr();
      hasError = true;
    } else if (!RegExp(r'[A-Z]').hasMatch(newpass.text)) {
      newPasswordError = 'password_uppercase'.tr();
      hasError = true;
    } else if (!RegExp(r'[0-9]').hasMatch(newpass.text)) {
      newPasswordError = 'password_number'.tr();
      hasError = true;
    }

    if (newpassVerified.text.trim().isEmpty) {
      verifyPasswordError = 'please_verify_new_password'.tr();
      hasError = true;
    } else if (newpassVerified.text != newpass.text) {
      verifyPasswordError = 'passwords_do_not_match'.tr();
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    if (widget.isForgotPassword) {
      context.go(AppRoutes.login);
      return;
    }

    context.read<AuthCubit>().changePassword(
          oldPassword: oldpass.text.trim(),
          newPassword: newpass.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthUnauthenticated) {
          UserErrorOverlay.show(
            context,
            message: 'password_changed_successfully'.tr(),
            isSuccess: true,
          );

          await Future.delayed(
            const Duration(milliseconds: 1500),
          );

          if (!mounted) return;

          context.go(AppRoutes.login);
        }

        if (state is AuthError) {
          UserErrorOverlay.show(
            context,
            message: state.message.tr(),
            isSuccess: false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.isForgotPassword
                  ? 'reset_password'.tr()
                  : 'change_password'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  if (!widget.isForgotPassword) ...[
                    CustomTextFieldWidget(
                      label: 'current_password'.tr(),
                      controller: oldpass,
                      hintText: 'current_password_hint'.tr(),
                      isPassword: true,
                      errorText: oldPasswordError,
                    ),
                    SizedBox(height: 20.h),
                  ],
                  CustomTextFieldWidget(
                    label: 'new_password'.tr(),
                    controller: newpass,
                    hintText: 'new_password_hint'.tr(),
                    isPassword: true,
                    errorText: newPasswordError,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFieldWidget(
                    label: 'verify_new_password'.tr(),
                    controller: newpassVerified,
                    hintText: 'verify_new_password_hint'.tr(),
                    isPassword: true,
                    errorText: verifyPasswordError,
                  ),
                  SizedBox(height: 30.h),
                  CustomButton(
                    buttonText: widget.isForgotPassword
                        ? 'reset_password'.tr()
                        : 'change_password'.tr(),
                    onPressed: isLoading ? null : _validateAndSubmit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}