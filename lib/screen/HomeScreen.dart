



import 'package:appmess/requestPermission/RequestPermisstion.dart';
import 'package:appmess/screen/ProfileScreen.dart';
import 'package:appmess/service/AuthService.dart';
import 'package:appmess/utils/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appmess/models/Message.dart';


import '../api/Api.dart';
import '../extention/timeFormatter.dart';
import '../models/ChatUser.dart';
import '../provider/processGroupOption.dart';
import '../provider/updateCheckConnect.dart';
import '../service/ChatService.dart';
import '../widgets/UpdateConnection.dart';
import '../widgets/drawItem.dart';
import '../widgets/userAvatar.dart';
import 'ChatNewScreen.dart';

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
  final TextEditingController _messageController=TextEditingController();
  late final AuthService authService;
  final ChatService _chatService = ChatService();
  late ChatUser chatUser;
  late UpdateCheckConnect updateCheckConnect;
  Future<void> signOut()
  async {
     await authService.singOut();
  }
  @override
  void initState() {
    RequestPermission.request();
    updateCheckConnect=Provider.of<UpdateCheckConnect>(context,listen: false);
    updateCheckConnect.checkInternet();
     authService=Provider.of<AuthService>(context,listen: false);
    getInformationAccount();


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      body:Stack(
        children: [
          Column(
            children: [
              _customAppBar(),
              _customGroupOption(),

            ],
          ),
            UpdateConnection(marginTop: Responsive.getHeight(context) * .12),
          _customListUserActive(),
          _customListUserChatForMe()
        ],
      ),
      drawer: _customListOptionUse(),
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
              List<dynamic> tokensDynamic = data['deviceTokens'];
              String dataImages =data['image']as String;

          // Chuyển đổi danh sách động thành danh sách chuỗi
              List<String> tokens = tokensDynamic.cast<String>();
              return buildConversationRow(data['uid'],data['name'],dataImages,5,tokens,data['is_online']);
            }
          return Container();
        }
        ).toList(),
      );
    });
  }
  Widget buildConversationRow(String uid,String nameReceiver,String filename,int msgCount,List<String> tokenDevice,bool isOnline)
  {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context,MaterialPageRoute(builder: (_)=>ChatNewScreen(receiverUserId: uid, receiverTokenDevice: tokenDevice, receiverName: nameReceiver,fileImage: filename, senderName:chatUser.name!, senderTokenDevice:chatUser.deviceTokens!, isOnline: isOnline,)));
        //Navigator.push(context,MaterialPageRoute(builder: (_)=>Test(receiverUserId: uid, receiverTokenDevice: tokenDevice, receiverName: nameReceiver,fileImage: filename, receiverUserEmail: '',)));
      },
      child: Container(
        margin: const EdgeInsets.only(top:5),
        height: Responsive.getHeight(context) * .08,
        width: Responsive.getWidth(context) * .2,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
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
                      child: UserAvatar(fileName:filename,radius:40, isOnline:isOnline ,),
                    ),
                    updateLastMessage(uid,filename,nameReceiver),
                  ],
                ),
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
          UserAvatar(fileName:filename, isOnline:true, radius: 40,),
      const SizedBox(height: 5,),
      Text(name,style:TextStyle(color:Theme.of(context).colorScheme.secondary,fontSize: 16),)
      ])
    );
  }
  _customAppBar() => Padding(
    padding:  EdgeInsets.only(
        top: Responsive.getHeight(context) * .05,
        left: Responsive.getWidth(context) * .01,
        right: Responsive.getWidth(context) * .01),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: (){
              _globalKey.currentState!.openDrawer();
            },
            icon:  Icon(
                Icons.menu,
                color: Theme.of(context).colorScheme.primary)),
        IconButton(
            onPressed: (){},
            icon: Icon(
              Icons.search,
              color:Theme.of(context).colorScheme.primary,))
      ],
    ),
  );
  _customGroupOption() =>Container(
    margin:const EdgeInsets.only(top:10),
    height: Responsive.getHeight(context) * .1,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:context.read<ProcessGroupOption>().listNameOption.length,
        padding: EdgeInsets.only(left:Responsive.getWidth(context) * .02),
        itemBuilder: (context,index){
        return itemGroupOption(index,context.read<ProcessGroupOption>().listNameOption[index]);
    })
  );
  _customListUserActive() =>Positioned(
      top: Responsive.getHeight(context) * .2,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 15,left: 25,right: 25),
        height: Responsive.getHeight(context) * .25,
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
                  controller:_messageController,
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  decoration: InputDecoration(
                    labelText: 'Tìm kiếm cuộc trò chuyện',
                    labelStyle: TextStyle(
                      color:Theme.of(context).colorScheme.secondary, // Màu của label
                    ),
                    suffixIcon: Icon(Icons.search,color: Theme.of(context).colorScheme.primary,),
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
                 Text('Đang hoạt động',style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,

                ),),
                IconButton(
                    onPressed: (){},
                    icon:  Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.primary,))
              ],
            ),
            SizedBox(height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  builderContactAvatar('Alll','https://img.freepik.com/free-photo/cascade-boat-clean-china-natural-rural_1417-1356.jpg?w=740&t=st=1695897228~exp=1695897828~hmac=0abe48744e484b588a1023f071a5f6c5796873ab76c700f67945f47e9e900a4e'),
                  builderContactAvatar('Alll','https://img.freepik.com/free-photo/cascade-boat-clean-china-natural-rural_1417-1356.jpg?w=740&t=st=1695897228~exp=1695897828~hmac=0abe48744e484b588a1023f071a5f6c5796873ab76c700f67945f47e9e900a4e'),
                  builderContactAvatar('Alll','https://img.freepik.com/free-photo/cascade-boat-clean-china-natural-rural_1417-1356.jpg?w=740&t=st=1695897228~exp=1695897828~hmac=0abe48744e484b588a1023f071a5f6c5796873ab76c700f67945f47e9e900a4e'),
                  builderContactAvatar('Alll','https://img.freepik.com/free-photo/cascade-boat-clean-china-natural-rural_1417-1356.jpg?w=740&t=st=1695897228~exp=1695897828~hmac=0abe48744e484b588a1023f071a5f6c5796873ab76c700f67945f47e9e900a4e'),
                  builderContactAvatar('Alll','https://img.freepik.com/free-photo/cascade-boat-clean-china-natural-rural_1417-1356.jpg?w=740&t=st=1695897228~exp=1695897828~hmac=0abe48744e484b588a1023f071a5f6c5796873ab76c700f67945f47e9e900a4e'),
                  builderContactAvatar('Alll','https://img.freepik.com/free-photo/cascade-boat-clean-china-natural-rural_1417-1356.jpg?w=740&t=st=1695897228~exp=1695897828~hmac=0abe48744e484b588a1023f071a5f6c5796873ab76c700f67945f47e9e900a4e'),
                  builderContactAvatar('Alll','https://img.freepik.com/free-photo/cascade-boat-clean-china-natural-rural_1417-1356.jpg?w=740&t=st=1695897228~exp=1695897828~hmac=0abe48744e484b588a1023f071a5f6c5796873ab76c700f67945f47e9e900a4e'),
                  builderContactAvatar('Alll','https://img.freepik.com/free-photo/cascade-boat-clean-china-natural-rural_1417-1356.jpg?w=740&t=st=1695897228~exp=1695897828~hmac=0abe48744e484b588a1023f071a5f6c5796873ab76c700f67945f47e9e900a4e'),
                  builderContactAvatar('Alll','https://img.freepik.com/free-photo/cascade-boat-clean-china-natural-rural_1417-1356.jpg?w=740&t=st=1695897228~exp=1695897828~hmac=0abe48744e484b588a1023f071a5f6c5796873ab76c700f67945f47e9e900a4e'),
                  builderContactAvatar('Alll','https://img.freepik.com/free-photo/cascade-boat-clean-china-natural-rural_1417-1356.jpg?w=740&t=st=1695897228~exp=1695897828~hmac=0abe48744e484b588a1023f071a5f6c5796873ab76c700f67945f47e9e900a4e'),
                  builderContactAvatar('Alll','https://img.freepik.com/free-photo/cascade-boat-clean-china-natural-rural_1417-1356.jpg?w=740&t=st=1695897228~exp=1695897828~hmac=0abe48744e484b588a1023f071a5f6c5796873ab76c700f67945f47e9e900a4e'),
                  builderContactAvatar('Alll','https://img.freepik.com/free-photo/cascade-boat-clean-china-natural-rural_1417-1356.jpg?w=740&t=st=1695897228~exp=1695897828~hmac=0abe48744e484b588a1023f071a5f6c5796873ab76c700f67945f47e9e900a4e'),

                ],
              ),)
          ],
        ),)
  );
  _customListUserChatForMe() =>Positioned(
      top: Responsive.getHeight(context) * .43,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration:  const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40))
        ),
        child: _buildListUser(),
      )
  );

  _customListOptionUse() =>Drawer(
    width: Responsive.getWidth(context) * .8,
    backgroundColor: Theme.of(context).colorScheme.background,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(40))
    ),
    child: Container(
      decoration:  BoxDecoration(
          borderRadius:const BorderRadius.horizontal(right: Radius.circular(40) ),
          color: Theme.of(context).colorScheme.background,
          boxShadow: const [
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
                  children: [
                    Icon(Icons.arrow_back_ios,color: Theme.of(context).colorScheme.primary,size: 20,),
                    const SizedBox(width: 50,),
                    Text('Cài đặt ',style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 16),)
                  ],
                ),
                const SizedBox(height: 30,),
                StreamBuilder(
                    stream:FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).snapshots(),
                    builder: (context,snapshot) {
                      if (snapshot.hasError) {
                        return Row(
                          children: [
                            const UserAvatar(fileName:'',radius: 40,isOnline: false),
                            const SizedBox(width: 12,),
                            Text('UserName',style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                          ],
                        );
                      }
                      if(snapshot.hasData)
                      {
                        Map<String, dynamic> data=snapshot.data!.data() as Map<String, dynamic>;
                        return Row(
                          children: [
                             UserAvatar(fileName:data['image'],radius: 40, isOnline:data['is_online'] ,),
                            const SizedBox(width: 12,),
                             Text( data['name'],style:  TextStyle(color: Theme.of(context).colorScheme.secondary),),
                          ],
                        );
                      }
                      return  Row(
                        children: [
                          UserAvatar(fileName:'',radius: 40, isOnline: chatUser.isOnline!,),
                          const SizedBox(width: 12,),
                           Text('UserName',style: TextStyle(color:Theme.of(context).colorScheme.secondary),),
                        ],
                      );
                    }
                ),
                const SizedBox(height: 20,),
                GestureDetector(onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder:(_)=>const ProfileScreen(fileImage:'')));
                },child:
                const DrawItem(title:'Tài khoản',icon: Icons.key,)),
                const DrawItem(title:'Chats',icon: Icons.chat_bubble,),
                const DrawItem(title:'Thông báo',icon: Icons.notifications_active,),
                const DrawItem(title:'Dữ liệu và lưu trữ',icon: Icons.storage,),
                const DrawItem(title:'Hỗ trợ ',icon: Icons.help),
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
  );
  void getInformationAccount()
  {
    FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).snapshots().listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
         chatUser=ChatUser.fromJson(userData);
      }
    });

  }
  Widget updateLastMessage(String receiverUid,String filename,String nameReceiver) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(receiverUid, Apis.firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('error ${snapshot.error.toString()}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('.....Loading');
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          int max = snapshot.data!.docs.length;
          final document = snapshot.data!.docs[0];
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nameReceiver, style: TextStyle(color:data['seen'] ? Colors.grey :Theme.of(context).colorScheme.secondary,fontSize:18)),
                SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(data['senderId']==Apis.firebaseAuth.currentUser!.uid ? 'Bạn:':data['receiverName']+':', style: TextStyle(color:data['seen'] ? Colors.grey :Theme.of(context).colorScheme.secondary)),
                          Text(data['typeMessage'].toString() == Type.image.name
                              ? 'Hình ảnh'
                              :data['message'][0].toString().length <=20
                                ?data['message'][0]
                                :data['message'][0].substring(0, 20) + "...",
                              style: TextStyle(color:data['seen'] ? Colors.grey :Theme.of(context).colorScheme.secondary)),
                          const SizedBox(width: 10,),
                          Text(TimeFormatter.formatCustomTime(data['timestamp']), style: TextStyle(color:data['seen'] ? Colors.grey :Theme.of(context).colorScheme.secondary)),
                        ],
                      ),
                     data['seen']
                      ? data['senderId'] == Apis.firebaseAuth.currentUser!.uid
                        ? Padding(padding: const EdgeInsets.all(8.0),
                          child: UserAvatar(fileName:filename,radius:20,size: 0, isOnline: false,),)
                         :const SizedBox.shrink()
                         :Image.asset('assets/check.png',width: 20,height: 20,)
                    ],
                    ),
                ),
              ],
            );
        }
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(nameReceiver, style:  TextStyle(color:Theme.of(context).colorScheme.secondary,fontSize:18)),

        ]);
      },
    );
  }
  itemGroupOption(int index,String title)=>
  Consumer<ProcessGroupOption>(builder: (context,processGroupOption,_)
  {
    return Container(
      margin: EdgeInsets.only(left: Responsive.getWidth(context) * .05 ),
      child: TextButton(
          onPressed: (){
            context.read<ProcessGroupOption>().toggleChangeOption(index);
          },
          child:  Text(title,
            style: TextStyle(
                color:     processGroupOption.indexSelect==index ? Theme.of(context).colorScheme.secondary :Colors.grey,
                fontSize:  processGroupOption.indexSelect==index ? 16 :14
            ),)),
    );

  });
}







