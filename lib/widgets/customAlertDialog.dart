import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String title;
  final String content;

  const CustomAlertDialog({super.key,
    required this.onConfirm,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        side: BorderSide(
          color: Colors.orange,
          width: 1,
        ),
      ),
      title: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.orange,
              width: 1,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(title),
      ),
      content: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(content),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text('Hủy bỏ'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text('Đồng ý'),
        ),
      ],
    );
  }
}
