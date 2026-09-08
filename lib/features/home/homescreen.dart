import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/core/widgets/app_bar_prod_home.dart';
import 'package:e_commerce_full_project/core/widgets/header_view_widget.dart';
import 'package:e_commerce_full_project/features/All_categories_brands/all_categorise_screen.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/data/categories_data.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/brand_data.dart';
import 'package:e_commerce_full_project/features/home/customnavbar/customnavbar.dart';
import 'package:e_commerce_full_project/features/home/favourite/favourite_screen.dart';
import 'package:e_commerce_full_project/features/home/mycart/mycart_screen.dart';
import 'package:e_commerce_full_project/features/home/product/product_data.dart';
import 'package:e_commerce_full_project/features/home/profile/profile_screen.dart';
import 'package:e_commerce_full_project/core/widgets/carousel_widget.dart';
import 'package:e_commerce_full_project/core/widgets/product_card.dart';
import 'package:e_commerce_full_project/features/home/widgets/build_Items_list.dart';
import 'package:e_commerce_full_project/features/home/widgets/header_image_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final BrandData brandData = BrandData();
  final CategoriesData catData = CategoriesData();
  final ProductData prodData = ProductData();
  final TextEditingController searchBarController = TextEditingController();
  int _currentIndex = 0;
  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: _currentIndex == 0
          ? AppBarProdHome(
              isHome: true,
              isProf: false,
              sear: SearchController(),
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          const MycartScreen(),
          const FavouriteScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 100.h),
      child: Column(
        children: [
          HeaderImageWidget(),
          SizedBox(height: 8.h),
          HeaderViewWidget(
            Text1: 'shop_by_category'.tr(),
            ButtonText: 'see_all'.tr(),
            isCategories: true,
          ),
          BuildItemsList(isCat: true, catData: catData),
          SizedBox(height: 8.h),
          CarouselWidget(),
          SizedBox(height: 8.h),
          HeaderViewWidget(),
          BuildItemsList(isCat: false, brandData: brandData),
          // buildBrandList(),
          SizedBox(height: 8.h),
          HeaderViewWidget(
            Text1: 'for_your_fashion'.tr(),
            ButtonText: 'see_all'.tr(),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 5.h),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: prodData.productsList.length,
            itemBuilder: (context, index) {
              return ProductCardWidget(product: prodData.productsList[index]);
            },
          ),
        ],
      ),
    );
  }
  // Widget buildBrandList() {
  //   final colorScheme = Theme.of(context).colorScheme;
  //   return SizedBox(
  //     height: 80.h,
  //     child: CustomListView(
  //       Scroll: Axis.horizontal,
  //       items: brandData.brandsList,
  //       itemBuilder: (context, item, index) {
  //         final brand = brandData.brandsList[index];
  //         return ListItemWidget(brand: brand, isCategories: false);
  //       },
  //     ),
  //   );
  // }
}
