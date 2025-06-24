import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/core/config/assets/app_images.dart';
import 'package:spotify_clone/core/config/assets/app_vectors.dart';
import 'package:spotify_clone/presentation/auth/pages/sign_up.dart';
import 'package:spotify_clone/presentation/auth/pages/signin.dart';

class SignupOrSignInPage extends StatelessWidget {
  const SignupOrSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BasicAppBar(),
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              AppVectors.topPattern
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(
                AppVectors.bottomPattern
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: SvgPicture.asset(
                AppImages.authBG
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppVectors.logo),
                  const SizedBox(height: 21,),
                  const Text(
                    'Please log in to System',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                    ),
                  ),
                  const SizedBox(height: 21,),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                          },
                          child: Text('Register',
                            style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: context.isDarkMode ? Colors.white: Colors.black
                        ),
                        ),
                      ),),

                      const SizedBox(width: 20,),
                      Expanded(
                        child: TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));

                        },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: context.isDarkMode ? Colors.white: Colors.black
                              ),
                            )),
                      )
                    ],
                  ),
                  Expanded(
                    child: TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));

                    },
                        child: Text(
                          'Admin Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: context.isDarkMode ? Colors.white: Colors.black
                          ),
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
