import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';
import 'package:vivadoo/models/message_model.dart';

class MessagesProvider with ChangeNotifier{
  bool isInbox = true;
  List<MessageModel> messages = [];
  List<Map<String, String>> archivedChats = [];
  String photo = "";

  setIsInbox(bool value){
    isInbox = value;
    notifyListeners();
  }

  setMessages(List<MessageModel> newMessages){
    messages = newMessages;
    notifyListeners();

  }

  // addOrRemoveFromInboxChat(Map<String, String> newData, {bool isAdd = true}){
  //   if(isAdd){
  //     List<Map<String, String>> tempData = inboxChats;
  //     tempData.add(newData);
  //     inboxChats = tempData;
  //   }else{
  //     List<Map<String, String>> tempData = inboxChats;
  //     tempData.remove(newData);
  //     inboxChats = tempData;
  //   }
  //   notifyListeners();
  // }

  // addOrRemoveFromArchivedChats(Map<String, String> data , {bool isAdd = true}){
  //   if(isAdd){
  //     List<Map<String, String>> tempArchived = archivedChats;
  //     tempArchived.add(data);
  //     archivedChats = tempArchived;
  //     // addOrRemoveFromInboxChat(data , isAdd: false);
  //   }else{
  //     List<Map<String, String>> tempArchived = archivedChats;
  //     tempArchived.remove(data);
  //     archivedChats = tempArchived;
  //     // addOrRemoveFromInboxChat(data , isAdd: true);
  //   }
  //   notifyListeners();
  // }





}