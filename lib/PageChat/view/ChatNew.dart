



import 'dart:developer';

import 'package:appmess/service/ChatService.dart';
import 'package:appmess/test_library/NotificationController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/MessageBubble.dart';

@immutable
class ChatNew extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  final List<String> receiverTokenDevice;
  const ChatNew({super.key, required this.receiverUserEmail, required this.receiverUserId, required this.receiverTokenDevice,});

  @override
  State<ChatNew> createState() => _ChatNew();
}

class _ChatNew extends State<ChatNew> {
  bool visibilityIconButton=false;
  final Color colorChangeIcons = Colors.orangeAccent;
   late      bool clickBtnAdd=false;
  final ChatService _chatService=ChatService();
  final Color colorChangeTool=Colors.white;
  final TextEditingController _messageController=TextEditingController();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final List<Color> colorLeft=[const Color(0xFF6C7689), const Color(0xFF3A364B)];
  final List<Color> colorRight=[Colors.blue, Colors.indigoAccent];
  final ScrollController _scrollController=ScrollController();

  Future<void> sendMessage()
  async {
    if(_messageController.text.isNotEmpty)
      {
        //
        await _chatService.sendMessage(widget.receiverUserId, _messageController.text);
        scrollToBottom();
        sendMessageWithToken();
        _messageController.clear();
      }

  }
  void scrollToBottom() {
        _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeOut,
      );

  }
  void sendMessageWithToken()
  {
    for(var token in widget.receiverTokenDevice)
    {
      NotificationController.sendAndroidNotification('Đỗ Đăng Trường',_messageController.text,token);

    }
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        backgroundColor:colorChangeTool,
        appBar:AppBar(
          title: _customTitle(),
          backgroundColor:colorChangeTool,
          automaticallyImplyLeading: false,
          shape:const ContinuousRectangleBorder(
        borderRadius:BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20))),
          shadowColor: Colors.blue,
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.call,color: colorChangeIcons,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.video_camera_back_outlined,color: colorChangeIcons)),
            IconButton(onPressed: (){}, icon: Icon(Icons.menu_open,color: colorChangeIcons)),

          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: InkWell(
                onTap: ()
                {
                  setState(() {
                    clickBtnAdd=false;
                  });
                },
                child: Stack(
                  children: [
                     _buildMessageList(),
                    clickBtnAdd ?
                        Positioned(
                          bottom: 0,
                          left: 35,
                          child: Container(
                            width: 152,
                            height: 56,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.only(topRight:Radius.circular(20),topLeft:Radius.circular(20),bottomRight: Radius.circular(20) )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color:Colors.blue,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: IconButton(onPressed:(){}, icon: Icon(Icons.image,color: colorChangeIcons,size:24))),
                                const SizedBox(width: 20,),
                                Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color:Colors.blue,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: IconButton(onPressed:(){}, icon: Icon(Icons.link,color: colorChangeIcons,size: 24,))),
                              ],
                            ),
                          )
                        ):Container()

                  ],
                ),
              ),
            ),

                _customToolChat(),


          ],
        ),

    );
  }

  _customToolChat()=>Container(
    height:56 ,
    width:double.infinity,
    color:  Colors.grey[50],
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
          ),
          // visible: visibilityIconButton,
          child: IconButton(
            icon: Icon(Icons.add,color:colorChangeIcons ,),
            onPressed: () {
              setState(() {
                clickBtnAdd=true;
              });
            },
          ),
        ),
        Container(
          height: 40,
          width: 243,
          margin: const EdgeInsets.only(left:30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Center(
            child: TextField(
              onTap: scrollToBottom,
              cursorColor: Colors.black,
              controller:_messageController,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              minLines: 1,
              decoration:  const InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15)
          ),
          child: IconButton(
              icon:  Icon(Icons.send,color:colorChangeIcons,),
              onPressed: sendMessage
          ),
        ),
      ],
    ),
  );
  Widget _customTitle()=>
      Row(children: [
        IconButton(onPressed:()
        {
          Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back_ios,color:colorChangeIcons,),),
        Stack(
          children: [
            CircleAvatar(
              backgroundColor:Colors.white,
              backgroundImage:const AssetImage(
                  'assets/imagesgai.jpg'
              ),
              child:Container(),
            ),
                Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 10,
                height: 10,
                padding: const EdgeInsets.all(3),
                decoration:  const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                ),))
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8,top: 4),
              child: Text(widget.receiverUserEmail,style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black
              ),),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8,top: 4),
              child: Text('Đang hoạt động ',style: TextStyle(fontSize: 13,color: Colors.grey),),
            )
          ],
        )
      ],);
  Widget _buildMessageList()
  {
    return StreamBuilder(stream:_chatService.getMessages(widget.receiverUserId,_auth.currentUser!.uid),builder:(context,snapshot)
    {
      if(snapshot.hasError)
        {
          return Text('error ${snapshot.error.toString()}');
        }
      if(snapshot.connectionState==ConnectionState.waiting)
        {
          return const Text('.....Loading');
        }

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        scrollToBottom();
      });

      return ListView.builder(
        controller: _scrollController,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          final document = snapshot.data!.docs[index];
          return MessageBubble(document: document, colorLeft: colorLeft, colorRight: colorRight);
        },
      );
    });
  }
  _builderBottomSheet(BuildContext context)
  {
    return showModalBottomSheet(context: context, builder:(context)
    {
      double gridWidth = 100;
      double gridHeight = 100;
      double ratio = gridWidth / gridHeight;
      return GridView.count(childAspectRatio: ratio,
          crossAxisCount: 3,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          children:const []);
    });
  }
}






