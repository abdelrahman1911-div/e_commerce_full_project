import 'package:e_commerce_full_project/core/widgets/app_bar_prod_home.dart';
import 'package:e_commerce_full_project/features/home/homescreen.dart';
import 'package:e_commerce_full_project/features/home/profile/widgets/personal_info_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/myorders_screen.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/paymentPerferences_screen.dart';
import 'package:e_commerce_full_project/features/home/profile/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                  PersonalInfoWidget(
                    personal_name: "Abdelrahman Tarek",
                    person_image:
                        "https://imgs.search.brave.com/jc74uYRJf9Md1ZIUZzVUjlytO1ssgKsJl5-uZ4AXom8/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9hLmVz/cG5jZG4uY29tL3Bo/b3RvLzIwMjYvMDgz/MC9yMTcwODk2NF8x/Mjk2eDcyOV8xNi05/LmpwZw",
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
