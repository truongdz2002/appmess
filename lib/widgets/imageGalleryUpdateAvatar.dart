import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:appmess/service/ChatService.dart';
import 'package:appmess/widgets/extension.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../provider/imageGalleryProvider.dart';
class ImageGalleryUpdateAvatar extends StatefulWidget {
  const ImageGalleryUpdateAvatar({super.key});

  @override
  ImageGalleryUpdateAvatarState createState() => ImageGalleryUpdateAvatarState();
}

class ImageGalleryUpdateAvatarState extends State<ImageGalleryUpdateAvatar> {
  @override
  void initState() {
    context.read<ImageGalleryProvider>().loadImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageGalleryProvider>(
      builder: (context, imageProvider, _) {
        return imageProvider.assets == null
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Đảm bảo tiêu đề mở rộng đến toàn bộ chiều ngang
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Thư viện',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child:Container(
                color:Colors.black87,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemCount: imageProvider.assets!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final asset = imageProvider.assets![index];
                    return InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(child: CircularProgressIndicator());
                            },
                          );
                          Timer(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });

                          bool success = await ChatService.updateAvatar(asset);



                          if (success) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cập nhật ảnh đại diện thành công'),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            const SnackBar(
                                content: Text('Cập nhật ảnh đại diện thất bại'));
                          }
                        },
                        child: _buildImageWidget(asset));
                  },
                ),
              )
              ,
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageWidget(AssetEntity asset) {
    return Stack(
      children: [
        FutureBuilder<File?>(
          future: asset.file,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              final file = snapshot.data!;
              return Image.file(
                file,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),

      ],
    );
  }
}

