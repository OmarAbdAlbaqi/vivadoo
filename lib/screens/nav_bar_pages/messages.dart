import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vivadoo/models/auth/user_info_model.dart';
import 'package:vivadoo/models/dialog_model.dart';
import 'package:vivadoo/providers/messages/messages_provider.dart';
import 'package:vivadoo/utils/api_manager.dart';
import 'package:vivadoo/utils/chat_service.dart';
import 'package:vivadoo/utils/pop-ups/pop_ups.dart';

import '../../constants.dart';
import '../../models/message_model.dart';
import '../../services/firebase_service.dart';
import '../../utils/hive_manager.dart';
import '../../widgets/general_widgets/not_signed_in_page.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  final firebaseService = FirebaseService();

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: ValueListenableBuilder<bool>(
          valueListenable: HiveStorageManager.signedInNotifier,
          builder: (context, signedIn, _) {
            if (signedIn) {
              return buildTabBar(context, controller);
            } else {
              return notSignedInPage(context);
            }
          }),
    );
  }
}

Widget buildTabBar(BuildContext context, TabController controller)
{
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Image.asset("assets/images/logo.png" , width: 100,),
          ),
          const SizedBox(width: 8),
          const Text("Chats" , style: TextStyle(fontWeight: FontWeight.w600),),
        ],
      ),
    ),
    body: Column(
      children: [
        Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(24),
          ),
          child: TabBar(
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
        tabBArView(context, controller),
      ],
    ),
  );
}

Widget tabBArView(BuildContext context, TabController controller)
{
  return Expanded(
    child: TabBarView(controller: controller, children: [
      inboxView(context),
      archivedView(context),
    ]),
  );
}

Widget inboxView(BuildContext context)
{
  final userInfoBox = HiveStorageManager.getUserInfoModel();
  String userId = userInfoBox.values.toList().cast<UserInfoModel>()[0].emailAddress;
  return StreamBuilder<List<DialogModel>>(
    stream: ChatService.listenToDialogsFromServer(userId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No dialogs available.'));
      }
      final dialogs = snapshot.data!;
      return
        Column(
        children: [
        ListView.separated(
        shrinkWrap: true,
        itemCount: dialogs.length,
        itemBuilder: (_, index) {
          final DialogModel dialog = dialogs[index];
          return _ChatListItem(
            dialog: dialog,
            isArchived: false,
            onDismissed: (direction) {},
            userId: userId,
          );
        },
        separatorBuilder: (_, index) => const SizedBox(height: 8),
      ),
          // GestureDetector(
          //   onTap: () async {
          //     final response = await ApiManager().startNewDialog('939554', 'Test');
          //     var extractedData = json.decode(response.body);
          //     print(extractedData);
          //   },
          //   child: Container(
          //     margin: const EdgeInsets.all(20),
          //     width: double.infinity,
          //     height: 45,
          //     decoration: BoxDecoration(
          //       color: Colors.black,
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     alignment: Alignment(0, 0),
          //     child: Text("Test" , style: TextStyle(color: Colors.white),),
          //   ),
          // ),
        ],
      );
    },
  );
}

Widget archivedView(BuildContext context) {
  final userInfoBox = HiveStorageManager.getUserInfoModel();
  String userId = userInfoBox.values.toList().cast<UserInfoModel>()[0].key;
  return Selector<MessagesProvider, List<Map<String, String>>>(
    selector: (_, provider) => provider.archivedChats,
    builder: (_, chats, child) {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: chats.length,
        itemBuilder: (_, index) {
          final chat = chats[index];
          return SizedBox();
          //   _ChatListItem(chat: chat, isArchived: false, onDismissed: (direction) {
          //   if (direction == DismissDirection.startToEnd) {
          //     context.read<MessagesProvider>().addOrRemoveFromArchivedChats(chat , isAdd: false);
          //   } else {
          //     context.read<MessagesProvider>().addOrRemoveFromArchivedChats(chat , isAdd: false);
          //     context.read<MessagesProvider>().addOrRemoveFromInboxChat(chat , isAdd: false);
          //   }
          //
          // }, firebaseService: firebaseService , userId: userId,);
        },
        separatorBuilder: (_, index) {
          return const SizedBox(height: 8);
        },
      );
    },
  );
}

class _ChatListItem extends StatelessWidget {
  final DialogModel dialog;
  final bool isArchived;
  final Function(DismissDirection) onDismissed;
  final String userId;

