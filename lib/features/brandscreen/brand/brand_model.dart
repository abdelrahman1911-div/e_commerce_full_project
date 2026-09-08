class BrandModel {
  final int id; 
  final String name; 
  final String image; 

  BrandModel({
    required this.id, 
    required this.name , 
    required this.image, 
  });  
 
 BrandModel copyWith ({
  int ? id , 
  String ? name , 
  String ? image ,
 }){
  return BrandModel( id: id ?? this.id , name: name ?? this.name , image: image ?? this.image ); 
 }

  factory BrandModel.fromJson(Map<String , dynamic> json) {
    return BrandModel(
    id: json['id'] ?? 1 , 
    name: json['name'] ?? "" ,
    image: json['image'] ?? ""  ); 
  } 
  Map<String , dynamic> toJson () {
    return {
      'id' : id, 
      'name' : name, 
      'image':image,  
    }; 
  }
}