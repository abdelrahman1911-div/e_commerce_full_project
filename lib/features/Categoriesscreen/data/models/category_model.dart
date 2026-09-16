
class CategoryModel {
  final String id; 
  final String name; 
  final String image; 
  CategoryModel({
    required this.id , 
    required this.name , 
    required this.image 
  });  
  CategoryModel copyWith({
   String? id , 
   String? name ,
   String? image , 
  }){
    return CategoryModel(id: id ?? this.id , name: name ?? this.name , image: image ?? this.image); 
  }
   factory CategoryModel.fromJson(Map<String, dynamic> json) {
      return CategoryModel( 
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
       ); 
   } 
  Map<String, dynamic> toJson () {
   return{
    'id' : id , 
    'name':name , 
    'image' : image
   }; 
  } 

 }