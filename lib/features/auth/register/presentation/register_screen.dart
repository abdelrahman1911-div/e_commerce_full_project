import 'package:e_commerce_full_project/core/widgets/rich_text_Text_span_widget.dart';
import 'package:e_commerce_full_project/core/widgets/welcome_header_widget_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/core/widgets/couustom_text_field_widget.dart';
import 'package:e_commerce_full_project/core/widgets/custom_button.dart';
import 'package:e_commerce_full_project/core/widgets/custom_or_login_widget.dart';
import 'package:e_commerce_full_project/core/widgets/social_buttons_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? _confirmPasswordError;
  @override
  void initState() {
    super.initState();
    passwordController.addListener(_validateConfirmPassword);
    confirmPasswordController.addListener(_validateConfirmPassword);
  }
  void _validateConfirmPassword() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    if (!mounted) return;
    setState(() {
      if (confirmPassword.isEmpty) {
        _confirmPasswordError = null;
      } else if (password != confirmPassword) {
        _confirmPasswordError = "passwords_do_not_match".tr();
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  @override
  void dispose() {
    passwordController.removeListener(_validateConfirmPassword);
    confirmPasswordController.removeListener(_validateConfirmPassword);
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeHeaderWidgetIcon(
                    headTitle: "create_account".tr(),
                    subTitle: "register_subtitle".tr(),
                  ),
                  SizedBox(height: 28.h),
                  CustomTextFieldWidget(
                    label: "your_name".tr(),
                    hintText: "your_full_name".tr(),
                    controller: nameController,
                    icon: Icon(
                      Icons.person_outline,
                      color: theme.iconTheme.color,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFieldWidget(
                    label: "email".tr(),
                    hintText: "email_hint".tr(),
                    controller: emailController,
                    icon: Icon(
                      Icons.mail_outline,
                      color: theme.iconTheme.color,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_email'.tr();
                      }
                      if (!value.contains("@")) {
                        return 'enter_valid_email'.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFieldWidget(
                    label: "password".tr(),
                    hintText: "enter_your_password".tr(),
                    controller: passwordController,
                    isPassword: true,
                    icon: Icon(
                      Icons.lock_outline,
                      color: theme.iconTheme.color,
                      size: 20,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_password'.tr();
                      }
                      if (value.length < 6) {
                        return 'password_min_length'.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFieldWidget(
                    label: "confirm_password".tr(),
                    hintText: "re_enter_password".tr(),
                    controller: confirmPasswordController,
                    isPassword: true,
                    errorText: _confirmPasswordError,
                    icon: Icon(
                      Icons.lock_outline,
                      color: theme.iconTheme.color,
                      size: 20,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_confirm_password'.tr();
                      }
                      if (value != passwordController.text) {
                        return 'passwords_do_not_match'.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  RichTextTextSpanWidget(
                    richText: "terms_conditions".tr(),
                    clickableText: "terms_of_services_and_conditions".tr(),
                  ),
                  SizedBox(height: 15.h),
                  CustomButton(
                    buttonText: "create_an_account".tr(),
                    icon: Icon(
                      Icons.arrow_forward,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  const CustomOrLoginWidget(),
                  SizedBox(height: 15.h),
                  const CustomSocialLoginIcons(),
                  SizedBox(height: 15.h),
                  RichTextTextSpanWidget(
                    richText: "already_have_account".tr(),
                    clickableText: "login".tr(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.pushReplacement(AppRoutes.login);
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
