import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/sources/songs/song_firebase_service.dart';
import 'package:spotify_clone/domain/repository/song/song.dart';

import '../../../service_locator.dart';

class SongRepositoryImpl extends SongsRepository{

  @override
  Future<Either> getNewsSongs() {
   return sl<SongFirebaseService>().getNewsSongs();
  }

}