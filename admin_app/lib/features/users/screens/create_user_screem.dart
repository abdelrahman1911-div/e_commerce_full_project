import 'package:e_commerce_admin/core/di/injection_container.dart';
import 'package:e_commerce_admin/core/widgets/couustom_text_field_widget.dart';
import 'package:e_commerce_admin/features/users/cubit/user_cubit.dart';
import 'package:e_commerce_admin/features/users/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});
  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'user';
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: usersCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create User',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<UsersCubit, UsersState>(
          listener: (context, state) {
            if (state is UsersSuccess) {
              Navigator.pop(context);
            }

            if (state is UsersError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isCreating = state is UsersCreating;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Create New User',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Create New Account.',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 30),
                            CustomTextField(
                              controller: _nameController,
                              hintText: 'Enter full name',
                              label: 'Full Name',
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: _emailController,
                              hintText: 'Enter email address',
                              label: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter email';
                                }
                                final email = value.trim();
                                if (!email.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: _phoneController,
                              hintText: 'Enter phone number',
                              label: 'Phone Number',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter phone number';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: _passwordController,
                              hintText: 'Enter password',
                              label: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }

                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              value: _selectedRole,
                              decoration: const InputDecoration(
                                labelText: 'Role',
                                prefixIcon: Icon(
                                  Icons.admin_panel_settings_outlined,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'user',
                                  child: Text('User'),
                                ),
                                DropdownMenuItem(
                                  value: 'admin',
                                  child: Text('Admin'),
                                ),
                                DropdownMenuItem(
                                  value: 'driver',
                                  child: Text('Driver'),
                                ),
                              ],
                              onChanged: isCreating
                                  ? null
                                  : (value) {
                                      if (value == null) {
                                        return;
                                      }

                                      setState(() {
                                        _selectedRole = value;
                                      });
                                    },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: isCreating ? null : _createUser,
                                child: isCreating
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Create User'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await context.read<UsersCubit>().createUser(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole,
    );
  }
}
