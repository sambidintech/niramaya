import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_button.dart';
import 'package:spotify_clone/core/config/assets/app_vectors.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';
import 'package:spotify_clone/domain/usecases/auth/signin.dart';
import 'package:spotify_clone/presentation/auth/pages/sign_up.dart';
import 'package:spotify_clone/presentation/home/pages/admin_home.dart';

import '../../../service_locator.dart';
import '../../home/pages/home.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController _email =TextEditingController();
  final TextEditingController _password =TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: SvgPicture.asset(
            AppVectors.logo,
            height: 40,
            width: 20),
      ),
      bottomNavigationBar: _signInText(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              _signText(),
              const SizedBox(height: 75,),
              _emailField(context),
              const SizedBox(height: 15,),
              _passwordField(context),
              const SizedBox(height: 15,),
              _loginButton(context),
              BasicAppButton(onPressed: () async{
                var result = await sl<SignInUseCase>().call(
                params: SigninUserReq.signInUserReq(
                email: _email.text.toString(),
                password: _password.text.toString())
                );
                result.fold(
                (l){
                var snackBar=SnackBar(content: Text(l),
                behavior: SnackBarBehavior.floating);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                (r){
                Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context)=>const HomePage()),
                (route)=>false);
                });
              },
                  title: "Sign In")
            ],
          ),
        ),
      ),
    );
  }
  Widget _signText(){
    return const Text(
      'Sign In',
      style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold
      ),
      textAlign: TextAlign.center,
    );
  }
  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: const InputDecoration(
          hintText: 'Enter Email'
      ).applyDefaults(
          Theme.of(context).inputDecorationTheme
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: const InputDecoration(
          hintText: 'Password'
      ).applyDefaults(
          Theme.of(context).inputDecorationTheme
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
          if (_email.text == 'admin@niramaya.com' &&
              _password.text == 'niramaya') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminHome()),
            );
          }
        
      },
      child: const Text('Login'),
    );
  }

  Widget _signInText(BuildContext context){

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 30
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?'",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14
            ),),
          TextButton(
            onPressed: (){
              Navigator.push(context,
              MaterialPageRoute(builder: (context)=>SignUpPage()));
            },
            child: const Text(
              'Register',
              style: TextStyle(
                color: Colors.blueAccent,

              ),
            ),
          )
        ],
      ),
    );

  }

}
