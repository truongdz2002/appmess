import 'package:appmess/provider/ThemeModeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() ?  onTap;
  const DrawItem({Key? key, required this.title, required this.icon, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeModeProvider themeModeProvider =Provider.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Icon(icon,color: themeModeProvider.colorIcon,size: 20,),
          const SizedBox(width: 50,),
          TextButton(onPressed:onTap ,
              child: Text(title,style:  TextStyle(color: themeModeProvider.colorText,fontSize: 16),))
        ],
      ),
    );
  }
}