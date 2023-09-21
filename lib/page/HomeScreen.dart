

import 'dart:developer';

import 'package:appmess/PageChat/view/ChatNew.dart';
import 'package:appmess/requestPermission/RequestPermisstion.dart';
import 'package:appmess/service/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _globalKey=GlobalKey();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final Color colorIcons=const Color(0xFF0C0B0B);
  final Color colorBackground=const Color(0xFFE7E2E2);
  final Color colorTitleClick=const Color(0xFF0C0B0B);
  final RequestPermission requestPermission=RequestPermission();
  late final AuthService authService;
  Future<void> signOut()
  async {
     await authService.singOut();
  }
  @override
  void initState() {
    requestPermission.request();
     authService=Provider.of<AuthService>(context,listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: colorBackground,
      body:Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 55,left: 5,right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: (){
                          _globalKey.currentState!.openDrawer();
                        },
                        icon:  Icon(
                          Icons.menu,
                          color: colorIcons)),
                    IconButton(
                        onPressed: (){},
                        icon: Icon(
                          Icons.search,
                          color:colorIcons,))
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 10),
                  children: [
                    TextButton(
                        onPressed: (){}, 
                        child:  Text('Messages',
                          style: TextStyle(
                            color: colorTitleClick
                          ),)),
                    const SizedBox(width: 35,),
                    TextButton(
                        onPressed: (){},
                        child: const Text('Hoạt động',
                          style: TextStyle(
                              color: Colors.grey
                          ),)),
                    const SizedBox(width: 35,),
                    TextButton(
                        onPressed: (){},
                        child: const Text('Nhóm',
                          style: TextStyle(
                              color: Colors.grey
                          ),)),
                    const SizedBox(width: 35,),
                    TextButton(
                        onPressed: (){},
                        child: const Text('More',
                          style: TextStyle(
                              color: Colors.grey
                          ),)),
                    const SizedBox(width: 35,),
                    TextButton(
                        onPressed: (){},
                        child: const Text('Messages',
                          style: TextStyle(
                              color: Colors.grey
                          ),)),
                    const SizedBox(width: 35,),
                  ],
                ),
              )
              
            ],
          ),
          Positioned(
            top: 190,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 15,left: 25,right: 25),
                height: 220,
                decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40))
                ),
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Tìm kiếm cuộc trò chuyện',
                          suffixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nhắn tin gần đây',style: TextStyle(
                        color: Colors.white,
                        
                      ),),
                      IconButton(
                          onPressed: (){},
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.white,))
                    ],
                  ),
                  SizedBox(height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      builderContactAvatar('Alll','imagesgai.jpg'),
                      builderContactAvatar('Alll','imagesgai.jpg'),
                      builderContactAvatar('Alll','imagesgai.jpg'),
                      builderContactAvatar('Alll','imagesgai.jpg'),
                      builderContactAvatar('Alll','imagesgai.jpg'),
                      builderContactAvatar('Alll','imagesgai.jpg'),
                      builderContactAvatar('Alll','imagesgai.jpg'),
                      builderContactAvatar('Alll','imagesgai.jpg'),
                      builderContactAvatar('Alll','imagesgai.jpg'),
                    ],
                  ),)
                ],
              ),)
          ),
          Positioned(
            top: 365,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration:  BoxDecoration(
                color: colorBackground,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))
          ),
              child: _buildListUser(),
              )
          )
        ], 
      ),
      drawer: Drawer(
        width: 275,
        backgroundColor: Colors.black26,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(40))
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius:BorderRadius.horizontal(right: Radius.circular(40) ),
            color: Color(0xF71F1E1E),
            boxShadow: [
              BoxShadow(color: Color(0x30000000),spreadRadius: 30,blurRadius: 20)
            ]
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20,50,20,20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.arrow_back_ios,color: Colors.white,size: 20,),
                        SizedBox(width: 50,),
                        Text('Cài đặt ',style: TextStyle(color: Colors.white,fontSize: 16),)
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Row(
                      children: [
                        const UserAvatar(fileName:'imagesgai.jpg'),
                        const SizedBox(width: 12,),
                        StreamBuilder(
                          stream:FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).snapshots(),
                            builder: (context,snapshot) {
                              if (snapshot.hasError) {
                                return const Text('UserName',style: TextStyle(color: Colors.white),);
                              }
                              if(snapshot.hasData)
                                {
                                  Map<String, dynamic> data=snapshot.data!.data() as Map<String, dynamic>;
                                      return Text(
                                        data['name'], style: const TextStyle(
                                          color: Colors.white),);
                                }
                              return const Text('UserName',style: TextStyle(color: Colors.white),);
                            }
                        )

                      ],
                    ),
                    const SizedBox(height: 20,),
                    const DrawItem(title:'Tài khoản',icon: Icons.key,),
                    const DrawItem(title:'Chats',icon: Icons.chat_bubble,),
                    const DrawItem(title:'Thông báo',icon: Icons.notifications_active,),
                    const DrawItem(title:'Dữ liệu và lưu trữ',icon: Icons.storage,),
                    const DrawItem(title:'Hỗ trợ ',icon: Icons.help,),
                    const Divider(
                      height: 35,
                      color: Colors.green,
                    ),
                    const DrawItem(title:'Mời bạn bè',icon: Icons.people_alt_outlined,),

                  ],

                ),
                 DrawItem(onTap: signOut,title:'Đăng xuất',icon:Icons.login_outlined,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildListUser()
  {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context,snapshot)
    {
      if(snapshot.hasError)
        {
          return const Text('Error');
        }
      if(snapshot.connectionState==ConnectionState.waiting)
        {
          return const Text('loading...');
        }
      return ListView(
        padding: const EdgeInsets.only(left: 20,right: 20),
        children: snapshot.data!.docs.map((doc) {
          Map<String,dynamic> data=doc.data()! as  Map<String,dynamic>;
          if(_auth.currentUser!.email!=data['email'])
            {
              // Lấy danh sách token từ Firestore
              List<dynamic> tokensDynamic = data['token device'];

          // Chuyển đổi danh sách động thành danh sách chuỗi
              List<String> tokens = tokensDynamic.cast<String>();
              log(tokens.toString());
              return buildConversationRow(data['uid'],data['name'],'hellllllllllllllllo','imagesgai.jpg',5,tokens);
            }
          return Container();
        }
        ).toList(),
      );
    });
  }
  Widget buildConversationRow(String uid,String name,String message ,String filename,int msgCount,List<String> tokenDevice)
  {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context,MaterialPageRoute(builder: (_)=>ChatNew(receiverUserEmail:name,receiverUserId: uid, receiverTokenDevice: tokenDevice,)));
      },
      child: Container(
        height: 74,
        width: 320,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UserAvatar(fileName:filename),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,style: const TextStyle(color: Colors.black),),
                        const SizedBox(height: 5,),
                        Text(message,style: const TextStyle(color: Colors.black),)
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      const Text('16:35',style: TextStyle(fontSize: 10),),
                      const SizedBox(height: 15,),
                      if(msgCount>0)
                      CircleAvatar(
                        radius: 7,
                        backgroundColor: Colors.greenAccent,
                        child: Text(msgCount.toString(),style: const TextStyle(fontSize: 10,color: Colors.white),),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  Padding builderContactAvatar(String name,String filename)
  {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
          children: [
          UserAvatar(fileName:filename),
      const SizedBox(height: 5,),
      Text(name,style: const TextStyle(color: Colors.white,fontSize: 16),)
      ])
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String fileName;
  const UserAvatar({Key? key, required this.fileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
      );

  }
}
class DrawItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() ?  onTap;
  const DrawItem({Key? key, required this.title, required this.icon, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Icon(icon,color: Colors.white,size: 20,),
          const SizedBox(width: 50,),
          TextButton(onPressed:onTap ,
          child: Text(title,style: const TextStyle(color: Colors.white,fontSize: 16),))
        ],
      ),
    );
  }
}


