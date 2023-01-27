import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
class DynmaicLink extends StatefulWidget {
  const DynmaicLink({Key? key}) : super(key: key);

  @override
  State<DynmaicLink> createState() => _DynmaicLinkState();
}

class _DynmaicLinkState extends State<DynmaicLink> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic Link"),
      ),
      body: Center(
        child: Text("Genetare link"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
        },
        child: Text("+"),
      ),
    );
  }
}
