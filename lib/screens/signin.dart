import 'package:chat/helper/helperfunction.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatRoomScreen.dart';

class SingIn extends StatefulWidget {

  final Function toggle;
  SingIn(this.toggle);

  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {

  final formkey = GlobalKey<FormState>();
  AuthMethods authMethods= AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();


  TextEditingController emailTextEditing = TextEditingController();
  TextEditingController passwordTextEditing = TextEditingController();

  bool isLoading =false;
  QuerySnapshot snapshotUserInfo;

  signIn(){
    if(formkey.currentState.validate()){
      HelperFunction.saveUserEmailSharePreferences(emailTextEditing.text);

      databaseMethods.getUserByUserEmail(emailTextEditing.text)
          .then((val){
        snapshotUserInfo=val;
        HelperFunction.saveUserEmailSharePreferences(snapshotUserInfo.documents[0].data['name']);
      });

     setState(() {
       isLoading =true;
     });

     authMethods.signInWithEmailAndPassword(emailTextEditing.text, passwordTextEditing.text)
    .then((val){
      if(val !=null){
        HelperFunction.saveUserLoggedInSharePreferences(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
        ));
      }
     });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(left: 24,right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formkey,
              child: Column(
                children: [
                  // Email text field
                  TextFormField(
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val) ? null :'email not valid' ;
                      },
                      controller: emailTextEditing,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration('Email', 'Email')
                  ),

                  // Password text field
                  TextFormField(
                      validator: (val){
                        return val.length > 8 ? null :'password not valid';
                      },
                      obscureText: true,
                      controller: passwordTextEditing,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration('Password', 'Password')
                  ),
                ],
              ),
            ),

            // first text field
//            TextField(
//              controller: emailTextEditing ,
//                style: simpleTextStyle(),
//                decoration: textFieldInputDecoration('Email', 'Email')
//            ),
//
//            // Secand text field
//            TextField(
//              controller: passwordTextEditing,
//                style: simpleTextStyle(),
//                decoration: textFieldInputDecoration('Password', 'Password')
//            ),

            SizedBox(height: 20),

            Padding(padding: EdgeInsets.only(left: 220,right: 10),
            child: Text('Forget Password?',style: simpleTextStyle())
            ),

            SizedBox(height: 25),

            //Sign button
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color(0xff007EF4),
                        Color(0xff123C9E)
                      ]
                  ),
                  borderRadius: BorderRadius.circular(26)
                ),
                child: Center(child: Text('Sign In',style: simpleTextStyle())),
              ),
              onTap: (){
                signIn();
              },
            ),

            SizedBox(height: 20),
            //Sign with goggle button
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.circular(26)
              ),
              child: Center(child: Text('Sign In with Google')),
            ),
            SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have account?',style: simpleTextStyle()),
                InkWell(
                  child: Text('Register now',style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    decoration: TextDecoration.underline
                  )),
                  onTap: (){
                    widget.toggle();
                  },
                ),
              ],
            ),
            SizedBox(height: 70),

          ],
        ),
      ),
    );
  }
}
