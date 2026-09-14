import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_state.dart';
import 'package:e_commerce_full_project/features/home/profile/data/models/user_model.dart';
import 'package:e_commerce_full_project/features/home/profile/presentation/cubit/user_cubit.dart';
import 'package:e_commerce_full_project/features/home/profile/presentation/cubit/user_state.dart';
import 'package:e_commerce_full_project/features/settingscreen/personalinfo/widgets/Editable_field.dart';
import 'package:e_commerce_full_project/features/settingscreen/personalinfo/widgets/edit_save_button.dart';
import 'package:e_commerce_full_project/features/settingscreen/personalinfo/widgets/image_and_name_widget.dart';
import 'package:e_commerce_full_project/features/settingscreen/personalinfo/widgets/info_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});
  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  bool isEditing = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void changeEditing() {
    setState(() {
      isEditing = true;
    });
  }

  void _saveInformation() async {
    final state = context.read<UserCubit>().state;
    if (state is! UserLoaded && state is! UserUpdated) {
      return;
    }
    final currentUser = state is UserLoaded
        ? state.user
        : (state as UserUpdated).user;
    FocusScope.of(context).unfocus();
    final updatedUser = currentUser.copyWith(
      email: emailController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      address: addressController.text.trim(),
    );
    await context.read<UserCubit>().updateUser(updatedUser);
    if (!mounted) return;
    setState(() {
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('personal_information.updated_successfully'.tr())),
    );
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthSuccess) {
        context.read<UserCubit>().getUser(authState.user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('personal_information.title'.tr())),
      body: SingleChildScrollView(
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserUpdated) {
              emailController.text = state.user.email;
              phoneController.text = state.user.phoneNumber;
              addressController.text = state.user.address;
            }

            if (state is UserError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserError) {
              return Center(child: Text(state.message));
            }
            UserModel? user;
            if (state is UserLoaded) {
              user = state.user;
            }
            if (state is UserUpdating) {
              user = state.user;
            }
            if (state is UserUpdated) {
              user = state.user;
            }
            if (user == null) {
              return const SizedBox();
            }
            if (emailController.text.isEmpty) {
              emailController.text = user.email;
            }
            if (phoneController.text.isEmpty) {
              phoneController.text = user.phoneNumber;
            }
            if (addressController.text.isEmpty) {
              addressController.text = user.address;
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  ImageAndNameWidget(
                    image: user.photoUrl,
                    prName: user.displayname,
                  ),
                  if (isEditing) ...[
                    EditableField(
                      controller: emailController,
                      icon: Icons.email_outlined,
                      label: 'personal_information.email'.tr(),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    EditableField(
                      controller: phoneController,
                      icon: Icons.phone_outlined,
                      label: 'personal_information.phone_number'.tr(),
                      keyboardType: TextInputType.phone,
                    ),
                    EditableField(
                      controller: addressController,
                      icon: Icons.location_on_outlined,
                      label: 'personal_information.address'.tr(),
                      keyboardType: TextInputType.streetAddress,
                    ),
                    const SizedBox(height: 10),
                    EditSaveButton(
                      textForButton: 'personal_information.save_changes'.tr(),
                      onPressed: _saveInformation,
                    ),
                  ] else ...[
                    InfoTile(
                      icon: Icons.email_outlined,
                      title: 'personal_information.email'.tr(),
                      value: emailController.text,
                    ),
                    InfoTile(
                      icon: Icons.phone_outlined,
                      title: 'personal_information.phone_number'.tr(),
                      value: user.phoneNumber,
                    ),
                    InfoTile(
                      icon: Icons.location_on_outlined,
                      title: 'personal_information.address'.tr(),
                      value: addressController.text,
                    ),
                    SizedBox(height: 10),
                    EditSaveButton(
                      textForButton: 'personal_information.edit_information'
                          .tr(),
                      onPressed: changeEditing,
                    ),
                    SizedBox(height: 10.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Security',
                          style: AppTextStyles.subheadline(context),
                        ),
                        const SizedBox(height: 10),
                        // Change Password
                        if (getSignInMethod() == 'Email & Password')
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.lock_outline),
                            title: const Text('Change Password'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              context.push(AppRoutes.changepass);
                            },
                          ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.login_outlined),
                          title: const Text('Sign-in Method'),
                          trailing: Text(getSignInMethod()),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.calendar_today_outlined),
                          title: const Text('Member Since'),
                          trailing: Text(formatMemberSince(user.createdAt)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

String formatMemberSince(DateTime? date) {
  if (date == null) {
    return '-';
  }

  return DateFormat('MMMM yyyy').format(date);
}

String getSignInMethod() {
  final providers = FirebaseAuth.instance.currentUser?.providerData ?? [];

  if (providers.any((provider) => provider.providerId == 'google.com')) {
    return 'Google';
  }

  if (providers.any((provider) => provider.providerId == 'facebook.com')) {
    return 'Facebook';
  }

  if (providers.any((provider) => provider.providerId == 'apple.com')) {
    return 'Apple';
  }

  if (providers.any((provider) => provider.providerId == 'password')) {
    return 'Email & Password';
  }

  return 'Unknown';
}
