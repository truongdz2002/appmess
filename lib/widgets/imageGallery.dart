
import 'dart:io';
import 'package:appmess/service/ChatService.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../api/Api.dart';
import 'package:appmess/models/Message.dart';
import '../main.dart';
import '../provider/OptionImageSend.dart';
import '../provider/imageGalleryProvider.dart';
import '../provider/processingListMessage.dart';
class ImageGallery extends StatefulWidget {
  final String receiverId;
  final List<String> tokenDeviceReceivers;
  final List<String> tokenDeviceSender;
  final String receiverName;
  final String senderName;
  const ImageGallery({super.key, required this.receiverId, required this.tokenDeviceReceivers, required this.receiverName, required this.tokenDeviceSender, required this.senderName});

  @override
  ImageGalleryState createState() => ImageGalleryState();
}

class ImageGalleryState extends State<ImageGallery> {
  late ImageGalleryProvider imageGalleryProvider;
  late OptionImageSend optionImageSend;
  late ProcessingListMessage processingListMessage;
  @override
  void initState() {
    imageGalleryProvider = Provider.of<ImageGalleryProvider>(context, listen: false);
    optionImageSend = Provider.of<OptionImageSend>(context, listen: false);
    processingListMessage = Provider.of<ProcessingListMessage>(context, listen: false);
    imageGalleryProvider.loadImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Consumer<ImageGalleryProvider>(
      builder: (context, imageProvider, _) {
        return imageProvider.assets == null
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : DraggableScrollableSheet(
          initialChildSize: 1.0, // Kích thước ban đầu của sheet
          minChildSize: 0.2, // Kích thước tối thiểu của sheet
          maxChildSize: 1.0, // Kích thước tối đa của sheet
          expand: true,
          builder: (BuildContext context, ScrollController scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Đảm bảo tiêu đề mở rộng đến toàn bộ chiều ngang
              children: [
                // Row(
                //   children: [
                //     IconButton(onPressed: (){
                //       Navigator.pop(context);
                //     }, icon:const Icon(Icons.close)),
                //     const Padding(
                //       padding: EdgeInsets.only(left:120,top: 10,bottom: 10),
                //       child: Text(
                //         'Thư viện',
                //         style: TextStyle(
                //           fontSize: 20,
                //           color: Colors.black87,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   ],
                // ),
                Expanded(
                  child:Stack(
                    children: [
                      Container(
                        color:Colors.black87,
                        child: GridView.builder(

                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,

                          ),
                          itemCount: imageProvider.assets!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final asset = imageProvider.assets![index];
                            return GestureDetector(onTap:()
                            {
                              if(optionImageSend.clickItem.isEmpty)
                              {
                                optionImageSend.toggleOption(asset);
                              }
                              else if(!optionImageSend.clickItem.contains(asset))
                              {
                                optionImageSend.toggleOption(asset);
                              }
                              else
                              {
                                optionImageSend.toggleUnSelect(asset);
                              }

                            },
                                child: _buildImageWidget(asset,index));
                          },
                        ),
                      ),
                      Consumer<OptionImageSend>(builder: (context,optionImageSend,_)
                      {
                        return optionImageSend.clickItem.isNotEmpty
                            ?Positioned(
                          bottom: 40, // Đặt khoảng cách 20 pixel từ phía dưới
                          left:30, // Đặt left thành 0 để căn chỉnh với cạnh trái của parent
                          right: 30, // Đặt right thành 0 để căn chỉnh với cạnh phải của parent
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center, // Để căn giữa các nút
                            children: [
                              Expanded(
                                flex: 1, // Đặt flex giống nhau cho cả hai nút
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Xử lý sự kiện khi nút "Chỉnh sửa" được nhấn
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.orangeAccent, // Màu nền của nút
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10), // Đặt góc bo tròn
                                    ),
                                    elevation: 5, // Độ đổ bóng
                                    shadowColor: Colors.black26, // Màu của đổ bóng
                                  ),
                                  child: const Text(
                                    'Chỉnh sửa',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white, // Màu văn bản
                                      fontSize: 16, // Kích thước văn bản
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 50,), // Khoảng cách giữa hai nút
                              Expanded(
                                flex: 1, // Đặt flex giống nhau cho cả hai nút
                                child: Stack(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        List<String> pathImage = await Future.wait(
                                          optionImageSend.clickItem.map((item) async {
                                            final file = await item.originFile;
                                              return file!.path;
                                          }),
                                        );
                                        processingListMessage.addFakeMessage(receiverId: widget.receiverId, message: pathImage, tokenDeviceReceivers: widget.tokenDeviceReceivers, receiverName: widget.receiverName, type: Type.image, tokenDeviceSender: widget.tokenDeviceSender, senderName:widget.senderName, senderId:Apis.firebaseAuth.currentUser!.uid, expression: '');
                                        List<AssetEntity> indexItemClick= List.from(optionImageSend.clickItem);
                                        Future.microtask(() {
                                           ChatService.sendImage(receiverId:widget.receiverId, tokenDeviceReceivers: widget.tokenDeviceReceivers, receiverName: widget.receiverName, assets:indexItemClick, tokenDeviceSender: widget.tokenDeviceSender, senderName: widget.senderName, senderId: Apis.firebaseAuth.currentUser!.uid);

                                         });
                                        optionImageSend.clickItem.clear();
                                         optionImageSend.notifyListeners();


                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize:const Size(200, 40) ,
                                        primary: Colors.orangeAccent, // Màu nền của nút
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10), // Đặt góc bo tròn
                                        ),
                                        elevation: 5, // Độ đổ bóng
                                        shadowColor: Colors.black26, // Màu của đổ bóng
                                      ),
                                      child: const Text(
                                        'Gửi',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white, // Màu văn bản
                                          fontSize: 16, // Kích thước văn bản
                                        ),
                                      ),
                                    ),
                                    Consumer<OptionImageSend>(builder: (context,optionImageSend,_)
                                    {
                                      return optionImageSend.clickItem.isNotEmpty
                                          ?Positioned(
                                          top:0,
                                          right:0,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text(optionImageSend.clickItem.length.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12
                                                ),
                                              ),
                                            ),
                                          ))
                                          :Container();
                                    }
                                    )

                                  ],
                                ),
                              ),
                            ],
                          )

                          ,
                        )
                            :const SizedBox.shrink();
                      })
                    ],
                  )
                  ,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildImageWidget(AssetEntity asset,int index) {
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
           Consumer<OptionImageSend>(builder: (context,optionImageSend,_)
           {
             return optionImageSend.clickItem.contains(asset)
                 ?Align(
               alignment: Alignment.center, // Đặt vị trí giữa cho số "1"
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(15), // Đặt góc bo tròn
                 child: Container(
                   width: 30,
                   height: 30,
                   decoration: const BoxDecoration(
                     color: Colors.orangeAccent,
                     boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                   ),
                   child: Center( // Để văn bản nằm chính giữa
                     child: Text(
                         (optionImageSend.clickItem.indexOf(asset)+1).toString(),
                       textAlign: TextAlign.center,
                       style: const TextStyle(
                         fontSize: 15, // Đặt kích thước cho số "1"
                         color: Colors.white, // Đặt màu cho số "1"
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                 ),
               ),
             )
                 : Container();

           })
      ],
    );
  }
}

