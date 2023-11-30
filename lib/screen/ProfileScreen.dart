
import 'package:appmess/api/Api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ClickItemOptionImage.dart';
import '../widgets/imageGalleryUpdateAvatar.dart';
import '../widgets/userAvatar.dart';

class ProfileScreen extends StatefulWidget {
  final String fileImage;
  const ProfileScreen({super.key, required this.fileImage});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor:Theme.of(context).colorScheme.background ,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios,color: Theme.of(context).colorScheme.secondary,), // Sử dụng Icon để tạo biểu tượng
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(onPressed: (){}, icon:  Icon(Icons.settings,color:Theme.of(context).colorScheme.secondary,))
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            StreamBuilder(
                stream:FirebaseFirestore.instance.collection('users').doc(Apis.firebaseAuth.currentUser!.uid).snapshots(),
                builder: (context,snapshot) {
                  if (snapshot.hasError) {
                    return UserAvatar(fileName: '', radius: 80,onTap: ()
                    {
                      _showOptionImage();
                    }, isOnline:false,);
                  }
                  if(snapshot.hasData)
                  {
                    Map<String, dynamic> data=snapshot.data!.data() as Map<String, dynamic>;
                    return UserAvatar(fileName:data['image'], radius: 80,onTap: ()
                    {
                    _showOptionImage();
                    }, isOnline: data['is_online'],);
                  }
                  return  UserAvatar(fileName: '', radius: 80,onTap: ()
                  {
                    _showOptionImage();
                  }, isOnline:false,);
                }
            ),
            const SizedBox(height: 20),
            _customization()
          ],
        ),
      ) ,
    );
  }
  _showOptionImage()=>showModalBottomSheet(context: context,
      shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
      ),builder: (_)
      {
        return ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Chọn ảnh',textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.orange
                ),),
            ),
            _listOptionUpImage(),
          ],
        );
      });
  Widget _listOptionUpImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<ClickItemOptionImage>(
          builder: (context, clickItemProvider, child) {
            return InkWell(
              onTap: () {
                clickItemProvider.toggleOption1();
                Navigator.pop(context);
                _showImageGallery();

              },
              child: Padding(
                padding: const EdgeInsets.only(right: 50, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: clickItemProvider.clickItem ? Colors.orange : Colors.transparent,
                    ),
                  ),
                  child: Image.asset('assets/picture.png', width: 60, height: 60),
                ),
              ),
            );
          },
        ),
        Consumer<ClickItemOptionImage>(
          builder: (context, clickItemProvider, child) {
            return InkWell(
              onTap: () {
                clickItemProvider.toggleOption2();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 50, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: !clickItemProvider.clickItem ? Colors.orange : Colors.transparent,
                    ),
                  ),
                  child: Image.asset('assets/camera.png', width: 60, height: 60),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  _showImageGallery()=>showModalBottomSheet(context: context,
      shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
      ),builder: (_)
      {
        return const ImageGalleryUpdateAvatar();
      }
  );
  _customization() =>Column(
    children: [
      _itemCustomization(nameCustomization:'Theme' ,iconCustomization:'❤️' ),
      _itemCustomization(nameCustomization:'Quick reaction' ,iconCustomization:'❤️'),
      _itemCustomization(nameCustomization:'NickName',iconCustomization:'❤️'),
      _itemCustomization(nameCustomization:'Word effects' ,iconCustomization:'❤️' ),

    ],
  );
  _itemCustomization({required String nameCustomization,required String iconCustomization})=>Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(nameCustomization,style:  TextStyle(
          fontSize:15,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,

        ),),
      ),
      const SizedBox(height: 10),
      Text(iconCustomization,style:  TextStyle(
          fontSize:14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary
      ),),
      const SizedBox(height: 30)
    ],
  );

}
