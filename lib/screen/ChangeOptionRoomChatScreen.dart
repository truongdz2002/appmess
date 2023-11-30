// import 'package:appmess/provider/ClickItemOptionImage.dart';
// import 'package:appmess/widgets/userAvatar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../widgets/imageGalleryUpdateAvatar.dart';
//
// class ChangeOptionRoomChatScreen extends StatefulWidget {
//   final String fileImage;
//   const ChangeOptionRoomChatScreen({super.key,required this.fileImage});
//
//   @override
//   State<ChangeOptionRoomChatScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ChangeOptionRoomChatScreen> {
//   bool clickOptionImage=true;
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(onPressed: (){}, icon: const Icon(Icons.settings))
//         ],
//       ),
//       body:Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//            UserAvatar(fileName: widget.fileImage, radius: 60),
//             const SizedBox(height: 20),
//             _customOptionIcon(),
//             const SizedBox(height: 40),
//             _customization()
//           ],
//         ),
//       ) ,
//     );
//   }
//   _itemOptionIconProfile({required IconData icon,required String nameIcon})=>Column(
//     children: [
//       Container(
//           width: 40,
//        height: 40,
//       decoration: const BoxDecoration(
//         color: Colors.white70,
//         shape: BoxShape.circle,
//           boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]
//       ),
//           child: Icon(icon,size: 20)),
//       const SizedBox(height: 10),
//       Text(nameIcon,style: const TextStyle(
//         fontSize:14,
//         fontWeight: FontWeight.normal,
//         color: Colors.black
//       ),)
//     ],
//   );
//   _customOptionIcon() =>Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       _itemOptionIconProfile(icon: Icons.call ,nameIcon:'Audio'),
//       const SizedBox(width: 20),
//       _itemOptionIconProfile(icon: Icons.video_camera_back ,nameIcon:'Video'),
//       const SizedBox(width: 20),
//       _itemOptionIconProfile(icon: Icons.person ,nameIcon:'Profile'),
//       const SizedBox(width: 20),
//       _itemOptionIconProfile(icon: Icons.notifications ,nameIcon:'Mute'),
//     ],
//   );
//   _customization() =>Column(
//     children: [
//       _itemCustomization(nameCustomization:'Theme' ,iconCustomization:'❤️' ),
//       _itemCustomization(nameCustomization:'Quick reaction' ,iconCustomization:'❤️'),
//       _itemCustomization(nameCustomization:'NickName',iconCustomization:'❤️'),
//       _itemCustomization(nameCustomization:'Word effects' ,iconCustomization:'❤️' ),
//
//     ],
//   );
//   _itemCustomization({required String nameCustomization,required String iconCustomization})=>Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Expanded(
//         child: Text(nameCustomization,style: const TextStyle(
//             fontSize:15,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//
//         ),),
//       ),
//       const SizedBox(height: 10),
//       Text(iconCustomization,style: const TextStyle(
//           fontSize:14,
//           fontWeight: FontWeight.bold,
//           color: Colors.black
//       ),),
//       const SizedBox(height: 30)
//     ],
//   );
//
//
// }
//
//
//
//
