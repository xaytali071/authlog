import 'package:flutter/material.dart';
class InBook extends StatefulWidget {
  final String name;
  final String auth;
  final String desc;
  final String img;
  const InBook({Key? key, required this.name, required this.auth, required this.desc, required this.img}) : super(key: key);

  @override
  State<InBook> createState() => _InBookState();
}

class _InBookState extends State<InBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.name}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("${widget.img}")
                )
              ),
            ),
            SizedBox(height: 10,),
            Text("Muallif: ${widget.auth}"),
            Text("Kitob nomi: ${widget.name}"),
            SizedBox(height: 10,),
            SizedBox(
                width: 400,
                child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${widget.desc}"),
            )
            )
          ],
        ),
      ),
    );
  }
}
