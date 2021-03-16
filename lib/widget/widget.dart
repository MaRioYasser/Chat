import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    title: Image.asset('assets/images/logo.png',height: 57,),
  );
}

InputDecoration textFieldInputDecoration(String hintText, String labelText){
  return  InputDecoration(
  hintText: hintText,
  labelText: labelText,
  hintStyle: TextStyle(color: Colors.white54),
  labelStyle: TextStyle(color: Colors.white12),
  focusedBorder:
  UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 14,
      fontWeight:FontWeight.w600
  );
}
