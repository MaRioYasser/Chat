import 'package:chat/helper/constants.dart';
import 'package:chat/screens/conversation.dart';
import 'package:chat/services/database.dart';
import 'package:chat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods =DatabaseMethods();

  TextEditingController searchtextEditingController= TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList(){
    return searchSnapshot !=null? ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot.documents.length,
        itemBuilder:(context,index){
          return SearchTile(
            userName: searchSnapshot.documents[index].data['name'],
            userEmail: searchSnapshot.documents[index].data['email'],
          );
        }): Container();
  }

  initiateSearch(){
    databaseMethods.getUserByUsername(searchtextEditingController.text).then((val){
      setState(() {
        searchSnapshot =val;
      });
    });
  }

  createChatRoom({String userName}){
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName,Constants.myName);
      List<String> users=[userName,Constants.myName];
      Map<String,dynamic> charRoomMap ={
        'user': users,
        'chatroomId' :chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId,charRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context)=> ConversationScreen(
              chatRoomId
          ) ));
    }else {
      print('you can\'t send message to $userName');
    }
  }

  Widget SearchTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 18),
      child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,style: simpleTextStyle(),),
                Text(userEmail  ,style: simpleTextStyle(),)
              ],
            ),
            Spacer(),
            InkWell(
              child: Container(
                child: Text('Message',style: simpleTextStyle(),),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 15),
              ),
              onTap: (){
                createChatRoom(userName: userName);
              },
            )
          ]
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
          Container(
            height: 80,
            color: Colors.white12,
            child: ListTile(
                    title:  TextField(
                      controller:searchtextEditingController ,
                      style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search UserName',
                          labelText: 'Search UserName',
                          hintStyle: TextStyle(color: Colors.white54),
                          labelStyle: TextStyle(color: Colors.white12),
                          border: InputBorder.none,
                        )
                    ),
                    trailing: InkWell(
                      child: Container(
                        height: 40,
                          width: 40,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.white70,
                                    Colors.white54,
                                  ]),
                              borderRadius: BorderRadius.circular(40)),
                          child: Image.asset('assets/images/search_white.png',height: 20,)),
                      onTap: (){
                        initiateSearch();
                      },
                    ),
                  ),
          ),
          searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b){
  if(a.substring(0,1).codeUnitAt(0)> b.substring(0,1).codeUnitAt(0)){
    return'$b\_$a';
  }else{
    return'$a\_$b';
  }

}
