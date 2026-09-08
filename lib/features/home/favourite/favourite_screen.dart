import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:e_commerce_full_project/core/widgets/List_view_widget.dart';
import 'package:e_commerce_full_project/core/widgets/No_items_widget.dart';
import 'package:e_commerce_full_project/features/home/homescreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e_commerce_full_project/features/home/favourite/cubit/favourite_cubit.dart'
    show FavouriteCubit, FavouriteInitial, FavouriteLoaded, FavouriteState;
import 'package:e_commerce_full_project/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
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
        appBar: AppBar(
          title: Text('favourites'.tr(), style: AppTextStyles.title(context)),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: BlocBuilder<FavouriteCubit, FavouriteState>(
            builder: (context, state) {
              if (state is FavouriteInitial) {
                return NoItemsWidget(
                  mainText: "no_favourites_yet".tr(),
                  icon: Icons.favorite,
                );
              }
              if (state is FavouriteLoaded) {
                final favourites = state.favourites;
                if (favourites.isEmpty) {
                  return NoItemsWidget(
                    mainText: "no_favourites_yet".tr(),
                    icon: Icons.favorite,
                  );
                }
                return CustomListView(
                  Scroll: Axis.vertical,
                  items: favourites,
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemBuilder: (context, item, index) {
                    final item = favourites[index];
                    return ProductCardWidget(product: item);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
