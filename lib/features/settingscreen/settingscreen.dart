import 'package:e_commerce_full_project/core/errors/widget/user_error_overlay.dart';
import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/core/widgets/custom_button.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_full_project/features/settingscreen/widgets/bulild_settings_section.dart';
import 'package:e_commerce_full_project/features/settingscreen/widgets/changing_theme_widget.dart';
import 'package:e_commerce_full_project/features/settingscreen/widgets/settings_tile.dart';
import 'package:e_commerce_full_project/core/theme/themeController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        elevation: 0,
      ),

      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),

        children: [
          BulildSettingsSection(
            title: 'account'.tr(),
            firstSettingsTileTitle: 'personal_information'.tr(),
            firstSettingsTileSubtitle: 'manage_personal_details'.tr(),
            firstIconTile: Icons.person_outline,
            onTapfirst: () {
              context.push(AppRoutes.personalInformation);
            },
            secondIconTile: Icons.location_on_outlined,
            secondSettingsTileTitle: 'addresses'.tr(),
            secondSettingsTileSubtitle: 'manage_delivery_addresses'.tr(),
            onTapSecond: () {
              context.push(AppRoutes.AddressScreen);
            },
            thirdIconTile: Icons.lock_outline,
            thirdSettingsTileTitle: 'change_password'.tr(),
            thirdSettingsTileSubtitle: 'update_account_password'.tr(),
            onTapThird: () {
              context.push(AppRoutes.changepass);
            },
          ),
          _buildSectionTitle(context, 'preferences'.tr()),
          ChangingThemeWidget(
            valueToChange: notificationsEnabled,
            isTheme: false,
            title: 'notifications'.tr(),
            subtitle: notificationsEnabled
                ? 'notifications_enabled'.tr()
                : 'notifications_disabled'.tr(),
          ),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.themeMode,
            builder: (context, themeMode, _) {
              final darkModeEnabled = themeMode == ThemeMode.dark;
              return ChangingThemeWidget(
                valueToChange: darkModeEnabled,
                isTheme: true,
              );
            },
          ),
          SettingsTile(
            icon: Icons.language_outlined,
            title: 'language'.tr(),
            subtitle: selectedLanguage,
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          SizedBox(height: 18.h),
          BulildSettingsSection(
            title: 'support'.tr(),
            firstSettingsTileTitle: 'help_center'.tr(),
            firstSettingsTileSubtitle: 'find_answers'.tr(),
            firstIconTile: Icons.help_outline,
            onTapfirst: () {},
            secondSettingsTileTitle: 'contact_us'.tr(),
            secondSettingsTileSubtitle: 'we_are_here_to_help'.tr(),
            secondIconTile: Icons.headset_mic_outlined,
            onTapSecond: () {},
            thirdSettingsTileTitle: 'report_problem'.tr(),
            thirdSettingsTileSubtitle: 'tell_us_problem'.tr(),
            thirdIconTile: Icons.report_problem_outlined,
            onTapThird: () {},
          ),
          // ================= ABOUT =================
          BulildSettingsSection(
            title: 'about'.tr(),
            firstSettingsTileTitle: 'about_us'.tr(),
            firstSettingsTileSubtitle: 'learn_about_store'.tr(),
            firstIconTile: Icons.info_outline,
            onTapfirst: () {},
            secondSettingsTileTitle: 'privacy_policy'.tr(),
            secondSettingsTileSubtitle: 'read_privacy'.tr(),
            secondIconTile: Icons.privacy_tip_outlined,
            onTapSecond: () {},
            thirdSettingsTileTitle: 'terms_conditions'.tr(),
            thirdSettingsTileSubtitle: 'read_terms'.tr(),
            thirdIconTile: Icons.description_outlined,
            onTapThird: () {},
          ),
          CustomButton(
            buttonText: "Log out",
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
          SizedBox(height: 25.h),
          Center(
            child: Text(
              'version'.tr(args: ['1.0.0']),
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    String temporaryLanguage = selectedLanguage;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('choose_language'.tr()),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    value: 'English',
                    groupValue: temporaryLanguage,

                    title: Text('english'.tr()),

                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setDialogState(() {
                        temporaryLanguage = value;
                      });
                    },
                  ),

                  RadioListTile<String>(
                    value: 'Arabic',
                    groupValue: temporaryLanguage,

                    title: Text('arabic'.tr()),

                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setDialogState(() {
                        temporaryLanguage = value;
                      });
                    },
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },

                  child: Text('cancel'.tr()),
                ),

                TextButton(
                  onPressed: () async {
                    setState(() {
                      selectedLanguage = temporaryLanguage;
                    });

                    if (temporaryLanguage == 'Arabic') {
                      await context.setLocale(const Locale('ar'));
                    } else {
                      await context.setLocale(const Locale('en'));
                    }
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pop(dialogContext);
                    UserErrorOverlay.show(
                      context,
                      message: 'language_changed'.tr(args: [temporaryLanguage]),
                      isSuccess: true,
                    );
                  },
                  child: Text('save'.tr()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('logout_question'.tr()),
          content: Text('logout_confirmation'.tr()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                UserErrorOverlay.show(
                  context,
                  isSuccess: true,
                  message: 'logged_out_successfully'.tr(),
                  barrierDismissible: false,
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                  },
                );
              },
              child: Text(
                'logout'.tr(),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
