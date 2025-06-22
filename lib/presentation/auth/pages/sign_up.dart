import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_button.dart';
import 'package:spotify_clone/core/config/assets/app_vectors.dart';
import 'package:spotify_clone/domain/usecases/auth/signup.dart';
import 'package:spotify_clone/data/models/auth/create_user_req.dart';
import 'package:spotify_clone/presentation/auth/pages/signin.dart';

import '../../../service_locator.dart';
  
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
                          var snackBar=const SnackBar(content: Text('Error Occurred'),
                              behavior: SnackBarBehavior.floating);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        },
                        (r){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context)=> SignInPage()),
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
    return TextFormField(
      controller: _email,
      decoration: const InputDecoration(
        hintText: 'Enter Email',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        const emailPattern =
            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
        final regex = RegExp(emailPattern);

        if (value == null || value.isEmpty) {
          return 'Email is required';
        } else if (!regex.hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextFormField(
      controller: _password,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        const passwordPattern =
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
        final regex = RegExp(passwordPattern);

        if (value == null || value.isEmpty) {
          return 'Password is required';
        } else if (!regex.hasMatch(value)) {
          return 'Password must be at least 8 characters, include upper and lower case letters, a number, and a special character.';
        }
        return null;
      },
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
