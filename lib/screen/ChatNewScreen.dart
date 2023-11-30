import 'dart:async';
import 'dart:io';

import 'package:appmess/api/Api.dart';
import 'package:appmess/extention/SystemUiStyleHelper.dart';

import 'package:appmess/provider/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:appmess/models/Message.dart';
import '../provider/HideTitleChatScreen.dart';
import '../provider/ShowEmoji.dart';
import '../provider/ShowImageGallery.dart';
import '../provider/ShowKeyBoard.dart';
import '../provider/processingListMessage.dart';
import '../provider/processingListMessageSeen.dart';
import '../provider/updateCheckConnect.dart';
import '../service/ChatService.dart';
import '../utils/responsive.dart';
import '../widgets/MessageBubble.dart';
import '../widgets/UpdateConnection.dart';
import '../widgets/imageGallery.dart';
import '../widgets/userAvatar.dart';
import 'package:lottie/lottie.dart';


class ChatNewScreen extends StatefulWidget {
  final String receiverUserId;
  final String receiverName;
  final String fileImage;
  final String senderName;
  final List<String> senderTokenDevice;
  final List<String> receiverTokenDevice;
  final bool isOnline;
  const ChatNewScreen({super.key, required this.receiverUserId, required this.receiverName, required this.fileImage, required this.receiverTokenDevice, required this.senderName, required this.senderTokenDevice, required this.isOnline});

  @override
  State<ChatNewScreen> createState() => _ChatNewScreenState();
}

class _ChatNewScreenState extends State<ChatNewScreen> {
  final ChatService _chatService = ChatService();
  final Color colorChangeIcons = Colors.orangeAccent;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerWidgetsMain = ScrollController();
  late ColorTheme colorTheme;
  List<String> emojiList = ['😀', '😎', '🚀', '🌟', '🥳'];
  late ShowKeyBoard showKeyBoard;
  late ShowImageGallery showImageGallery;
  final TextEditingController _messageController = TextEditingController();
  late ShowEmoji showEmoji;
  late ProcessingListMessageSeen processingListMessageSeen;
  late ProcessingListMessage processingListMessage;
  late HideTitleChatScreen hideTitleChatScreen;
  late StreamSubscription<bool> keyboardSubscription;
  var keyboardVisibilityController = KeyboardVisibilityController();

