import 'dart:developer';

import 'package:appmess/service/ChatService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:appmess/models/Message.dart';

import '../api/Api.dart';

class ViewImageScreen extends StatefulWidget {
  final String receiverUserId;
  final String image;
  const ViewImageScreen({super.key, required this.receiverUserId, required this.image});

  @override
  State<ViewImageScreen> createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> {
  final ChatService _chatService = ChatService();
  final PageController  _scrollController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Xử lý khi người dùng bấm nút Tải Xuống
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Xử lý khi người dùng bấm nút Chỉnh Sửa
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_road_sharp),
            onPressed: () {
              // Xử lý khi người dùng bấm nút Cài Đặt
            },
          ),
        ],
      ),
      body: _buildMessageList(),

    );
  }
  Widget _buildMessageList()
  {
    return StreamBuilder<QuerySnapshot>(stream:_chatService.getMessages(widget.receiverUserId,Apis.firebaseAuth.currentUser!.uid),builder:(context,snapshot)
    {
      if(snapshot.hasError)
      {
        return Text('error ${snapshot.error.toString()}');
      }
      if(snapshot.connectionState==ConnectionState.waiting)
      {
        return const Text('.....Loading');
      }
      final filteredDocs = snapshot.data!.docs.where((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final typeMessage = data['typeMessage'].toString();
        return typeMessage == Type.image.name;
      }).toList();
      final messages = filteredDocs.expand((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['message'];
      }).toList();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollIndexImage(messages);
      });
      return PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.all(30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: PageView(
                  children: [
                    Image(
                      image: AdvancedNetworkImage(
                        messages[index],
                        useDiskCache: true,
                        cacheRule: const CacheRule(maxAge: Duration(days: 1)),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
  void scrollIndexImage(List<dynamic> messages)
  {
    int index = messages.indexWhere((item) => item.toString() == widget.image);
    if (index != -1) {
      _scrollController.jumpToPage(index);
    }
  }
}
