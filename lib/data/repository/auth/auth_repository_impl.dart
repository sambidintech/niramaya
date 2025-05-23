import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/models/auth/create_user_req.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';
import 'package:spotify_clone/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify_clone/domain/repository/authentication/auth.dart';
import 'package:spotify_clone/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository{
  @override
  Future<Either> signIn(SigninUserReq signinUserReq) async{

    return await sl<AuthFirebaseService>().signIn(signinUserReq);

  }

  @override
  Future<Either> signup(CreateUserReq createUserRew) async{
    return await sl<AuthFirebaseService>().signup(createUserRew);
  }

}