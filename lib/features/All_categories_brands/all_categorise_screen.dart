import 'package:e_commerce_full_project/features/Categoriesscreen/data/categories_data.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/categorise_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AllCategoriesScreen extends StatelessWidget {

   AllCategoriesScreen({super.key});

  final CategoriesData catData = CategoriesData(); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('categories'.tr())),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: catData.categoriesList.length,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          final category = catData.categoriesList[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(category.image),
            ),
            title: Text(category.name.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoriseScreen(selectedCategoryName: category.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
