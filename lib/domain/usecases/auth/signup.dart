import 'package:dartz/dartz.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/data/models/auth/create_user_req.dart';
import 'package:spotify_clone/domain/repository/authentication/auth.dart';

import '../../../service_locator.dart';

class SignUpUseCase implements UseCase<Either,CreateUserReq>{
  @override
  Future<Either> call({CreateUserReq ? params}) async {

    return sl<AuthRepository>().signup(params!);

  }

}