import 'package:easy_localization/easy_localization.dart';
import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/core/widgets/couustom_text_field_widget.dart';
import 'package:e_commerce_full_project/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends StatefulWidget {
  final bool isForgotPassword;

  const ChangePasswordScreen({super.key, this.isForgotPassword = false});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Controllers
  final TextEditingController oldpass = TextEditingController();

  final TextEditingController newpass = TextEditingController();

  final TextEditingController newpassVerified = TextEditingController();

  // Error messages
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

    if (!widget.isForgotPassword && oldpass.text.trim().isEmpty) {
      setState(() {
        oldPasswordError = 'please_enter_current_password'.tr();
      });
    }
    if (newpass.text.trim().isEmpty) {
      setState(() {
        newPasswordError = 'please_enter_new_password'.tr();
      });
    } else if (newpass.text.length < 8) {
      setState(() {
        newPasswordError = 'password_min_eight'.tr();
      });
    } else if (!RegExp(r'[A-Z]').hasMatch(newpass.text)) {
      setState(() {
        newPasswordError = 'password_uppercase'.tr();
      });
    } else if (!RegExp(r'[0-9]').hasMatch(newpass.text)) {
      setState(() {
        newPasswordError = 'password_number'.tr();
      });
    }

    if (newpassVerified.text.trim().isEmpty) {
      setState(() {
        verifyPasswordError = 'please_verify_new_password'.tr();
      });
    } else if (newpassVerified.text != newpass.text) {
      setState(() {
        verifyPasswordError = 'passwords_do_not_match'.tr();
      });
    }
    if (oldPasswordError.isNotEmpty ||
        newPasswordError.isNotEmpty ||
        verifyPasswordError.isNotEmpty) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isForgotPassword
              ? 'password_reset_successfully'.tr()
              : 'password_changed_successfully'.tr(),
        ),
      ),
    );
    if (widget.isForgotPassword) {
      context.go(AppRoutes.login);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: _validateAndSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
