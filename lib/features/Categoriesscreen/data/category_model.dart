
class CategoryModel {
  final int id; 
  final String name; 
  final String image; 
  CategoryModel({
    required this.id , 
    required this.name , 
    required this.image 
  });  
  CategoryModel copyWith({
   int? id , 
   String? name ,
   String? image , 
  }){
    return CategoryModel(id: id ?? this.id , name: name ?? this.name , image: image ?? this.image); 
  }
   factory CategoryModel.fromJson(Map<String, dynamic> json) {
      return CategoryModel( 
        id: json['id'] ?? 1 , 
        name: json['name'] ?? "" , 
        image: json['image'] ?? "" ); 
   } 
  Map<String, dynamic> toJson () {
   return{
    'id' : id , 
    'name':name , 
    'image' : image
   }; 
  } 

 }