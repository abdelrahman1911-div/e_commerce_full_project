
import 'package:e_commerce_full_project/features/Categoriesscreen/data/category_model.dart';

class CategoriesData {
 
 final List<Map<String, dynamic>> _categoriesData = 
 [
       { 
      'id' : 1, 
      'name': 'women',
      'image':
          'https://media.istockphoto.com/id/1355499535/photo/vertical-image-of-an-adult-woman-smiling-with-her-arms-crossed-looking-at-camera-indoor.jpg?s=2048x2048&w=is&k=20&c=-8Vh2ffUaqHPXlI-wmtdyzbeJXI768fLjPRwYpxvuR8=',
    },
    { 
      'id' : 2, 
      'name': 'men',
      'image':
          'https://images.unsplash.com/photo-1516257984-b1b4d707412e?auto=format&fit=crop&w=150&q=80',
    },
    {
        
            'id' : 3, 
      'name': 'kids',
      'image':
          'https://images.unsplash.com/photo-1519689680058-324335c77eba?auto=format&fit=crop&w=150&q=80',
    },
    { 
      'id' : 4, 
      'name': 'wetsuits',
      'image':
          'https://images.unsplash.com/photo-1598822738715-32eff3ad99b0?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8V2V0c3VpdHMlMjBjbG90aGVzfGVufDB8fDB8fHww',
    },
    { 
      'id' : 5, 
      'name': 'boards',
      'image':
          'https://plus.unsplash.com/premium_photo-1676645882020-8387c2c77ef8?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    },
    {

      'id' : 6, 
      'name': 'shoes',
      'image':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=150&q=80',
    },
    { 
      'id' : 7, 
      'name': 'accessories',
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=150&q=80',
    },
 ];   
 List<CategoryModel> get categoriesList { 
   return _categoriesData
           .map((json)
           => CategoryModel.fromJson(json))
           .toList(); 
 }
}