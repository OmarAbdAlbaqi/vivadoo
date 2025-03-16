import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  /// Add or update user info when logging in
  Future<void> addUser(String userId, String name) async {
    final userRef = _firestore.collection('users').doc(userId);
    final userData = {
      'name': name,
      'lastActive': FieldValue.serverTimestamp(),
    };

    await userRef.set(userData, SetOptions(merge: true));
  }

  /// Get User Info
  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    final userRef = _firestore.collection('users').doc(userId);
    final docSnapshot = await userRef.get();

    if (docSnapshot.exists) {
      return docSnapshot.data();
    }
    return null;
  }

  /// Get the list of users the logged-in user has chatted with
  Stream<List<Map<String, dynamic>>> getChatInbox(String userId) {
    return _firestore
        .collection('chats')
        .where('userIds', arrayContains: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<Map<String, dynamic>> chatList = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        data['chatId'] = doc.id;

        // Get the receiver's ID (other user in the chat)
        String receiverId =
        (data['userIds'][0] == userId) ? data['userIds'][1] : data['userIds'][0];

        // Fetch receiver details
        final receiverData = await getUserInfo(receiverId);
        data['receiverName'] = receiverData?['name'] ?? "Unknown User";
        data['receiverPic'] = receiverData?['profilePic'] ?? "";

        chatList.add(data);
      }
      return chatList;
    });
  }

  /// Send a message
  Future<void> sendMessage(String senderId, String receiverId, String message) async {
    String chatId = senderId.hashCode <= receiverId.hashCode
        ? '${senderId}_$receiverId'
        : '${receiverId}_$senderId';

    final chatRef = _firestore.collection('chats').doc(chatId);
    final messageRef = chatRef.collection('messages').doc();

    // Add message to messages collection
    await messageRef.set({
      'senderId': senderId,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update chat metadata (increase unread count for the receiver)
    await chatRef.set({
      'userIds': [senderId, receiverId],
      'lastMessage': message,
      'timestamp': FieldValue.serverTimestamp(),
      'unreadCount.$receiverId': FieldValue.increment(1), // Increase unread count for receiver
    }, SetOptions(merge: true));
  }


  /// Get messages for a chat
  Stream<List<Map<String, dynamic>>> getMessages(String senderId, String receiverId) {
    String chatId = senderId.hashCode <= receiverId.hashCode
        ? '${senderId}_$receiverId'
        : '${receiverId}_$senderId';

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// Reset Unread Count
  Future<void> markMessagesAsRead(String userId, String chatId) async {
    final chatRef = _firestore.collection('chats').doc(chatId);

    await chatRef.update({
      'unreadCount.$userId': 0, // Reset unread count for this user
    });
  }


}