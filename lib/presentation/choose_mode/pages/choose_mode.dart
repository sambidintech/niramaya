import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_button.dart';
import 'package:spotify_clone/presentation/auth/pages/signup_or_signin.dart';
import 'package:spotify_clone/presentation/choose_mode/bloc/theme_cubit.dart';

import '../../../core/config/assets/app_vectors.dart';

class ChooseModePage extends StatelessWidget {
  const ChooseModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
            color: Colors.black.withOpacity(0.15),

          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 40
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                      AppVectors.logo
                  ),
                ),
                const Spacer(),
                const Text(
                  'Choose Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                          GestureDetector(
                            onTap: (){
                              context.read<ThemeCubit>().updateTheme(ThemeMode.dark);

                            },

                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xff30393C).withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                  child: SvgPicture.asset(
                                      AppVectors.moon,
                                      fit: BoxFit.none
                                  )
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        const Text('Dark Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.white,
                        ),)
                      ],
                    ),
                    const SizedBox(width: 40),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            context.read<ThemeCubit>().updateTheme(ThemeMode.light);

                          },
                          child: InkWell(
                            highlightColor: Colors.grey,
                            child: ClipOval(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff30393C).withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                      AppVectors.sun,
                                      fit: BoxFit.none
                                  )
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        const Text('Light Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.white,
                          ),)
                      ]
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                BasicAppButton(onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context)=>const SignupOrSignInPage()));
                },
                    title: 'Continue'
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
