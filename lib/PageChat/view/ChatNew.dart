// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.


import 'package:appmess/service/ChatService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/MessageBubble.dart';

@immutable
class ChatNew extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  const ChatNew({super.key, required this.receiverUserEmail, required this.receiverUserId,});

  @override
  State<ChatNew> createState() => _ChatNew();
}

class _ChatNew extends State<ChatNew> {
  bool visibilityIconButton=false;
  final Color colorChangeIcons = Colors.orangeAccent;
  final ChatService _chatService=ChatService();
  final Color colorChangeTool=Colors.blue;
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
       _messageController.clear();
        scrollToBottom();
      }
  }
  void scrollToBottom() {
        _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeOut,
      );

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
        backgroundColor:Colors.grey,
        appBar:AppBar(
          title: _customTitle(),
          backgroundColor:colorChangeTool ,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.call,color: colorChangeIcons,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.video_camera_back_outlined,color: colorChangeIcons)),
            IconButton(onPressed: (){}, icon: Icon(Icons.menu_open,color: colorChangeIcons)),

          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildMessageList()),
              _customToolChat()
            ],
          ),
        ),
    );
  }

  _customToolChat()=>Container(
    color: colorChangeTool,
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        Visibility(
          // visible: visibilityIconButton,
          child: IconButton(
            icon: Icon(Icons.apps,color:colorChangeIcons ,),
            onPressed: () {},
          ),
        ),
        Visibility(
          // visible: visibilityIconButton,
          child: IconButton(
            icon: Icon(Icons.camera_alt,color:colorChangeIcons),
            onPressed: () {},
          ),
        ),
        Visibility(
          // visible: visibilityIconButton,
          child: IconButton(
            icon: Icon(Icons.image,color:colorChangeIcons),
            onPressed: () {},
          ),
        ),
        Visibility(
          //visible: visibilityIconButton,
          child: IconButton(
            icon:  Icon(Icons.mic,color:colorChangeIcons),
            onPressed: () {},
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.4),
            ),
            child: Center(
              child: TextField(
                onTap: scrollToBottom,
                cursorColor: Colors.black,
                controller:_messageController,
                decoration: InputDecoration(
                    hintText: '  Aa',
                    enabled: true,
                    contentPadding: const EdgeInsets.all( 10),
                    border: InputBorder.none,
                    suffixIcon:IconButton(onPressed:(){}, icon:Icon(Icons.emoji_emotions,color:colorChangeIcons))
                ),
              ),
            ),
          ),
        ),
        IconButton(
            icon:  Icon(Icons.emoji_events_rounded,color:colorChangeIcons,),
            onPressed: sendMessage
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
        CircleAvatar(
          backgroundColor:Colors.white,
          backgroundImage:const AssetImage(
              'assets/imagesgai.jpg'
          ),
          child:Container(),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(widget.receiverUserEmail,style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white
          ),),
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
      return ListView(
        controller: _scrollController,
        children: snapshot.data!.docs.map((e)=>MessageBubble(document: e,colorLeft: colorLeft,colorRight: colorRight,)).toList(),
      );
    });
  }
}






