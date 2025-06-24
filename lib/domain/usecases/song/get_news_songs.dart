import 'package:dartz/dartz.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/data/repository/song/song_repository_impl.dart';

import '../../../service_locator.dart';

class GetNewsSongsUseCase implements UseCase<Either,dynamic>{

  @override
  Future<Either> call({params}) async {

    return await sl<SongRepositoryImpl>().getNewsSongs();

  }

}