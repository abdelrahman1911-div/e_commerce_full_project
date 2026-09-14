import 'package:e_commerce_full_project/core/widgets/Text_btton_widget.dart';
import 'package:e_commerce_full_project/core/widgets/rich_text_Text_span_widget.dart';
import 'package:e_commerce_full_project/core/widgets/welcome_header_widget_icon.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/core/widgets/couustom_text_field_widget.dart';
import 'package:e_commerce_full_project/core/widgets/custom_button.dart';
import 'package:e_commerce_full_project/core/widgets/custom_or_login_widget.dart';
import 'package:e_commerce_full_project/core/widgets/social_buttons_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late TapGestureRecognizer _registerTapRecognizer;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _registerTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        context.push(AppRoutes.register);
      };
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _registerTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          print('LOGIN STATE: $state');
          if (state is AuthSuccess) {
            print('AUTH SUCCESS - GOING HOME');
          }
          if (state is AuthError) {
            print('AUTH ERROR: ${state.message}');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WelcomeHeaderWidgetIcon(),
                    SizedBox(height: 20.h),
                    CustomTextFieldWidget(
                      label: "email".tr(),
                      controller: emailController,
                      hintText: "email_hint".tr(),

                      icon: Icon(
                        Icons.mail_outline,
                        color: colorScheme.onSurfaceVariant,
                        size: 20.sp,
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please_enter_email'.tr();
                        }

                        if (!value.contains('@')) {
                          return 'enter_valid_email'.tr();
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    CustomTextFieldWidget(
                      label: 'password'.tr(),
                      hintText: 'enter_your_password'.tr(),
                      controller: passwordController,
                      isPassword: true,
                      icon: Icon(
                        Icons.lock_outline,
                        color: colorScheme.onSurfaceVariant,
                        size: 20.sp,
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
                    TextBttonWidget(),
                    SizedBox(height: 10.h),
                    CustomButton(
                      buttonText: "login".tr(),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        context.read<AuthCubit>().login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: colorScheme.onPrimary,
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    const CustomOrLoginWidget(),
                    SizedBox(height: 15.h),
                    const CustomSocialLoginIcons(),
                    SizedBox(height: 15.h),
                    RichTextTextSpanWidget(
                      richText: "dont_have_account".tr(),
                      clickableText: "sign_up".tr(),
                      recognizer: _registerTapRecognizer,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
