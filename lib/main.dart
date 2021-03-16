import 'package:chat/helper/helperfunction.dart';
import 'package:chat/screens/chatRoomScreen.dart';
import 'package:flutter/material.dart';

import 'helper/authenticate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState()async{
    await HelperFunction.getUserLoggedInSharePreferences().then((value){
      userIsLoggedIn = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff123C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:userIsLoggedIn ? ChatRoom():Authenticate(),
    );
  }
}
