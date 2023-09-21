import 'dart:io';

import 'package:appmess/test_library/ImageHelper.dart';
import 'package:flutter/material.dart';
class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<File> _image=[];
  final ImageHelper imageHelper=ImageHelper();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       Wrap(
         spacing: 4,
         runSpacing: 4,
         children: _image.map((e) =>Image.file(e,width: 100,height: 100,fit: BoxFit.cover,),
       ).toList()),
        SizedBox(height: 8,),
        TextButton(onPressed: ()
    async {
      final files =await imageHelper.pickImage(multiple: true);
      setState(() {
        _image=files.map((e) => File(e.path)).toList();
      });

    }, child:Text('selectImage'),
        )
      ],
    );
  }
}
