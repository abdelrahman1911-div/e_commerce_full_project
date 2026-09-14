import 'package:e_commerce_full_project/core/widgets/app_bar_prod_home.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_state.dart';
import 'package:e_commerce_full_project/features/home/homescreen.dart';
import 'package:e_commerce_full_project/features/home/profile/presentation/cubit/user_cubit.dart';
import 'package:e_commerce_full_project/features/home/profile/presentation/cubit/user_state.dart';
import 'package:e_commerce_full_project/features/home/profile/presentation/widgets/personal_info_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/myorders_screen.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/paymentPerferences_screen.dart';
import 'package:e_commerce_full_project/features/home/profile/presentation/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> { 
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      },
      child: Scaffold(
        appBar: AppBarProdHome(isHome: false, isProf: true),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                                   if (state is UserLoaded ||
                       state is UserUpdated ||
                       state is UserUpdating) {
                     final user = state is UserLoaded
                         ? state.user
                         : state is UserUpdated
                             ? state.user
                             : (state as UserUpdating).user;
                     debugPrint('PROFILE NAME = ${user.displayname}');
                     debugPrint('PROFILE PHOTO = ${user.photoUrl}');
                     return PersonalInfoWidget(
                       personal_name: user.displayname,
                       person_image: user.photoUrl,
                     );
                   }
                   if (state is UserLoading) {
                     return const Center(
                       child: CircularProgressIndicator(),
                     );
                   }
                      return const SizedBox();
                    },
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SettingsCard(
                          onTap: () {
                            context.push(AppRoutes.personalInformation);
                          },
                          icon: Icon(
                            Icons.account_circle_outlined,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          title: 'personal_information'.tr(),
                        ),
                        SettingsCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPreferenceScreen(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.credit_card,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          title: 'payment_preferences'.tr(),
                        ),
                        SettingsCard(
                          icon: Icon(
                            Icons.favorite_outline,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          title: 'favorites'.tr(),
                          onTap: () {
                            context.push(AppRoutes.favourites);
                          },
                        ),
                        SettingsCard(
                          icon: Icon(
                            Icons.shopping_bag_outlined,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          title: 'my_cart'.tr(),
                          onTap: () {
                            context.push(AppRoutes.cart);
                          },
                        ),
                        SettingsCard(
                          onTap: () {
                            context.push(AppRoutes.AddressScreen);
                          },
                          icon: Icon(
                            Icons.location_on_outlined,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          title: 'address'.tr(),
                        ),
                        SettingsCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyOrdersScreen(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.motorcycle_outlined,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          title: 'my_orders'.tr(),
                        ),
                        SettingsCard(
                          icon: Icon(
                            Icons.settings,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          title: 'settings'.tr(),
                          onTap: () {
                            context.push(AppRoutes.settingScreen);
                          },
                        ),
                      ],
                    ),
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
