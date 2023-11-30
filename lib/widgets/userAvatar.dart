
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/updateCheckConnect.dart';

class UserAvatar extends StatelessWidget {
  final String? fileName;
  final double? radius;
  final double? size;
  final double? bottom;
  final bool isOnline;
  final void Function()?  onTap;
  const UserAvatar({Key? key, required this.fileName,required this.radius, this.onTap, this.size, required this.isOnline, this.bottom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ?? (){} ,
      child: Stack(
        children: [
          if (fileName!.isNotEmpty)
            ClipOval(
            child: CachedNetworkImage(
              imageUrl: fileName!,
              fit:BoxFit.cover,
              width:radius ?? 40,
              height:radius ??  40,
              errorWidget: (context, url, error) {
                // Xảy ra lỗi khi tải hình ảnh
                // Sử dụng hình ảnh khác trong trường hợp lỗi
                return Image.asset('assets/imagesgai.jpg',
                  fit:BoxFit.cover,
                  width:radius ?? 40,
                  height:radius ??  40,);
              },
            ),
          ) else ClipOval(
            child: Image.asset('assets/imagesgai.jpg',
              fit:BoxFit.cover,
              width:radius ?? 40,
              height:radius ??  40,),
          )
          ,
          Consumer<UpdateCheckConnect>(builder: (BuildContext context, value, Widget? child) {
            return value.connection
                   ?Positioned(
                bottom:bottom ?? 0,
                right: 0,
                child: Container(
                  width: size ?? 10,
                  height: size ?? 10,
                  decoration:   BoxDecoration(
                    color:isOnline ? Colors.green : Colors.transparent,
                    shape: BoxShape.circle,
                  ),))
                   : const SizedBox.shrink();
          },)
        ],
      ),
    );

  }
}