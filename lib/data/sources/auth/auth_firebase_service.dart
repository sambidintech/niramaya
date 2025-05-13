import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotify_clone/data/models/auth/create_user_req.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';
abstract class AuthFirebaseService{

  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> signIn(SigninUserReq signinUserReq);

}

class AuthFirebaseServiceImpl extends AuthFirebaseService{
  @override
  Future<Either> signIn(SigninUserReq signinUserReq) async {
    try{

    final data= await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: signinUserReq.email,
          password: signinUserReq.password);
  print(data);
    String uid = data.user?.uid ?? '';
    // Save to SharedPreferences
    final storage = FlutterSecureStorage();

    await storage.write(key: 'user_uid', value: uid);


      return const Right('Sign In was Successful');
    } on FirebaseAuthException catch(e){
      String message ='';

      if(e.code=='invalid-email'){
        message='The email not found';
      }
      else if(e.code=='invalid-credential'){
        message='Invalid email or password';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try{

      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: createUserReq.email,
          password: createUserReq.password);

      FirebaseFirestore.instance.collection('Users').add(
          {
            'name': data.user?.displayName,
            'email':data.user?.email
          }
      );

      return const Right('Sign Up was Successful');
    } on FirebaseAuthException catch(e){
      String message ='';

      if(e.code=='weak-password'){
        message='The password is too weak';
      }
      else if(e.code=='email-already-in-use'){
        message='An account already exist with that email';
      }

      return Left(message);
    }

  }

}