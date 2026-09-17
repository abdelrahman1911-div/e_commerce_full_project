import 'package:e_commerce_full_project/core/widgets/app_bar_prod_home.dart';
import 'package:e_commerce_full_project/core/widgets/header_view_widget.dart';
import 'package:e_commerce_full_project/core/widgets/carousel_widget.dart';
import 'package:e_commerce_full_project/core/widgets/product_card.dart';
import 'package:e_commerce_full_project/features/home/customnavbar/customnavbar.dart';
import 'package:e_commerce_full_project/features/home/favourite/peresentation/favourite_screen.dart';
import 'package:e_commerce_full_project/features/home/mycart/mycart_screen.dart';
import 'package:e_commerce_full_project/features/home/profile/presentation/screen/profile_screen.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:e_commerce_full_project/features/home/product/presentation/cubit/prod_cubit.dart';
import 'package:e_commerce_full_project/features/home/product/presentation/cubit/prod_state.dart';
import 'package:e_commerce_full_project/features/home/widgets/build_Items_list.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/data/models/brand_model.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/cubit/brand_cubit.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/cubit/brand_state.dart';
import 'package:e_commerce_full_project/features/home/widgets/header_image_widget.dart';
import 'package:e_commerce_full_project/features/search/presentation/cubit/search_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchBarController =
      TextEditingController();
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getAllProducts();
    context.read<BrandCubit>().getAllBrands();
  }
  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index != 0 && searchBarController.text.isNotEmpty) {
      searchBarController.clear();
      context.read<SearchCubit>().clearSearch();
    }
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
              sear: searchBarController,
            )
          : null,
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductCubit, ProductState>(
            listener: (context, productState) {
              if (productState is ProductSuccess) {
                final brandState =
                    context.read<BrandCubit>().state;
                if (brandState is BrandSuccess) {
                  context.read<SearchCubit>().initialize(
                    products: productState.products,
                    brands: brandState.brands,
                  );
                }
              }
            },
          ),
          BlocListener<BrandCubit, BrandState>(
            listener: (context, brandState) {
              if (brandState is BrandSuccess) {
                final productState =
                    context.read<ProductCubit>().state;

                if (productState is ProductSuccess) {
                  context.read<SearchCubit>().initialize(
                    products: productState.products,
                    brands: brandState.brands,
                  );
                }
              }
            },
          ),
        ],
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeTab(),
            const MycartScreen(),
            const FavouriteScreen(),
            const ProfileScreen(),
          ],
        ),
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

      padding: EdgeInsets.only(
        bottom: 100.h,
      ),

      child: Column(
        children: [
          HeaderImageWidget(),

          SizedBox(height: 8.h),
          HeaderViewWidget(
            Text1: 'shop_by_category'.tr(),
            ButtonText: 'see_all'.tr(),
            isCategories: true,
          ),

          BuildItemsList(
            isCat: true,
          ),

          SizedBox(height: 8.h),

          CarouselWidget(),

          SizedBox(height: 8.h),

          HeaderViewWidget(),

          BuildItemsList(
            isCat: false,
          ),

          SizedBox(height: 8.h),

          HeaderViewWidget(
            Text1: 'for_your_fashion'.tr(),
            ButtonText: 'see_all'.tr(),
          ),

          _buildProducts(),
        ],
      ),
    );
  }


  Widget _buildProducts() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, productState) {

        if (productState is ProductLoading) {
          return SizedBox(
            height: 300.h,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (productState is ProductError) {
          return SizedBox(
            height: 300.h,
            child: Center(
              child: Text(
                productState.message,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (productState is ProductSuccess) {
          final List<ProductModel> allProducts =
              productState.products;

          if (allProducts.isEmpty) {
            return SizedBox(
              height: 300.h,
              child: const Center(
                child: Text(
                  'No products found',
                ),
              ),
            );
          }

          final searchState =
              context.watch<SearchCubit>().state;

          List<ProductModel> products;

          if (searchState is SearchLoaded &&
              searchState.isSearching) {
            products = searchState.products;
          } else {
            products = allProducts;
          }
          if (searchState is SearchLoaded &&
              searchState.isSearching &&
              products.isEmpty) {
            return SizedBox(
              height: 300.h,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 55.sp,
                      color: Colors.grey,
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      'No products found',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 5.h),

                    Text(
                      'Try another product or brand',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return BlocBuilder<BrandCubit, BrandState>(
            builder: (context, brandState) {
              if (brandState is BrandLoading) {
                return SizedBox(
                  height: 300.h,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (brandState is BrandError) {
                return SizedBox(
                  height: 300.h,
                  child: Center(
                    child: Text(
                      brandState.message,
                    ),
                  ),
                );
              }

              final List<BrandModel> brands =
                  brandState is BrandSuccess
                      ? brandState.brands
                      : [];
              return GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 5.h,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final matchingBrands = brands.where(
                    (brand) =>
                        brand.id == product.brandId,
                  );
                  String brandName =
                      product.brandId;
                  if (matchingBrands.isNotEmpty) {
                    brandName =
                        matchingBrands.first.name;
                  }
                  return ProductCardWidget(
                    product: product,
                    brandName: brandName,
                  );
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
