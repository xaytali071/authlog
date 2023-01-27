import 'package:authlog/addproduct.dart';
import 'package:authlog/productmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
class GetProduct extends StatefulWidget {
  const GetProduct({Key? key}) : super(key: key);

  @override
  State<GetProduct> createState() => _GetProductState();
}

class _GetProductState extends State<GetProduct> {
  final FirebaseFirestore fireStore=FirebaseFirestore.instance;
  List<ProductModel> list=[];
  List listOfDoc = [];
  bool isLoading=true;
  QuerySnapshot? data;
  getInfo({String? text}) async {
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print("onBackgroundMessage");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage");
    });
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcm: ${fcmToken}");
   isLoading=true;
   setState(() {});

    if(text==null){
      list.clear();
      data= await fireStore.collection("product").get();
    }
    else{
      data=await fireStore.collection("product").orderBy("name").startAt(["$text"]).endAt(["$text"+"\uf8ff"]).get();
    }
   list.clear();
   listOfDoc.clear();
   for (QueryDocumentSnapshot element in data?.docs ?? []) {
     list.add(ProductModel.fromJson(element));
     listOfDoc.add(element.id);
   }
    isLoading=false;
    setState(() {});
  }
  @override
  void initState() {
    getInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product"),
      ),
      body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Search"),
                    onChanged: (s) {
                      getInfo(text: s);
                    },
                  ),
                ),
                isLoading
                    ? CircularProgressIndicator() :
                ListView.builder(
                  shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context,index){
                  return  Container(
                     margin: EdgeInsets.only(bottom: 10),
                     decoration: BoxDecoration(
                       color: Colors.blue
                     ),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("${list[index].image}")
                              )
                            ),
                          ),
                          Center(child: Text("${list[index].name}"),),
                          Center(child: Text("${list[index].price}"),),
                          Row(
                            children:[
                          Center(child: Text("${list[index].desc}"),),
                              IconButton(onPressed: (){
                                fireStore
                                    .collection("product")
                                    .doc(listOfDoc[index])
                                    .delete()
                                    .then(
                                      (doc) => print("Document deleted"),
                                  onError: (e) => print(
                                      "Error updating document $e"),
                                );
                                list.removeAt(index);
                                listOfDoc.removeAt(index);
                                setState(() {});
                              }, icon: Icon(Icons.restore_from_trash_outlined))
                              ]
                          ),
                        ],
                      ),
                  );
                }),
              ],
            ),
          ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>AddProduct()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
