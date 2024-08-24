import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_button.dart';
import 'package:spotify_clone/core/config/assets/app_vectors.dart';
import 'package:spotify_clone/domain/usecases/auth/signup.dart';
import 'package:spotify_clone/data/models/auth/create_user_req.dart';
import 'package:spotify_clone/presentation/auth/pages/signin.dart';

import '../../../service_locator.dart';
import '../../home/pages/home.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _fullName= TextEditingController();
  final TextEditingController _email= TextEditingController();
  final TextEditingController _password= TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: SvgPicture.asset(
            AppVectors.logo,
        height: 40,
            width: 20),
      ),
      bottomNavigationBar: _signinText(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              _registerText(),
              const SizedBox(height: 75,),
              _fullNameField(context),
              const SizedBox(height: 15,),
              _emailField(context),
              const SizedBox(height: 15,),
              _passwordField(context),
              const SizedBox(height: 15,),

              BasicAppButton(
                  onPressed: () async {
                var result = await sl<SignUpUseCase>().call(
                  params: CreateUserReq(
                      fullName: _fullName.text.toString(),
                      email: _email.text.toString(),
                      password: _password.text.toString())
                );
                // Navigator.push(context,
                //   MaterialPageRoute(builder: (BuildContext context)=>const HomePage()),
                // );
                result.fold(
                        (l){
                          // var snackBar=const SnackBar(content: Text('Error Occurred'),
                          //     behavior: SnackBarBehavior.floating);
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context)=>const HomePage()),
                          );
                        },
                        (r){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context)=>const HomePage()),
                              );
                        });
              },
                  title: "Create Account")
            ],
          ),
        ),
      ),
    );
  }
  Widget _registerText(){
    return const Text(
        'Register',
    style: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold
    ),
    textAlign: TextAlign.center,
    );
}
  Widget _fullNameField(BuildContext context){
    return TextField(
      controller: _fullName,
      decoration: const InputDecoration(
        hintText: 'Full Name'
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme
      ),
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
      obscureText: true,
      decoration: const InputDecoration(
          hintText: 'Password'
      ).applyDefaults(
          Theme.of(context).inputDecorationTheme
      ),
    );
  }

  Widget _signinText(BuildContext context){

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Do You have an account?',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14
          ),),
          TextButton(
            onPressed: (){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context)=> SignInPage()));
            },
            child: const Text(
              'Sign In',
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
