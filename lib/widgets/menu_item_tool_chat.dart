// import 'package:flutter/material.dart';
// import 'package:popover/popover.dart';
//
// import 'imageGallery.dart';
//
// class MenuItemToolChat extends StatefulWidget {
//   final Color? colorChangeIcons;
//
//   const MenuItemToolChat({super.key, required this.colorChangeIcons});
//
//   @override
//   _MenuItemToolChatState createState() => _MenuItemToolChatState();
// }
//
// class _MenuItemToolChatState extends State<MenuItemToolChat> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _customItem(
//           color: widget.colorChangeIcons!,
//           icon: Icons.image,
//         ),
//         const SizedBox(
//           width: 20,
//         ),
//         _customItem(color: widget.colorChangeIcons!, icon: Icons.link),
//       ],
//     );
//   }
//
//   _customItem(
//       {required IconData icon,
//         required Color color,
//         void Function()? onTap}) =>
//       InkWell(
//         onTap:  _showImageGallery(),
//         child: Container(
//             height: 40,
//             width: 40,
//             decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(10)),
//             child: IconButton(
//                 onPressed: () {},
//                 icon: Icon(icon, color: color, size: 24))),
//       );
//
//   _showImageGallery() => showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//           borderRadius:
//           BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
//       builder: (_) {
//         return Container();
//       });
// }
//
// class ButtonAdd extends StatelessWidget {
//   final Color? colorChangeIcons;
//   const ButtonAdd({Key? key, required this.colorChangeIcons}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 40,
//       height: 40,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(5)),
//         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
//       ),
//       child: GestureDetector(
//         child: const Center(child: Icon(Icons.add)),
//         onTap: () {
//           showPopover(
//             context: context,
//             bodyBuilder: (context) => MenuItemToolChat(colorChangeIcons: colorChangeIcons),
//             direction: PopoverDirection.bottom,
//             backgroundColor: Colors.white,
//             width: 120,
//             height: 60,
//             arrowHeight: 15,
//             arrowWidth: 30,
//           );
//         },
//       ),
//     );
//   }
// }
