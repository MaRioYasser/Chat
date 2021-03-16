import 'package:chat/helper/helperfunction.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/widget/widget.dart';
import 'package:flutter/material.dart';
import 'chatRoomScreen.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final formkey = GlobalKey<FormState>();

  TextEditingController usernameTextEditing = TextEditingController();
  TextEditingController emailTextEditing = TextEditingController();
  TextEditingController passwordTextEditing = TextEditingController();

  bool isloading =false;

  AuthMethods authMethods= AuthMethods();
  DatabaseMethods databaseMethods =DatabaseMethods();

  signMeUp(){
    if(formkey.currentState.validate()){
      setState(() {
        isloading= true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditing.text,passwordTextEditing.text).then((val){
//       print('$val');
      Map<String,String> userInfoMap ={
        'name':usernameTextEditing.text,
        'email':emailTextEditing.text
      };

      HelperFunction.saveUserEmailSharePreferences(emailTextEditing.text);
      HelperFunction.saveUserNameSharePreferences(usernameTextEditing.text);


       databaseMethods.uploadUserInfo(userInfoMap);
      HelperFunction.saveUserLoggedInSharePreferences(true);

      Navigator.pushReplacement(context, MaterialPageRoute(
         builder: (context) => ChatRoom()
       ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isloading?Container(
        child: Center(child: CircularProgressIndicator()),
      )
          :Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 24,right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formkey,
              child: Column(
                children: [
                  // username
                  TextFormField(
                    validator: (val){
                      return val.isEmpty || val.length<4 ?'this will never work': null;
                    },
                      controller: usernameTextEditing,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration('Username', 'Username')
                  ),
                  // Email text field
                  TextFormField(
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null :'email not valid' ;
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


            SizedBox(height: 25),

            //Sign button
            InkWell(
              onTap: (){
                signMeUp();
              },
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
                child: Center(child: Text('Sign Up',style: simpleTextStyle())),
              ),
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
              child: Center(child: Text('Sign Up with Google')),
            ),
            SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have account?',style: simpleTextStyle()),
                InkWell(
                  child: Text('SignIN now',style: TextStyle(
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
          ],
        ),
      ),
    );
  }
}
