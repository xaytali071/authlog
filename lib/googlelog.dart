import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class GoogleLogo extends StatefulWidget {
  const GoogleLogo({Key? key}) : super(key: key);

  @override
  State<GoogleLogo> createState() => _GoogleLogoState();
}

class _GoogleLogoState extends State<GoogleLogo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try{
              GoogleSignIn _googleSignIn = GoogleSignIn();
              var data=await _googleSignIn.signIn();
              print(data?.id);
              print(data?.email);
              print(data?.photoUrl);
              print(data?.displayName);
            }catch(e){
              print(e);
            }

          },
          child: Text("google"),
        ),
      ),
    );
  }
}
