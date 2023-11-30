import 'dart:io';
import 'package:appmess/widgets/userAvatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appmess/models/Message.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import '../extention/BubbleBackground.dart';
import '../extention/timeFormatter.dart';
import '../screen/ViewImageScreen.dart';

@immutable
class MessageBubble extends StatelessWidget {
  final String fileImage;
  final Map<String, dynamic> data;
  final Map<String, dynamic> dataNext;
  final int index;
  final bool isOnline;
  final int indexMax;
  final String receiverUserId;
  final List<Color> colorLeft;
  final List<Color> colorRight;
  final String contentMessageSeenMax;

  const MessageBubble({
    super.key,
    required this.data,
    required this.colorLeft,
    required this.colorRight,
    required this.fileImage, required this.index, required this.indexMax, required this.receiverUserId, required this.isOnline, required this.contentMessageSeenMax, required this.dataNext,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = (data['senderId'] == FirebaseAuth.instance.currentUser!.uid);
    final messageAlignment = isCurrentUser ? Alignment.topRight : Alignment.topLeft;

    // Đặt radius lớn cho CircleAvatar bên trái và radius nhỏ cho CircleAvatar bên phải
    final double circleAvatarRadius = isCurrentUser ? 20 : 25;
    return Column(
      children: [
    TimeFormatter.calculateTimeDifference(data['timestamp'], dataNext['timestamp']).inMinutes>30
       ? Text(TimeFormatter.formatCustomTime(data['timestamp']),style: const TextStyle(color: Colors.grey),)
         :const SizedBox.shrink(),
        Row(
          crossAxisAlignment:CrossAxisAlignment.end,
          mainAxisAlignment:isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            !isCurrentUser
              //?data['senderId']==dataNext['senderId']
               //?data['id']==dataNext['id']
                   ?
          Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UserAvatar(fileName:fileImage,radius:circleAvatarRadius, isOnline: isOnline,),
                      )
                  // :data['senderId']!=dataNext['receiverId']
                    //?Padding(
                      //  padding: const EdgeInsets.all(8.0),
                      //  child: UserAvatar(fileName:fileImage,radius:circleAvatarRadius, isOnline: isOnline,),
                     // )
                   // :SizedBox(height: 40,width:40,)

               //: SizedBox(height: 40,width:40,)
              :const SizedBox.shrink(),



            Flexible(
              child: FractionallySizedBox(
                alignment: messageAlignment,
                widthFactor:0.8,
                child: Align(
                  alignment: messageAlignment,
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 5
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: data['typeMessage'].toString() == Type.image.name
                              ? data['message'].length == 1
                                  ? data['send']
                                    ?InkWell(
                                    onTap: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder:(_)=>ViewImageScreen(receiverUserId: receiverUserId, image:data['message'][0],)));
                                },
                                    child: Image(
                                height: 300,
                                width: 150,
                                image: AdvancedNetworkImage(
                                    data['message'][0].toString(),
                                    useDiskCache: true,
                                    cacheRule: const CacheRule(maxAge: Duration(days: 1)),
                                ),
                                fit: BoxFit.cover,
                              ),
                                  )
                                    :Image.file(
                                     File(data['message'][0].toString()),
                                    height: 300,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    )
                              : SizedBox(
                            height: data['message'].length < 3
                                ? 155.0 * (data['message'].length / 2)
                                : 120.0 * ((data['message'].length) % 3==0
                                            ? (data['message'].length ) / 3
                                             :(data['message'].length) % 3==2
                                              ?(data['message'].length +1) /3
                                               :(data['message'].length +2) /3
                            ),
                            child: GridView.builder(
                              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: data['message'].length==2 ? 2 :3,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data['message'].length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: ()
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder:(_)=>ViewImageScreen(receiverUserId:receiverUserId, image:data['message'][index],)));
                                  },
                                  child: Container(
                                    height: 120,
                                    margin: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey, width: 3),
                                    ),
                                    child:data['send'] ? Image(
                                      image: AdvancedNetworkImage(
                                        data['message'][index].toString(),
                                        useDiskCache: true,
                                        cacheRule: const CacheRule(maxAge: Duration(days: 1)),
                                      ),
                                      fit: BoxFit.cover,
                                    ) : Image.file(
                                      File(data['message'][index].toString()),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                              : BubbleBackground(
                            colors: isCurrentUser ? colorRight : colorLeft,
                            context: context,
                            child: DefaultTextStyle.merge(
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(data['message'][0].toString()),
                              ),
                            ),
                          ),
                        ),
                      ),
                      data['expression'].toString().isNotEmpty
                          ? Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A364B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:  Align(
                              alignment: Alignment.center,
                              child: Text(
                                data['expression'],
                                style: const TextStyle(fontSize: 10.0),
                              ),
                            ),
                          )
                      )
                          :const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
            isCurrentUser
                ? data['send']
                  ? data['seen'] ? contentMessageSeenMax == data['message'].toString()
                                          ? Padding(padding: const EdgeInsets.all(8.0),
                                           child: UserAvatar(fileName:fileImage,radius:circleAvatarRadius,size: 0, isOnline: false,),)
                                           :const SizedBox(width: 30,)
                :Image.asset('assets/check.png',width: 20,height: 20,)
                :  Image.asset('assets/radio.png',width: 20,height: 20,)
                :const SizedBox(width: 30,)
          ],
        ),
      ],
    );
  }
}