  final List<Color> colorLeft = [
    const Color(0xFF6C7689),
    const Color(0xFF3A364B)
  ];
  final List<Color> colorRight = [Colors.purple, Colors.blue];
  @override
  void initState() {
    showKeyBoard  = Provider.of<ShowKeyBoard>(context, listen: false);
    showEmoji  = Provider.of<ShowEmoji>(context, listen: false);
    hideTitleChatScreen  = Provider.of<HideTitleChatScreen>(context, listen: false);
    colorTheme  = Provider.of<ColorTheme>(context, listen: false);
    processingListMessageSeen  = Provider.of<ProcessingListMessageSeen>(context, listen: false);
    processingListMessage  = Provider.of<ProcessingListMessage>(context, listen: false);
    showImageGallery  = Provider.of<ShowImageGallery>(context, listen: false);
    hideTitleChatScreen.toggleShow();
    ChatService.createRoomChat(receiverId: widget.receiverUserId,
        statusSender: true,
        statusReceiver: widget.isOnline);
    ChatService.updateMessageSeen(seen: true,
        userId: Apis.firebaseAuth.currentUser!.uid,
        otherUserId: widget.receiverUserId);
    keyboardSubscription =keyboardVisibilityController.onChange.listen((bool visible) {
       if(!visible)
         {
           showKeyBoard.toggleChangeState2();
         }
    });
    _scrollController.addListener(_scrollListenerListView);
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    _scrollControllerWidgetsMain.dispose();
    _messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    colorTheme = Provider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemUiStyleHelper.setSystemUiOverlayStyle(
        Colors.transparent);
    });
    return WillPopScope(
      onWillPop: () {
        if (showEmoji.isShowEmoji) {
          showEmoji.toggleChangeState2();
          return Future.value(false);
        }
        else if(showImageGallery.isShowImageGallery)
        {
          showImageGallery.toggleChangeState2();
          return Future.value(false);
        }
        else if(showKeyBoard.isShowKeyBoard)
        {
          showKeyBoard.toggleChangeState2();
          return Future.value(false);
        }
        // else if(processingListMessage.messages.length<=7)
        // {
        // hideTitleChatScreen.toggleHide();
        // return Future.value(false);
        // }
        else{
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SystemUiStyleHelper.setSystemUiOverlayStyle(
              Colors.transparent,);
          });
          return Future.value(true);
        }

      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:Theme.of(context).colorScheme.background==Colors.black
              ? const Color(0xFF0D0D0D)
              : const Color(0xFF9EE1EC).withOpacity(0.5),
          title: _customTitle(),
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          },
            icon: Icon(Icons.arrow_back_ios,
              color: colorTheme.colorIconAppBarChatScreen,),),
          automaticallyImplyLeading: false,
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          shadowColor: Colors.blue,
          actions: [
            IconButton(onPressed: () {},
                icon: Icon(Icons.call,
                  color: colorTheme.colorIconAppBarChatScreen,)),
            IconButton(onPressed: () {
              //  Navigator.push(context, MaterialPageRoute(builder: (_)=>const PageCallVideo()));
            },
                icon: Icon(Icons.video_camera_back_outlined,
                    color: colorTheme.colorIconAppBarChatScreen)),
            IconButton(onPressed: () {
              // Navigator.push(context,MaterialPageRoute(builder: (_)=>ChangeOptionRoomChatScreen(fileImage: widget.fileImage)));
            },
                icon: Icon(Icons.menu_open,
                    color: colorTheme.colorIconAppBarChatScreen)),
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image:DecorationImage(
                    image:
                        AssetImage(Theme.of(context).colorScheme.background==Colors.black
                            ?'assets/ThemeDart.png'
                            :'assets/ThemeLight.png'),
                    fit:BoxFit.cover

                )
              ),
            ),
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _scrollControllerWidgetsMain,
              child:Column(
                children: [
                  SizedBox(
                    height: Responsive.getHeight(context)*.84,
                    child: _buildMessageList(),
                  ),
                  _customToolChat(),
                  _showEmoji(),
                  _showLibraryImage(),
                  _showKeyBoard()
                ],
              ),
            ),
            const UpdateConnection()
          ],

        ),

      ),
    );
  }


  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
        stream: _chatService.getMessages(
            widget.receiverUserId, Apis.firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('error ${snapshot.error.toString()}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('.....Loading');
          }

          List<Map<String, dynamic>> messageList = snapshot.data!.docs.map((
              doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();

          if(messageList.isEmpty)
          {
            ChatService.firstMessage(receiverId: widget.receiverUserId);
          }

          processingListMessage.toggleAddData(messageList);

          List<Map<String, dynamic>> messageSeenList = context
              .read<ProcessingListMessage>()
              .messages
              .where((data) =>
          data['seen'] == true &&
              data['senderId'] == Apis.firebaseAuth.currentUser!.uid)
              .toList();

          processingListMessageSeen.setDataListMessageSeen(
              messageSeenList);

          if(messageList.length<=3)
            {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                hideTitleChatScreen.toggleHide();
              });
            }

          return GestureDetector(
            onTap:_turnOffTypeMessageChat ,
            child: Consumer<ProcessingListMessage>(
                builder: (context, processingMessage, _) {
                  ChatService.updateMessageSeen(seen: true,
                      userId: Apis.firebaseAuth.currentUser!.uid,
                      otherUserId: widget.receiverUserId);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollToBottom();
                  });
                  return ListView.builder(
                     reverse: true,
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: processingMessage.messages.length,
                    itemBuilder: (context, index) {
                      return
                        processingMessage.messages.isEmpty
                      ?
                      Container(
                        margin: const EdgeInsets.only(top:40),
                        padding:const EdgeInsets.all(20),
                        child: Lottie.network('https://lottie.host/cf2ddbb1-0aae-4fd0-9b15-efaf972bfbdc/p4d5kvWepS.json',height:150,width: 100,fit: BoxFit.cover),
                      )
                      :index==processingMessage.messages.length-1
                          ? customFirstMessage(processingMessage)
                          :GestureDetector(
                            onLongPress:()
                            {
                              showBottomSheet(processingMessage.messages.length-index, processingMessage.messages[index]);
                            },
                            onTap: ()
                            {
                              ChatService.removeMessageExpression(expression: '', userId: Apis.firebaseAuth.currentUser!.uid, otherUserId:widget.receiverUserId, message: processingMessage.messages[index]);
                            },
                            child: MessageBubble(key: UniqueKey(),
                              data: processingMessage.messages[index],
                              colorLeft: colorLeft,
                              colorRight: colorRight,
                              fileImage: widget.fileImage,
                              index: index,
                              indexMax: snapshot.data!.docs.length,
                              receiverUserId: widget.receiverUserId,
                              isOnline: widget.isOnline,
                              contentMessageSeenMax: context.read<
                                  ProcessingListMessageSeen>()
                                  .contentMessageSeenIndexMax(),
                              dataNext: index >= 0 &&
                                  index <= processingMessage.messages.length - 2
                                  ? processingMessage.messages[index + 1]
                                  : processingMessage.messages[index],),
                          );
                    },
                  );
                }),
          );
        });
  }

  void scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  } void scrollToBottomWidgetsMain() {
    _scrollControllerWidgetsMain.jumpTo(_scrollControllerWidgetsMain.position.maxScrollExtent);
  }

  _customToolChat() =>
      Container(
        height: Responsive.getHeight(context) * .05,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    showImageGallery.toggleChangeState1();
                    showEmoji.toggleChangeState2();
                    Timer(const Duration(milliseconds: 100), () {
                      showKeyBoard.toggleChangeState2();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollToBottomWidgetsMain();
                      });
                    });
                    if(hideTitleChatScreen.hide)
                      {
                        hideTitleChatScreen.toggleShow();
                      }
                  },
                  child: const Center(
                      child: Icon(Icons.image, color: Colors.blue,)),
                )
            ),
            Container(
              height: 40,
              width: 243,
              margin: const EdgeInsets.only(left: 30),
              decoration:  BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left:10,right:10),
                        child: TextField(
                          onTap: () {
                            if(!showKeyBoard.isShowKeyBoard) {
                              showKeyBoard.toggleChangeState1();
                              showEmoji.toggleChangeState2();
                              showImageGallery
                                  .toggleChangeState2();
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                scrollToBottomWidgetsMain();
                              });
                            }
                            if(hideTitleChatScreen.hide)
                            {
                              hideTitleChatScreen.toggleShow();
                            }
                          },
                          //
                          onChanged: (value) {
                          },
                          cursorColor: Colors.black,
                          controller: _messageController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 1,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Send a message",

                          ),

                        ),
                      )


                  ),
                  IconButton(onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    showEmoji.toggleChangeState1();
                    showImageGallery.toggleChangeState2();
                    Timer(const Duration(milliseconds: 120), () {
                      showKeyBoard.toggleChangeState2();


                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollToBottomWidgetsMain();
                      });
                    });
                    if(hideTitleChatScreen.hide)
                    {
                      hideTitleChatScreen.toggleShow();
                    }
                  },
                      icon: const Icon(
                        Icons.emoji_emotions_outlined, color: Colors.blue,)),

                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15)
              ),
              child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue,),
                  onPressed: sendMessage
              ),
            ),
          ],
        ),
      );

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      List<String> messages = [_messageController.text];
      processingListMessage.addFakeMessage(
          receiverId: widget.receiverUserId,
          message: messages,
          tokenDeviceReceivers: widget.receiverTokenDevice,
          receiverName: widget.receiverName,
          type: Type.text,
          tokenDeviceSender: widget.senderTokenDevice,
          senderName: widget.senderName,
          senderId: Apis.firebaseAuth.currentUser!.uid,
          expression:'');
      if (context
          .read<UpdateCheckConnect>()
          .connection) {
        Timer(const Duration(milliseconds: 10), () async {
          await ChatService.sendMessage(receiverId: widget.receiverUserId,
              message: messages,
              tokenDeviceReceivers: widget.receiverTokenDevice,
              receiverName: widget.receiverName,
              type: Type.text,
              tokenDeviceSender: widget.senderTokenDevice,
              senderName: widget.senderName,
              senderId: Apis.firebaseAuth.currentUser!.uid);
        });
      }
      _messageController.clear();
    }
    hideTitleChatScreen.toggleShow();
  }

  Widget _customTitle() =>
      Consumer<HideTitleChatScreen>(
          builder: (context, value,_) {
            return !value.hide
                ?Row(
              children: [
                UserAvatar(
                  fileName: widget.fileImage, radius: 40, isOnline: widget.isOnline,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Text(widget.receiverName, style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Text(widget.isOnline ? 'Đang hoạt động ' : '',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),),
                    )
                  ],
                )
              ],)
                :const SizedBox.shrink();
          });
  _showEmoji() =>
      Consumer<ShowEmoji>(
          builder: (context, showEmoji, _) {
            return showEmoji.isShowEmoji ?
            SizedBox(
              height: Responsive.getHeight(context) * .4,
              child: EmojiPicker(
                textEditingController: _messageController,
                config: Config(
                  bgColor: const Color.fromARGB(255, 234, 248, 255),
                  columns: 8,
                  emojiSizeMax: 28 * (Platform.isIOS ? 1.30 : 1.0),
                ),
              ),
            )
                : const SizedBox.shrink();
          });

  _showLibraryImage() =>
      Consumer<ShowImageGallery>(
          builder: (context, showImageGallery, _) {
            return showImageGallery.isShowImageGallery ?
            SizedBox(
              height:Responsive.getHeight(context) * .4,
              child: ImageGallery(receiverId: widget.receiverUserId,
                  tokenDeviceReceivers: widget.receiverTokenDevice,
                  receiverName: widget.receiverName,
                  tokenDeviceSender: widget.senderTokenDevice,
                  senderName: widget.senderName),
            )
                : const SizedBox.shrink();
          });



  _showKeyBoard() =>
      Consumer<ShowKeyBoard>(
          builder: (context, showKeyBoard, _) {
            return showKeyBoard.isShowKeyBoard ?
            SizedBox(
              height: Responsive.getHeight(context) * .4,
              child: const SizedBox.shrink()
            )
                : const SizedBox.shrink();
          });


  void _turnOffTypeMessageChat() {
    if (showEmoji.isShowEmoji) {
      showEmoji.toggleChangeState2();
    }
    else if(showImageGallery.isShowImageGallery)
    {
      showImageGallery.toggleChangeState2();
    }
    else if(showKeyBoard.isShowKeyBoard)

    {
      FocusManager.instance.primaryFocus?.unfocus();
      showKeyBoard.toggleChangeState2();
    }
    if(processingListMessage.messages.isNotEmpty)
      {
          hideTitleChatScreen.toggleHide();
      }
  }
  showBottomSheet(int index,Map<String, dynamic> message) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent.withAlpha(0),
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SizedBox(
          height: index <= 3
              ? Responsive.getHeight(context) * .3
              : Responsive.getHeight(context) * .08 * index,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 260,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: emojiList.map((emoji) {
                    return GestureDetector(
                      onTap: ()
                      {
                        ChatService.updateMessageExpression(expression: emoji, userId:Apis.firebaseAuth.currentUser!.uid, otherUserId:widget.receiverUserId,message:message);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 24.0),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                color: Theme
                    .of(context)
                    .primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    itemOption(icon: Icons.reply, nameTitle: 'Reply'),
                    itemOption(icon: Icons.copy, nameTitle: 'Copy'),
                    itemOption(icon: Icons.paste_rounded, nameTitle: 'Pin'),
                    itemOption(icon: Icons.more_horiz, nameTitle: 'More'),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

    itemOption({required IconData icon,required String nameTitle})=>Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(nameTitle),
      )
    ],
  );

  customFirstMessage(ProcessingListMessage processingMessage)=>Container(
    margin: const EdgeInsets.only(top:40),
    padding:const EdgeInsets.all(20),
    child: Column(
      children: [
        UserAvatar(
          fileName: widget.fileImage, radius: 100, isOnline: widget.isOnline,size: 20,),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 4),
          child: Text(widget.receiverName, style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary
          ),),
        ),
        Lottie.network('https://lottie.host/cf2ddbb1-0aae-4fd0-9b15-efaf972bfbdc/p4d5kvWepS.json',height:200,width: 200,fit: BoxFit.cover),
        Text(processingMessage.messages[processingMessage.messages.length-1]['message'].toString()),
      ],
    ),
  );
  void _scrollListenerListView() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final firstItemPosition = renderBox.localToGlobal(Offset.zero).dy;
    if (_scrollController.offset >= firstItemPosition + 200) {
      hideTitleChatScreen.toggleShow();
    }
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      hideTitleChatScreen.toggleHide();
    }
    if (_scrollController.offset <=
        _scrollController.position.minScrollExtent) {

      hideTitleChatScreen.toggleShow();
    }
  }

}




