import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/core/widgets/couustom_text_field_widget.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:e_commerce_full_project/core/theme/themeController.dart';
import 'package:e_commerce_full_project/features/search/presentation/cubit/search_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AppBarProdHome extends StatefulWidget implements PreferredSizeWidget {
  final bool isHome;
  final ProductModel? prod; 
  final bool? isProf ; 
  TextEditingController? sear;
  AppBarProdHome({super.key,this.isProf,required this.isHome, this.prod, this.sear});

  @override
  State<AppBarProdHome> createState() => _AppBarProdHomeState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarProdHomeState extends State<AppBarProdHome> {
  @override
  Widget build(BuildContext context) {
    return widget.isProf! ? 
        AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'profile'.tr(),
            style: TextStyle(
              fontSize: 20.sp,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8.0.w, left: 8.0.w),
              child: Container(
                width: 35.w,
                height: 30.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 0.5.w,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.only(right: 2.w, left: 3.w),
                  ),
                  onPressed: () {
                    ThemeController.toggleTheme();
                  },
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ),
          ],
        ) 
     :
     AppBar(
      backgroundColor: widget.isHome
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.surface,

      elevation: 8,

      centerTitle: true,

      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: widget.isHome == false ? true : false,
      scrolledUnderElevation: 8,

      title: widget.isHome
          ? CustomTextFieldWidget(
              isSearchTextField: true,
              controller: widget.sear!,
              hintText: 'search'.tr(),
              icon: const Icon(Icons.search_outlined), 
              onChanged:(value) {
                context.read<SearchCubit>().search(value); 
              } ,
            )
          : Text(widget.prod?.name ?? '', style: AppTextStyles.title(context)),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: InkWell(
            onTap: () {
              context.go(AppRoutes.cart);
            },
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
