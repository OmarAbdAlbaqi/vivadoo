import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_model.dart';

class DialogModel {
  final int id;
  final int postId;
  final String status;
  final int unread;
  final String name;
  final String title;
  final String? text;
  final String? timeText;
  final DateTime? time;
  final bool isMarked;
  final bool isFile;
  final String? photo;
  final List<MessageModel> messages;

  DialogModel({
    required this.id,
    required this.postId,
    required this.status,
    required this.unread,
    required this.name,
    required this.title,
    required this.text,
    required this.timeText,
    required this.time,
    required this.isMarked,
    required this.isFile,
    required this.photo,
    required this.messages,
  });

  factory DialogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DialogModel(
      id: int.tryParse(doc.id) ?? 0,
      postId: data['post_id'] ?? 0,
      status: data['status'] ?? 'inbox',
      unread: data['unread'] ?? 0,
      name: data['name'] ?? '',
      title: data['title'] ?? '',
      text: data['text'],
      timeText: data['time_text'],
      time: data['time'] != null ? (data['time'] as Timestamp).toDate() : null,
      isMarked: data['is_marked'] ?? false,
      isFile: data['is_file'] ?? false,
      photo: data['photo'],
      messages: data['messages'] != null
          ? List<MessageModel>.from(
          (data['messages'] as List).map((m) => MessageModel.fromJson(m)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'status': status,
      'unread': unread,
      'name': name,
      'title': title,
      'text': text,
      'time_text': timeText,
      'time': time != null ? Timestamp.fromDate(time!) : null,
      'is_marked': isMarked,
      'is_file': isFile,
      'photo': photo,
    };
  }

  // Add method to update dialog in Firestore
  Future<void> updateDialogInFirestore(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('dialogs')
          .doc(userId)
          .collection('userDialogs')
          .doc(id.toString()) // Using dialog ID as the document ID
          .set(toJson(), SetOptions(merge: true)); // Merge to avoid overwriting existing data
    } catch (e) {
      print('Error updating dialog in Firestore: $e');
    }
  }

  @override
  String toString() {
    return 'DialogModel{id: $id, postId: $postId, status: $status, unread: $unread, name: $name, title: $title, text: $text, timeText: $timeText, time: $time, isMarked: $isMarked, isFile: $isFile, photo: $photo, messages: $messages}';
  }
}
