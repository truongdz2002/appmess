import 'package:appmess/Contact/controller/AlphabetScrollPage.dart';
import 'package:flutter/material.dart';

import '../../PageChat/view/ChatNew.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  List<String> contacts = [
    'An', 'Bình', 'Cường', 'Đạt', 'Eva', 'Hà', 'Hùng', 'Linh', 'Mai', 'Minh',
    'Nam', 'Ngọc', 'Phúc', 'Quỳnh', 'Sơn', 'Thảo', 'Thành', 'Thúy', 'Trâm',
    'Trường', 'Tuấn', 'Tùng', 'Uyên', 'Vân', 'Vũ', 'Xuân', 'Yến', 'Đức', 'Đan',
    'Đông', 'Đức',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh bạ'),
        automaticallyImplyLeading: false,
        leading: const Icon(Icons.menu),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.camera_alt),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 45,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Tìm kiếm',
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child:AlphabetScrollPage(
                items: contacts,
                onClickedItem: (item)
                {
                // Navigator.push(context,MaterialPageRoute(builder: (context)=>ChatNew(nameUser: item)));
                },
              ))
        ],
      ),
    );
  }

}


