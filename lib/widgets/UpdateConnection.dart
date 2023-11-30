import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/updateCheckConnect.dart';
import '../utils/responsive.dart';

class UpdateConnection extends StatefulWidget {
  final double? marginTop;
  const UpdateConnection({super.key, this.marginTop, });

  @override
  State<UpdateConnection> createState() => _UpdateConnectionState();
}

class _UpdateConnectionState extends State<UpdateConnection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateCheckConnect>(builder: (context,connection,_)
    {
      return !connection.connection
          ? Positioned(
        top:widget.marginTop ?? 0,
        child: Container(
          height: Responsive.getHeight(context) * .03,
          width: Responsive.getWidth(context),
          color: Colors.black,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.orange,)),
              SizedBox(width: 10,),
              Text('Đang chờ mạng ',style: TextStyle(color:Colors.red),),
            ],
          ),
        ),
      )
          :const SizedBox.shrink();
    });
  }
}
