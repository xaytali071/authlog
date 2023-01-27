import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class BookModel{
  final String author;
  final String bookname;
  final String desc;
  final String image;
  BookModel({required this.author, required this.bookname, required this.desc, required this.image,});
  
  factory BookModel.fromJson(QueryDocumentSnapshot data){
    return BookModel(author: data["author"], bookname: data["bookname"], desc: data["desc"], image: data["image"]);
  }
  toJson(){
    return {
      "author": author,
      "bookname":bookname,
      "desc":desc,
      "image":image,
    };
}
}