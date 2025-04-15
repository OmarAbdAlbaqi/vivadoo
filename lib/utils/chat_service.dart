import 'dart:typed_data';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vivadoo/providers/messages/messages_provider.dart';
import 'package:vivadoo/utils/api_manager.dart';

import '../models/dialog_model.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ApiManager _apiManager = ApiManager();


  // Function to update dialogs in Firestore
  static Future<void> updateDialogsInFirestore(String userId) async {
    try {
      // Fetch the dialog data from your API
      final response = await ApiManager.listOfDialogs();
      final data = jsonDecode(response.body);

      if (data['success'] == 1 && data['items'] is List) {
        final List dialogs = data['items'];

        // Iterate through dialogs and update Firestore
        for (var dialog in dialogs) {
          final dialogId = dialog['id'].toString();
          final dialogModel = DialogModel(
            id: dialog['id'],
            postId: dialog['post_id'],
            status: dialog['status'],
            unread: dialog['unread'],
            name: dialog['name'],
            title: dialog['title'],
            text: dialog['text'],
            timeText: dialog['time_text'],
            time: DateTime.parse(dialog['time']),
            isMarked: dialog['is_marked'],
            isFile: dialog['is_file'],
            photo: dialog['photo'],
            messages: [], // Do not update messages here
          );

          // Save or update dialog in Firestore
          await FirebaseFirestore.instance
              .collection('dialogs')
              .doc(userId)
              .collection('userDialogs')
              .doc(dialogId) // Use dialogId as document ID
              .set(dialogModel.toJson(), SetOptions(merge: true));
        }
      }
    } catch (e) {
      print('Failed to update dialogs in Firestore: $e');
    }
  }

  // Function to update messages for a specific dialog in Firestore
  static Future<void> updateMessagesInFirestore(String userId, int dialogId) async {

    try {
      // Fetch the messages for the specific dialog from the API
      final response = await ApiManager.messagesByDialog(dialogId.toString(), '0');
      final data = jsonDecode(response.body);

      if (data['success'] == 1 && data['items'] is List) {
        final List messages = data['items'];

        // Get the reference to the user's dialog in Firestore
        final dialogRef = FirebaseFirestore.instance
            .collection('dialogs')
            .doc(userId)
            .collection('userDialogs')
            .doc(dialogId.toString());

        // Update each message in the messages subcollection
        for (var msg in messages) {
          final messageId = msg['id'].toString();
          final sentAt = DateTime.parse(msg['sentAt']['date']);
          final messageContent = msg['message'];

          // Query for messages in Firestore with the same sentAt timestamp
          final querySnapshot = await dialogRef.collection('messages')
              .where('sentAt', isEqualTo: Timestamp.fromDate(sentAt))
              .get();

          // If there's a message with the same sentAt, delete it
          if (querySnapshot.docs.isNotEmpty) {
            for (var doc in querySnapshot.docs) {
              await doc.reference.delete(); // Delete the existing message
            }
          }

          // Save or update the message in the messages subcollection
          await dialogRef.collection('messages').doc(messageId).set({
            'message': messageContent,
            'isResponse': msg['isResponse'],
            'isRead': msg['isRead'],
            'isPushed': msg['isPushed'],
            'isFile': msg['isFile'],
            'sentAt': Timestamp.fromDate(sentAt),
          }, SetOptions(merge: true)); // Merge to avoid overwriting existing messages
        }
      }
    } catch (e) {
      print('Failed to update messages in Firestore: $e');
    }
  }

  static Stream<List<DialogModel>> listenToDialogsFromServer(String userId) {
    // First, get the fresh data from the server
    FirebaseFirestore.instance
        .collection('dialogs')
        .doc(userId)
        .collection('userDialogs')
        .orderBy('time', descending: true)
        .get(const GetOptions(source: Source.server))  // Force fetch from server
        .then((snapshot) {
      // You can process fresh data if needed
      // Optionally, process the fetched data here.
      // This ensures the app gets a fresh snapshot of dialogs before listening.
    });

    // Then, listen to future updates in real-time with snapshots
    return FirebaseFirestore.instance
        .collection('dialogs')
        .doc(userId) // User document ID
        .collection('userDialogs') // Subcollection of user dialogs
        .orderBy('time', descending: true) // Optionally, order by time if needed
        .snapshots()  // Real-time listener
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DialogModel.fromFirestore(doc);
      }).toList();
    });
  }

  // Function to listen to changes in Firestore for messages within a dialog
  static Stream<List<MessageModel>> listenToMessagesFromServer(String userId, int dialogId) {
    // First, get fresh data from the server for messages
    FirebaseFirestore.instance
        .collection('dialogs')
        .doc(userId)
        .collection('userDialogs')
        .doc(dialogId.toString()) // Dialog document ID
        .collection('messages') // Subcollection of messages inside each dialog
        .orderBy('sentAt', descending: true)
        .get(const GetOptions(source: Source.server))  // Force fetch from server
        .then((snapshot) {
      // You can process fresh data if needed
      // Optionally, process the fetched data here.
      // This ensures the app gets a fresh snapshot of messages before listening.
    });

    // Then, listen to future updates in real-time with snapshots
    return FirebaseFirestore.instance
        .collection('dialogs')
        .doc(userId)
        .collection('userDialogs')
        .doc(dialogId.toString())
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots()
        .debounceTime(const Duration(milliseconds: 500)) // Optional
        .map((snapshot) => snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList());
  }

  // Function to add a new Dialog with new Message
  static Future<void> addNewDialogWithMessage(String userId, DialogModel dialog, MessageModel message) async {
    try {
      // 1. Add the new dialog to Firestore
      DocumentReference dialogRef = await FirebaseFirestore.instance
          .collection('dialogs')
          .doc(userId) // User document ID
          .collection('userDialogs') // Subcollection for user dialogs
          .add(dialog.toJson()); // Add dialog data

      // 2. Add the first message to the messages subcollection in the dialog
      await dialogRef.collection('messages').add({
        'chatId': dialog.id,
        'isResponse': message.isResponse,
        'isRead': message.isRead,
        'isPushed': message.isPushed,
        'isFile': message.isFile,
        'message': message.message,
        'readAt': message.readAt,
        'sentAt': message.sentAt.toIso8601String(), // Ensure the sentAt is in the correct format
      });

      print("Dialog and message added successfully");
    } catch (e) {
      print("Error adding dialog and message: $e");
      // Optionally, handle errors here, such as network issues
    }
  }

  // Function to add a new Message to an existing Dialog
  static Future<void> addNewMessageToDialog(String userId, String dialogId, MessageModel message) async {
    try {
      // 1. Reference the dialog in Firestore
      DocumentReference dialogRef = FirebaseFirestore.instance
          .collection('dialogs')
          .doc(userId) // User document ID
          .collection('userDialogs') // Subcollection of user dialogs
          .doc(dialogId.toString()); // Specific dialog ID

      // 2. Add the new message to the messages subcollection
      await dialogRef.collection('messages').add({
        'chatId': dialogId,
        'isResponse': message.isResponse,
        'isRead': message.isRead,
        'isPushed': message.isPushed,
        'isFile': message.isFile,
        'message': message.message,
        'readAt': message.readAt,
        'sentAt': message.sentAt.toIso8601String(), // Make sure sentAt is in ISO8601 string format
      });

      print("New message added successfully to dialog $dialogId");
    } catch (e) {
      print("Error adding message: $e");
      // Optionally handle errors (e.g., network issues)
    }
  }



  static checkIfFromCache() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('dialogs')
        .get();

    print("From cache? ${snapshot.metadata.isFromCache}");
  }
}
