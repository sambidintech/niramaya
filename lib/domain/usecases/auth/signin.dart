import 'package:dartz/dartz.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';

import '../../../service_locator.dart';
import '../../repository/authentication/auth.dart';


class SignInUseCase implements UseCase<Either,SigninUserReq>{

  @override
  Future<Either> call({SigninUserReq ? params}) async {
  return sl<AuthRepository>().signIn(params!);
  }

}