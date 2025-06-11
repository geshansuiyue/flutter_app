import 'package:flutter/material.dart';
import 'package:music_player/pages/home/components/carousel.dart';
import 'package:music_player/pages/home/components/my_playlist.dart';
import 'package:music_player/pages/home/components/recommend_list.dart';
import 'package:music_player/pages/home/components/recommend_songs.dart';
import 'package:music_player/pages/home/components/top_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Carousel(),
          const RecommendList(),
          const RecommendSongs(),
          const MyPlaylist(),
          const TopList(),
        ],
      ),
    );
  }
}
