import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserByUsername(String username)async{
    return await Firestore.instance.collection('users').
    where('name', isEqualTo: username).getDocuments();

  }

  getUserByUserEmail(String userEmail)async{
    return await Firestore.instance.collection('users').
    where('email', isEqualTo: userEmail).getDocuments();

  }

  uploadUserInfo(userMap){
    Firestore.instance.collection('users')
        .add(userMap).catchError((e){
          print(e);
    });
  }
  createChatRoom(String chatRoomId,chatRoomMap){
    Firestore.instance.collection('ChatRoom')
        .document(chatRoomId).setData(chatRoomMap)
        .catchError((e){
       print(e.toString());
    });
  }

  getConverstaionMessage (String chatRoomId)async{
   return await Firestore.instance.
    collection('ChatRoom')
        .document(chatRoomId)
        .collection('chat')
        .orderBy('time',descending: false)
        .snapshots();
    
  }

  addConverstaionMessage(String chatRoomId, messageMap){
    Firestore.instance.
    collection('ChatRoom')
        .document(chatRoomId)
        .collection('chat')
        .add(messageMap).catchError((e){
      print(e.toString());
    });
  }

  getChatRooms(String userName)async{
  return await Firestore.instance.
  collection('ChatRoom').
  where('users',arrayContains: userName).
    snapshots();
  }

}