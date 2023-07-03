import 'package:appmess/service/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/Text_field.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()?  onTap;
  const RegisterScreen({Key? key, this.onTap}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController controllerEmail=TextEditingController();
  TextEditingController controllerNameUser=TextEditingController();
  TextEditingController controllerPass=TextEditingController();
  TextEditingController controllerConfirmPass=TextEditingController();
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
              MyTextField(controller: controllerNameUser, hintText: 'Họ và tên', obscureText:false),
              const SizedBox(height: 20,),
              MyTextField(controller: controllerPass, hintText:  'Mật khẩu', obscureText:true),
              const SizedBox(height: 20,),
              MyTextField(controller: controllerConfirmPass, hintText:  'Xác nhận lại mật khẩu', obscureText:true),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: signUp,style:ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  elevation: 4,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  )
              ),
                child:const Text('Đăng kí',style: TextStyle(fontSize: 17),),),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bạn đã có tài khoản ?',style: TextStyle(
                    color: Colors.black45
                  ),),
                  TextButton(onPressed: widget.onTap, child:const Text('Đăng nhập ngay',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> signUp()
   async {
    if(controllerPass.text!=controllerConfirmPass.text )
      {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xác nhận mật khẩu chưa đúng ')));
        return;
      }
    if( controllerNameUser.text.isEmpty)
      {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bạn chưa nhập họ và tên  ')));
        return;
      }
    final authService=Provider.of<AuthService>(context,listen: false);
    try
        {
          await authService.sigUpWithEmailPassWord(controllerEmail.text, controllerPass.text,controllerNameUser.text);
        }
        catch(e)
     {
       ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(e.toString())));

     }
  }
}
