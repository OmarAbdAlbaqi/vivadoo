import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';
import 'package:vivadoo/providers/messages/messages_provider.dart';
import 'package:vivadoo/providers/my_vivadoo_providers/auth/user_info_provider.dart';
import 'package:vivadoo/providers/my_vivadoo_providers/my_vivadoo_profile_provider.dart';

import '../../constants.dart';
import '../../services/firebase_service.dart';
import '../../utils/hive_manager.dart';
import '../../widgets/general_widgets/not_signed_in_page.dart';
import '../../widgets/my_vivadoo_widgets/enrolling_page.dart';
class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> with SingleTickerProviderStateMixin {
  late TabController controller;
  final firebaseService = FirebaseService();

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // bool isLoggedIn = HiveStorageManager.signedInNotifier.value
    return SafeArea(
      top: true,
      child: ValueListenableBuilder<bool>(
        valueListenable: HiveStorageManager.signedInNotifier,
        builder: (context, signedIn, _) {
          if(signedIn){
            return buildTabBar(context,controller , firebaseService);
          }else{
            return notSignedInPage(context);

          }

        }
      ),
    );
  }
}


Widget buildTabBar(BuildContext context , TabController controller, FirebaseService firebaseService) {
  return Column(
    children: [
    Container(
    height: 48,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(24),
    ),
      child:  TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: const BoxDecoration(
          color: Constants.orange,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        tabs: const [
           TabItem(title: 'Inbox'),
           TabItem(title: 'Archived'),
        ],
      ),
    ),
      tabBArView(context, controller , firebaseService),
    ],

    );
}

Widget tabBArView(BuildContext context , TabController controller, FirebaseService firebaseService){
  return Expanded(
    child:
  TabBarView(
    controller: controller,
      children: [
        inboxView(context , firebaseService),
        archivedView(context , firebaseService),
      ]),
  );
}

Widget inboxView(BuildContext context , FirebaseService firebaseService){
  final userInfoBox = HiveStorageManager.getUserInfoModel();
  String userId = userInfoBox.values.toList().cast<UserInfoModel>()[0].key;
  return StreamBuilder(
    stream: firebaseService.getChatInbox(userId),
    builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
      if (!snapshot.hasData) return const CircularProgressIndicator();
      List<Map<String, dynamic>> chats = snapshot.data!;
      return ListView.separated(
        shrinkWrap: true,
        itemCount: chats.length,
        itemBuilder: (_ , index){
          final chat = chats[index];
          return _ChatListItem(chat: chat, isArchived: false, onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                // context.read<MessagesProvider>().addOrRemoveFromArchivedChats(chat , isAdd: true);
              } else {
                // context.read<MessagesProvider>().addOrRemoveFromInboxChat(chat , isAdd: false);
              }
      
          }, firebaseService: firebaseService,userId: userId,);
        },
        separatorBuilder: (_ , index){
          return const SizedBox(height: 8);
        },
      );
    }
  );
}

Widget archivedView(BuildContext context , FirebaseService firebaseService){
  final userInfoBox = HiveStorageManager.getUserInfoModel();
  String userId = userInfoBox.values.toList().cast<UserInfoModel>()[0].key;
  return Selector<MessagesProvider , List<Map<String , String>>>(
    selector: (_ , provider) => provider.archivedChats,
    builder: (_ , chats , child){
      return ListView.separated(
        shrinkWrap: true,
        itemCount: chats.length,
        itemBuilder: (_ , index){
          final chat = chats[index];
          return _ChatListItem(chat: chat, isArchived: false, onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              context.read<MessagesProvider>().addOrRemoveFromArchivedChats(chat , isAdd: false);
            } else {
              context.read<MessagesProvider>().addOrRemoveFromArchivedChats(chat , isAdd: false);
              context.read<MessagesProvider>().addOrRemoveFromInboxChat(chat , isAdd: false);
            }

          }, firebaseService: firebaseService , userId: userId,);
        },
        separatorBuilder: (_ , index){
          return const SizedBox(height: 8);
        },
      );
    },
  );
}


class _ChatListItem extends StatelessWidget {
  final Map<String, dynamic> chat;
  final bool isArchived;
  final Function(DismissDirection) onDismissed;
  final FirebaseService firebaseService;
  final String userId;

  const _ChatListItem({
    required this.chat,
    required this.isArchived,
    required this.onDismissed, required this.firebaseService, required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: isArchived ? Colors.green : Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          isArchived ? Icons.unarchive : Icons.archive,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: onDismissed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 28,
            child: Image.asset("assets/images/vivadoo.png" , width: 35,),
          ),
          title: Text(chat['receiverName'],
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(chat['lastMessage'],
              style: TextStyle(color: Colors.grey[600])),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(chat['timestamp'].toDate().toString(),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(4),
                decoration:
                const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
                child: const Text('',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen(chat: chat , firebaseService: firebaseService, userId: userId,)),
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> chat;
  final FirebaseService firebaseService;
  final String userId;

  const ChatScreen({super.key, required this.chat, required this.firebaseService, required this.userId});

  @override
  State<ChatScreen>  createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    String receiverId =
    (widget.chat['userIds'][0] == widget.userId) ? widget.chat['userIds'][1] : widget.chat['userIds'][0];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              child: Image.asset("assets/images/vivadoo.png" , width: 35,),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chat['name']!,
                    style: const TextStyle(color: Colors.black, fontSize: 16)),
                // const Text('Active now',
                //     style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //       icon: const Icon(Icons.video_call, color: Colors.black),
        //       onPressed: () {}),
        //   IconButton(
        //       icon: const Icon(Icons.call, color: Colors.black), onPressed: () {}),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: widget.firebaseService.getMessages(widget.userId, receiverId),
                builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  List<Map<String, dynamic>> messages = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _MessageBubble(message: messages[index]['text']);
                  },
                );
              }
            ),
          ),
          _buildMessageInput(widget.userId , receiverId),
        ],
      ),
    );
  }

  Widget _buildMessageInput(String senderId , String receiverId ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1)
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                setState(() {
                  FirebaseService().sendMessage(senderId, receiverId, _messageController.text);
                  // _messages.add(Message(
                  //   text: _messageController.text,
                  //   isSentByMe: true,
                  //   time: DateTime.now().toString().substring(11, 16),
                  // ));
                  _messageController.clear();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}




class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      alignment:
      message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isSentByMe ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
            message.isSentByMe ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight:
            message.isSentByMe ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message.text, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isSentByMe;
  final String time;

  Message({required this.text, required this.isSentByMe, required this.time});
}

class TabItem extends StatelessWidget {
  final String title;

  const TabItem({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}