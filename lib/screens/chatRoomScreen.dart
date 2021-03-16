import 'package:chat/helper/authenticate.dart';
import 'package:chat/helper/constants.dart';
import 'package:chat/helper/helperfunction.dart';
import 'package:chat/screens/search.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/widget/widget.dart';
import 'package:flutter/material.dart';

import 'conversation.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods= AuthMethods();
  DatabaseMethods  databaseMethods = DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
            return ChatRoomTile(snapshot.data.documents[index].data['chatRoomId']
            .toString().replaceAll('_', '')
                .replaceAll(Constants.myName,''),
                snapshot.data.documents[index].data['chatRoomId']);
            }): Container(
          color: Colors.blue,
        );
      },
    );

  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo()async{
    Constants.myName = await HelperFunction.getUserNameSharePreferences();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Image.asset('assets/images/logo.png',height: 57,),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app,color: Colors.white,),
            onPressed: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=> Authenticate()
              )
              );
            },
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context)=> SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {

  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        children: [
          InkWell(
            child: Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text('${userName.substring(0,1).toUpperCase()}',style: simpleTextStyle(),),
            ),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(
                  builder: (context) => ConversationScreen(chatRoomId)));
            },
          ),
          SizedBox(width: 8,),
          Text(userName,style: simpleTextStyle(),)
        ],
      ),
    );
  }
}

