
import 'dart:io';

import 'package:authlog/ebook/bookmodel.dart';
import 'package:authlog/ebook/getbook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class AddBook extends StatefulWidget {
  const AddBook({Key? key}) : super(key: key);

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  TextEditingController auth=TextEditingController();
  TextEditingController book=TextEditingController();
  TextEditingController desct=TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  String? imagePath;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: auth,
        decoration: InputDecoration(labelText: "Author"),
            ),
            TextFormField(
              controller: book,
              decoration: InputDecoration(labelText: "BookName"),
            ),
            TextFormField(
              controller:  desct,
              decoration: InputDecoration(labelText: "Description"),
            ),
            ElevatedButton(onPressed: () async {
              final XFile? image=await _picker.pickImage(source: ImageSource.gallery);
              imagePath=image?.path;
              setState(() {});
            }, child: Text("Add Photo")),

            ElevatedButton(
                onPressed: () async {
                  isLoading = true;
                  setState(() {});
                  final storageRef = FirebaseStorage.instance.ref().child("ebookImage/${DateTime.now().toString()}");
                  await storageRef.putFile(File(imagePath ?? ""));

                  String url = await storageRef.getDownloadURL();

                  firestore
                      .collection("ebook")
                      .add(BookModel(
                      bookname:book.text.toLowerCase(),
                      desc: desct.text,
                      author: auth.text,
                      image: url)
                      .toJson())
                      .then((value) {
                    isLoading = false;
                    setState(() {});
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const GetBook()),
                            (route) => false);
                  });
                },
                child: isLoading
                    ? CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text("Save"))
          ],
        ),
      ),
    );
  }
}
