import 'package:appmess/components/Text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/AuthService.dart';

class LoginScreen extends StatefulWidget {
  final void Function()?  onTap;
  const LoginScreen({Key? key, this.onTap}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controllerEmail=TextEditingController();
  TextEditingController controllerPass=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextField(controller: controllerEmail, hintText: 'Email', obscureText:false),
              const SizedBox(height: 20,),
              MyTextField(controller: controllerPass, hintText:  'Mật khẩu', obscureText:true),
              const SizedBox(height: 40,),
              ElevatedButton(onPressed: sigIn,style:ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )
              ), child:const Text('Đăng nhập'),),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bạn chưa có tài khoản ?',style: TextStyle(
                      color: Colors.black45
                  ),),
                  TextButton(onPressed: widget.onTap, child:const Text('Đăng kí ngay',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> sigIn()
  async {
    final authService=Provider.of<AuthService>(context,listen: false);
    try
        {
          await authService.sigInWithEmailPassWord(controllerEmail.text, controllerPass.text);
        }
        catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
