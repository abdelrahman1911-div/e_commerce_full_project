import 'package:easy_localization/easy_localization.dart';
import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/core/widgets/couustom_text_field_widget.dart';
import 'package:e_commerce_full_project/core/widgets/custom_button.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  String emailError = '';

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    setState(() {
      emailError = '';
    });

    final email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        emailError = 'please_enter_email'.tr();
      });
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      setState(() {
        emailError = 'please_enter_valid_email'.tr();
      });
      return;
    }
    context.read<AuthCubit>().sendPasswordResetEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('password_reset_email_sent'.tr())),
          );

          context.go(AppRoutes.login);
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'forgot_password'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  Text(
                    'forgot_password'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'forgot_password_description'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFieldWidget(
                    label: 'email'.tr(),
                    controller: emailController,
                    hintText: 'enter_your_email'.tr(),
                    keyboardType: TextInputType.emailAddress,
                    errorText: emailError,
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    buttonText: isLoading
                        ? 'sending'.tr()
                        : 'send_reset_link'.tr(),
                    onPressed: isLoading ? () {} : _validateAndSubmit,
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.go(AppRoutes.login);
                      },
                      child: Text('back_to_login'.tr()),
                    ),
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
