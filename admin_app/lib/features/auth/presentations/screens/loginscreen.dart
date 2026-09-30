import 'package:e_commerce_admin/core/router/app_routes.dart';
import 'package:e_commerce_admin/core/widgets/Text_btton_widget.dart';
import 'package:e_commerce_admin/core/widgets/couustom_text_field_widget.dart';
import 'package:e_commerce_admin/core/widgets/custom_button.dart';
import 'package:e_commerce_admin/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_admin/features/auth/presentations/cubit/auth_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),

              child: Form(
                key: formKey,

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Admin Login',
                      style: theme
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight:
                                FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Sign in to access the admin dashboard.',
                      style: theme
                          .textTheme
                          .bodyMedium,
                    ),

                    const SizedBox(height: 32),

                    CustomTextField(
                      controller: emailController,
                      label: 'Email',
                      hintText: 'Enter admin email',
                      icon: Icons.email_outlined,
                      keyboardType:
                          TextInputType.emailAddress,

                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter your email';
                        }

                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    CustomTextField(
                      controller: passwordController,
                      label: 'Password',
                      hintText: 'Enter your password',
                      icon: Icons.lock_outline,
                      isPassword: true,

                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Please enter your password';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    const ForgotPasswordButton(),

                    const SizedBox(height: 24),

                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading =
                            state is AuthLoading;

                        return CustomButton(
                          buttonText: 'Login',

                          isLoading: isLoading,

                          icon: Icons.arrow_forward,

                          onPressed: () {
                            if (!formKey.currentState!
                                .validate()) {
                              return;
                            }

                            context
                                .read<AuthCubit>()
                                .login(
                                  emailController.text
                                      .trim(),
                                  passwordController
                                      .text,
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
      ),
    );
  }
}