import 'package:get_it/get_it.dart';
import 'package:spotify_clone/data/repository/auth/auth_repository_impl.dart';
import 'package:spotify_clone/data/repository/song/song_repository_impl.dart';
import 'package:spotify_clone/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify_clone/data/sources/songs/song_firebase_service.dart';
import 'package:spotify_clone/domain/repository/authentication/auth.dart';
import 'package:spotify_clone/domain/repository/song/song.dart';
import 'package:spotify_clone/domain/usecases/auth/signin.dart';
import 'package:spotify_clone/domain/usecases/song/get_news_songs.dart';

import 'domain/usecases/auth/signup.dart';

final sl =GetIt.instance;

Future<void> initializeDependencies() async{
  sl.registerSingleton<AuthFirebaseService>(
      AuthFirebaseServiceImpl()
  );
  sl.registerSingleton<AuthRepository>(
      AuthRepositoryImpl()
  );
  sl.registerSingleton<SongsRepository>(
      SongRepositoryImpl()
  );

  sl.registerSingleton<SignUpUseCase>(
      SignUpUseCase()
  );
  sl.registerSingleton<SignInUseCase>(
      SignInUseCase()
  );
  sl.registerSingleton<GetNewsSongsUseCase>(
      GetNewsSongsUseCase()
  );
  sl.registerSingleton<SongFirebaseService>(
      SongFirebaseServiceImpl()
  );

}