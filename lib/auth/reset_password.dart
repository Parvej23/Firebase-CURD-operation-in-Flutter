import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailContoller= TextEditingController();
  resetPassword(email, contedt) async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e);
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _emailContoller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 60,
            left: 25,
            right: 25
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Forgot your password',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Enter your email and rest password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _emailContoller,
                  decoration: InputDecoration(
                    hintText: 'Email address',
                    prefixIcon: Icon(
                      Icons.email_outlined
                    )
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                ),
                ElevatedButton(
                  onPressed: ()=>resetPassword(_emailContoller.text,context),
                  child: Text('Reset Password'),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
