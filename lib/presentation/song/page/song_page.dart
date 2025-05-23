import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:spotify_clone/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/core/config/assets/app_images.dart';
import 'package:spotify_clone/core/config/assets/app_vectors.dart';
import 'package:spotify_clone/core/config/theme/app_color.dart';
import 'package:spotify_clone/presentation/song/widgets/news_songs.dart';



class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: true,
        // action: IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (BuildContext context) => const ProfilePage())
        //       );
        //     },
        //     icon: const Icon(
        //         Icons.person
        //     )
        // ),
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _homeTopCard(),
            _tabs(),
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: _tabController,
                children: [
                  const NewsSongs(),
                  Container(),
                  Container(),
                  Container()
                ],
              ),
            ),
            // const PlayList()
          ],
        ),
      ),
    );
  }

  Widget _homeTopCard(){
    return Center(
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                  AppVectors.homeTopCard
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 60
                ),
                child: Image.asset(
                    AppImages.homeArtist
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      indicatorColor: AppColor.primary,
      padding: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 16
      ),
      tabs: const [
        Text(
          'News',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16
          ),
        ),
        Text(
          'Videos',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16
          ),
        ),
        Text(
          'Artists',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16
          ),
        ),
        Text(
          'Podcasts',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16
          ),
        )
      ],
    );
  }
}

