import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/core/config/constants/app_urls.dart';
import 'package:spotify_clone/presentation/song/bloc/news_songs_cubit.dart';
import 'package:spotify_clone/presentation/song/bloc/news_songs_state.dart';

import '../../../domain/entities/song/song.dart';

class NewsSongs extends StatelessWidget {
  const NewsSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_)=> NewsSongsCubit()..getNewsSongs(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<NewsSongsCubit,NewsSongsState>(
          builder: (context, state){
            // if(state is NewsSongsLoading){
            //   return Container(
            //       alignment:Alignment.center,
            //       child: const CircularProgressIndicator());
            // }
            if(state is NewsSongsLoaded){
              return _songs(state.songs);
            }
            return Container();
          },
        )

      ),
    );
  }
  Widget _songs(List<SongEntity> songs){
    return ListView.separated(
      scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){
          return SizedBox(
            width: 160,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                          image: NetworkImage(
                            '${AppUrls.fireStorage}${songs[index].artist} - ${songs[index].title}.jpg?${AppUrls.mediaAlt}',
                          )
                      )
                    ),
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index)=>const SizedBox(width: 14),
        itemCount: songs.length
    );
  }
}
