import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_curd/auth/reset_password.dart';
import 'package:firebase_curd/auth/signup_page.dart';
import 'package:firebase_curd/home_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController= TextEditingController();
  TextEditingController _passwordController= TextEditingController();
  signIn(email,pass, context)async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass,
      );
      var authCredential=credential.user;
      if(authCredential!.uid.isNotEmpty){
        Navigator.push(context,
          MaterialPageRoute(builder: (context)=>HomePage())
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
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
            right: 25,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome Back',style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w600
                ),),
                Text('Login to your account',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400
                ),),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email address',
                    prefixIcon: Icon(
                      Icons.email_outlined
                    ),
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.remove_red_eye_outlined
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text.rich(
                  TextSpan(text: 'Forgot your password?  ', children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()..onTap=()=>Navigator.push(
                          context,
                        MaterialPageRoute(builder: (_)=>ResetPassword())
                      ),
                      text: 'Reset Now',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.pinkAccent
                      )
                    )
                  ])
                ),
                Divider(
                  color: Colors.transparent,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: ()=>signIn(_emailController.text,_passwordController.text,context),
                    child: Text('Sign In'),
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Text.rich(
                  TextSpan(text:'Don\'t have an account?  ', children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()..onTap=()=>
                          Navigator.push(context,
                            MaterialPageRoute(builder: (_)=>SignUp())
                          ),
                      text: 'Create account',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue
                      )
                    )
                  ])
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
