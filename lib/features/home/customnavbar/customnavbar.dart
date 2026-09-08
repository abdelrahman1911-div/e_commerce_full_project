import 'package:e_commerce_full_project/features/home/customnavbar/widgets/custom_nav_bar_item.dart';
import 'package:e_commerce_full_project/features/home/favourite/cubit/favourite_cubit.dart';
import 'package:e_commerce_full_project/features/home/mycart/cubit/mycart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartProducts = context.watch<CartCubit>().state;
    final favouriteState = context.watch<FavouriteCubit>().state;
    final hasFavourites =
        favouriteState is FavouriteLoaded &&
        favouriteState.favourites.isNotEmpty;
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
      height: 70.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomNavBarItem(
            currentIndex: currentIndex,
            icon: Icons.home_outlined,
            index: 0,
            onTap: onTap,
          ),
          CustomNavBarItem(
            currentIndex: currentIndex,
            icon: Icons.shopping_bag_outlined,
            index: 1,
            onTap: onTap,
            showNotification: cartProducts.isNotEmpty,
            notificationColor: Colors.orange,
          ),
          CustomNavBarItem(
            currentIndex: currentIndex,
            icon: Icons.favorite_outline,
            index: 2,
            onTap: onTap,
            showNotification: hasFavourites,
            notificationColor: Colors.red,
          ),
          CustomNavBarItem(
            currentIndex: currentIndex,
            icon: Icons.person_outline,
            index: 3,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
