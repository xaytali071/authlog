

import 'dart:io';

import 'package:authlog/productmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'getproduct.dart';
class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController nameController=TextEditingController();
  TextEditingController descController=TextEditingController();
  TextEditingController priceController=TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  String? imagePath;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            imagePath == null
                ? SizedBox.shrink()
                : Image.file(File(imagePath!)),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "name"
              ),
            ),
            TextFormField(
              controller: descController,
              decoration: InputDecoration(
                  labelText: "desc"
              ),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                  labelText: "price"
              ),
            ),

            ElevatedButton(onPressed: () async {
              final XFile? image=await _picker.pickImage(source: ImageSource.gallery);
              imagePath = image?.path;
              setState(() {});
            }, child: Text("galereya")),
            ElevatedButton(
                onPressed: () async {
                  final XFile? photo =
                  await _picker.pickImage(source: ImageSource.camera);
                  imagePath = photo?.path;
                  setState(() {});
                },
                child: const Text("Add Image")),
            ElevatedButton(
                onPressed: () async {
                  isLoading = true;
                  setState(() {});
                  final storageRef = FirebaseStorage.instance.ref().child("productImage/${DateTime.now().toString()}");
                  await storageRef.putFile(File(imagePath ?? ""));

                  String url = await storageRef.getDownloadURL();

                  firestore
                      .collection("product")
                      .add(ProductModel(
                      name: nameController.text.toLowerCase(),
                      desc: descController.text,
                      price: double.tryParse(priceController.text) ?? 0,
                      image: url)
                      .toJson())
                      .then((value) {
                    isLoading = false;
                    setState(() {});
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const GetProduct()),
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