  const _ChatListItem({
    required this.dialog,
    required this.isArchived,
    required this.onDismissed,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final userInfoBox = HiveStorageManager.getUserInfoModel();
        String userId = userInfoBox.values.toList().cast<UserInfoModel>()[0].emailAddress;
        ChatService.updateMessagesInFirestore(userId, dialog.id);
        if (context.mounted) {
          context.push("/messages/chatScreen", extra: {'dialog': dialog});
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Dismissible(
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
            height: 80,
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
            alignment: const Alignment(0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    dialog.photo!,
                    width: 65,
                    height: 65,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 121,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dialog.title,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(dialog.timeText ?? "",
                              style:
                              TextStyle(color: Colors.grey[500], fontSize: 12)),
                        ],
                      ),
                      Text(dialog.text ?? "",
                          style: TextStyle(color: Colors.grey[600])),
                      Text(
                        dialog.name ?? "",
                        style: const TextStyle(
                            color: Constants.orange, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.dialog});

  final DialogModel dialog;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  PersistentBottomSheetController? _bottomSheetController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  WidgetStateProperty<Color> getColor(Color color, Color colorPressed) {
    getColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return WidgetStateProperty.resolveWith(getColor);
  }

  void _toggleBottomSheet(String photo) {
    String base64Str = photo.split(',').last;
    Uint8List imageBytes = base64Decode(base64Str);
    if (_bottomSheetController == null) {
      _bottomSheetController = _scaffoldKey.currentState!.showBottomSheet(
        showDragHandle: true,
        (context) => Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.memory(imageBytes),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  onPressed: () async {
                    final userInfoBox = HiveStorageManager.getUserInfoModel();
                    String userId = userInfoBox.values.toList().cast<UserInfoModel>()[0].emailAddress;
                    ApiManager.postNewImageMessage(widget.dialog.id.toString(),DateTime.now().toString(), photo);
                    MessageModel messageModel = MessageModel(id: DateTime.now().toString(), chatId: widget.dialog.id.toString() , isResponse: true, isRead: false, isPushed: false, isFile: true, message: photo, readAt: DateTime.now(), sentAt: DateTime.now());
                    ChatService.addNewMessageToDialog(
                        userId,
                        widget.dialog.id.toString(),
                        messageModel
                    );
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsets?>(
                        const EdgeInsets.symmetric(horizontal: 20)),
                    minimumSize: WidgetStateProperty.all<Size?>(
                        const Size(double.infinity, 45)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    animationDuration: const Duration(milliseconds: 500),
                    backgroundColor: getColor(Colors.orange, Colors.white),
                    foregroundColor: getColor(Colors.white, Colors.orange),
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      _bottomSheetController!.closed.then((value) {
        _bottomSheetController = null;
      });
    } else {
      _bottomSheetController!.close();
      _bottomSheetController = null;
    }
  }

  @override
  Widget build(BuildContext context) {

    final userInfoBox = HiveStorageManager.getUserInfoModel();
    String userId = userInfoBox.values.toList().cast<UserInfoModel>()[0].emailAddress;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(
            widget.dialog.title,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          children: [
            Divider(
              height: 1,
              color: Colors.grey.withAlpha(50),
            ),
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.dialog.photo!,
                      width: 35,
                      height: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 70,
                      child: Text(
                        widget.dialog.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                  stream: ChatService.listenToMessagesFromServer( userId,widget.dialog.id),
                  builder: (context, snapshot) {
                    print("object");
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Column(
                        children: [
                          Image.asset('assets/icons/post_details_icons/chat.png'),

                        ],
                      ));
                    }
                    final messages = snapshot.data!;
                    return ListView.builder(
                      addAutomaticKeepAlives: true,
                      padding: const EdgeInsets.all(16),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return _MessageBubble(message: messages[index]);
                      },
                    );
                  }),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1),
        ],
      ),
      child: Row(
        children: [
          IconButton(
              onPressed: () async {
                await PopUps.selectPhotoPickType(context, isMessage: true);
                if (context.read<MessagesProvider>().photo.isNotEmpty) {
                  _toggleBottomSheet(context.read<MessagesProvider>().photo);
                }
              },
              icon: const Icon(Icons.add)),
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: 'Message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () async {
              final userInfoBox = HiveStorageManager.getUserInfoModel();
              String userId = userInfoBox.values.toList().cast<UserInfoModel>()[0].emailAddress;
              if (_messageController.text.isNotEmpty) {
                String message = _messageController.text;
                ApiManager.postNewMessage(widget.dialog.id.toString(), message);

                MessageModel messageModel = MessageModel(id: DateTime.now().toString(), chatId: widget.dialog.id.toString() , isResponse: true, isRead: false, isPushed: false, isFile: false, message: message, readAt: DateTime.now(), sentAt: DateTime.now());
                ChatService.addNewMessageToDialog(
                  userId,
                  widget.dialog.id.toString(),
                  messageModel
                );
                // var extractedData = jsonDecode(response.body);
                _messageController.clear(); // Clear the input
              }
            },
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;

  const _MessageBubble({required this.message});

  String formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final difference = today.difference(messageDate).inDays;

    if (difference == 0) {
      // Same day
      return DateFormat('h:mm a').format(dateTime); // Example: 10:39 AM
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (now.year == dateTime.year) {
      return DateFormat('MMM d').format(dateTime); // Example: Apr 5
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime); // Example: Apr 5, 2024
    }
  }

  Uint8List getPhoto(){
    return Uint8List.fromList(
        List<int>.from(jsonDecode(message.message))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      alignment:
          message.isResponse ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isResponse ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: message.isResponse
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: message.isResponse
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
        ),
        child: message.isFile ? 
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child:  Image.memory(base64Decode(message.message))
                ),
                const SizedBox(height: 4),
                Text(
                  formatMessageTime(message.sentAt),
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message.message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              formatMessageTime(message.sentAt),
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
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
