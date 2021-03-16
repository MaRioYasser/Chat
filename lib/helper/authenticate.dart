import 'package:chat/screens/signin.dart';
import 'package:chat/screens/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleview(){
    setState(() {
      showSignIn =!showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SingIn(toggleview);
    }else{
      return SignUp(toggleview);

    }
  }
}
