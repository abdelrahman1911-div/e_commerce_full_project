import 'package:e_commerce_full_project/core/widgets/List_view_widget.dart';
import 'package:e_commerce_full_project/core/widgets/No_items_widget.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/data/models/category_model.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/presentation/cubit/category_cubit.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/presentation/cubit/category_state.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/data/models/brand_model.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/cubit/brand_cubit.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/cubit/brand_state.dart';
import 'package:e_commerce_full_project/features/home/widgets/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildItemsList extends StatefulWidget {
  final bool isCat;

  const BuildItemsList({super.key, required this.isCat});

  @override
  State<BuildItemsList> createState() => _BuildItemsListState();
}

class _BuildItemsListState extends State<BuildItemsList> {
  @override
  void initState() {
    super.initState();
    if (widget.isCat) {
      context.read<CategoryCubit>().getAllCategories();
    } else {
      context.read<BrandCubit>().getAllBrands();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCat) {
      return SizedBox(
        height: 80.h,
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CategoryError) {
              return Center(child: Text(state.message));
            }
            if (state is CategorySuccess) {
              final List<CategoryModel> categories = state.categories;
              if (categories.isEmpty) {
                return NoItemsWidget();
              } else {
                return CustomListView(
                  Scroll: Axis.horizontal,
                  items: categories,
                  itemBuilder: (context, item, index) {
                    return ListItemWidget(
                      catData: item,
                      brand: null,
                      isCategories: true,
                    );
                  },
                );
              }
            }
            return const SizedBox.shrink();
          },
        ),
      );
    }

    return SizedBox(
      height: 80.h,
      child: BlocBuilder<BrandCubit, BrandState>(
        builder: (context, state) {
          if (state is BrandLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BrandError) {
            return Center(child: Text(state.message));
          }

          if (state is BrandSuccess) {
            final List<BrandModel> brands = state.brands;

            return CustomListView(
              Scroll: Axis.horizontal,
              items: brands,
              itemBuilder: (context, item, index) {
                return ListItemWidget(
                  catData: null,
                  brand: item,
                  isCategories: false,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
