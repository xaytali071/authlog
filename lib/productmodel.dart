import 'package:cloud_firestore/cloud_firestore.dart';
class ProductModel{
  final String name;
  final String desc;
  final num price;
  final String? image;
  ProductModel({ required this.name,required this.desc,required this.price,this.image,});

  factory ProductModel.fromJson(QueryDocumentSnapshot data){
    return ProductModel(name: data["name"],desc: data["desc"], price: data["price"],image: data["image"]);
  }
  toJson() {
    return {"name": name, "desc": desc, "price": price,"image":image};
  }
}