import 'package:chat/helper/constants.dart';
import 'package:chat/services/database.dart';
import 'package:chat/widget/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {

  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();

  Stream ChatMassegeStream;

  Widget ChatMessageList(){
    return StreamBuilder(
      stream: ChatMassegeStream ,
      builder: (context,snapshot){
        return Container(
          height: MediaQuery.of(context).size.height-170,
          child: snapshot.hasData? ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){
                return MessageTile(
                    snapshot.data.documents[index].data['message'],
                    snapshot.data.documents[index].data['sendBy']== Constants.myName);
              }) : Container(),
        );
      },
    );

  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap={
        'message': messageController.text,
        'sendBy': Constants.myName,
        'time': DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConverstaionMessage(widget.chatRoomId,messageMap);
      messageController.text ='';
    }
  }

  @override
  void initState() {
    databaseMethods.getConverstaionMessage(widget.chatRoomId).then((value){
      setState(() {
        ChatMassegeStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                color: Colors.white12,
                child: ListTile(
                  title:  TextField(
                      controller: messageController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.white54),
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
                        child: Image.asset('assets/images/send.png',height: 20,)),
                    onTap: (){
                      sendMessage();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0:24 , right: isSendByMe ? 24 :0),
      margin: EdgeInsets.symmetric(vertical: 3),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft ,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 13),
        decoration: BoxDecoration(
          gradient: LinearGradient(
          colors: isSendByMe ? [
            const Color(0xff007EF4),
          const Color(0xff2A75BC)
          ]
          : [
          const Color(0x1AFFFFFF),
      const Color(0x1AFFFFFF)
      ],
          ),
          borderRadius: isSendByMe ?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
              ): BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23),
          )
        ),
        child: Text(message, style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight:FontWeight.w600
        )
        ),
      ),
    );
  }
}


