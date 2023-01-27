import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:authlog/ebook/addbook.dart';
import 'package:authlog/ebook/bookmodel.dart';
import 'package:authlog/ebook/inbook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
class GetBook extends StatefulWidget {
  const GetBook({Key? key}) : super(key: key);

  @override
  State<GetBook> createState() => _GetBookState();
}

class _GetBookState extends State<GetBook> {
  final FirebaseFirestore fireStore=FirebaseFirestore.instance;
  List<BookModel> list=[];
  List listOfDoc=[];
  QuerySnapshot? data;
  bool isLoading=true;
  Future<void> getInfo({String? text}) async {
    isLoading = true;
    setState(() {});
    if(text == null){
      data = await fireStore.collection("ebook").get();
    }else{
      data = await fireStore
          .collection("ebook")
          .orderBy("bookname")
          .startAt([text]).endAt(["$text\uf8ff"]).get();
    }
    list.clear();
    listOfDoc.clear();
    data?.docs.forEach((element) {
      list.add(BookModel.fromJson(element));
      listOfDoc.add(element.id);
    });
    isLoading = false;
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
        title: Text("EBook"),
      ),
      body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              decoration: InputDecoration(labelText: "Search"),
              onChanged: (s){
                getInfo(text: s);
              },
            ),
          ),
          isLoading ? CircularProgressIndicator() : GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 350),
          itemCount: list.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context,index){
          return Padding(padding: EdgeInsets.only(left: 5,top: 5,right: 5),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>InBook(name: list[index].bookname, auth:list[index].author, desc: list[index].desc, img: list[index].image)));
            },
            onLongPress: (){
              showDialog(context: context, builder: (context)
              {
                return
                  Dialog(
                    child:
                    Container(
                      width: 200,
                      height: 200,
                      child: Column(
                        children: [
                          TextButton(onPressed: () {
                            fireStore
                                .collection("product")
                                .doc(listOfDoc[index])
                                .delete()
                                .then(
                                  (doc) => print("Document deleted"),
                              onError: (e) =>
                                  print(
                                      "Error updating document $e"),
                            );
                            list.removeAt(index);
                            listOfDoc.removeAt(index);
                            setState(() {});
                          }, child: Text("remove"))
                        ],
                      ),
                    ),
                  );
              });
            },
            child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black)
            ),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("${list[index].image}")
                      )
                    ),
                  ),
                  Text("${list[index].bookname}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                  Text("${list[index].author}",style: TextStyle(color: Colors.grey),)
                ],
              ),
            ),
          ),
          );
          }),
        ],
      ),
    ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>AddBook()));
          },child: Icon(Icons.add),
          ),
          FloatingActionButton(onPressed: () async {
    const productLink = 'https://foodyman.org/';

    const dynamicLink =
    'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyCuzVcMKW6dpUmhTTwaOnShyouEXLgWywM';

    final dataShare = {
    "dynamicLinkInfo": {
    "domainUriPrefix": 'https://lessonnt.page.link',
    "link": productLink,
    "androidInfo": {
    "androidPackageName": 'com.foodyman',
    },
    "iosInfo": {
    "iosBundleId": "org.foodyman.customer",
    },
    "socialMetaTagInfo": {
    "socialTitle": "Title",
    "socialDescription": "Description: Description",
    "socialImageLink": 'Image',
    }
    }
    };

    final res = await http.post(Uri.parse(dynamicLink),
    body: jsonEncode(dataShare));

    var shareLink = jsonDecode(res.body)['shortLink'];
    await FlutterShare.share(
    text:  "Foodyman",
    title:  "ytrew",
    linkUrl: shareLink,
    );

    print(shareLink);
          },child: Icon(Icons.link),)
        ],
      ),
);

  }
}
