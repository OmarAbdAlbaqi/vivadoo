import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';

class MessagesProvider with ChangeNotifier{
  bool isInbox = true;
  List<Map<String, String>> inboxChats = [
    {
      'name': 'John Doe',
      'username': '@johndoe',
      'time': '12:30 PM',
      'image': 'assets/profile.png'
    },
    {
      'name': 'Jane Smith',
      'username': '@janesmith',
      'time': '11:15 AM',
      'image': 'assets/profile.png'
    },
    {
      'name': 'Mike Brown',
      'username': '@mikebrown',
      'time': '10:45 AM',
      'image': 'assets/profile.png'
    },
    {
      'name': 'John Doe',
      'username': '@johndoe',
      'time': '12:30 PM',
      'image': 'assets/profile.png'
    },
    {
      'name': 'Jane Smith',
      'username': '@janesmith',
      'time': '11:15 AM',
      'image': 'assets/profile.png'
    },
    {
      'name': 'Mike Brown',
      'username': '@mikebrown',
      'time': '10:45 AM',
      'image': 'assets/profile.png'
    },
    // ... other chat items
  ];
  List<Map<String, String>> archivedChats = [];

  setIsInbox(bool value){
    isInbox = value;
    notifyListeners();
  }

  addOrRemoveFromInboxChat(Map<String, String> newData, {bool isAdd = true}){
    if(isAdd){
      List<Map<String, String>> tempData = inboxChats;
      tempData.add(newData);
      inboxChats = tempData;
    }else{
      List<Map<String, String>> tempData = inboxChats;
      tempData.remove(newData);
      inboxChats = tempData;
    }
    notifyListeners();
  }

  addOrRemoveFromArchivedChats(Map<String, String> data , {bool isAdd = true}){
    if(isAdd){
      List<Map<String, String>> tempArchived = archivedChats;
      tempArchived.add(data);
      archivedChats = tempArchived;
      addOrRemoveFromInboxChat(data , isAdd: false);
    }else{
      List<Map<String, String>> tempArchived = archivedChats;
      tempArchived.remove(data);
      archivedChats = tempArchived;
      addOrRemoveFromInboxChat(data , isAdd: true);
    }
    notifyListeners();
  }


  getAllUsers () async {
    FirebaseFirestore.instance.collection('users').snapshots(includeMetadataChanges: true).listen((user){
      
    });
  }




}