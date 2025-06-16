import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/pages/home/components/carousel.dart';
import 'package:music_player/pages/home/components/my_playlist.dart';
import 'package:music_player/pages/home/components/recommend_list.dart';
import 'package:music_player/pages/home/components/recommend_songs.dart';
import 'package:music_player/pages/home/components/top_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 70,
            child: Padding(
              padding: EdgeInsets.fromLTRB(18, 10, 18, 20),
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: Colors.grey,
                    selectionColor: Colors.red,
                  ),
                ),
                child: SearchBar(
                  autoFocus: false,
                  onTap: () => context.push('/search'),
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.search_outlined,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                  onTapOutside: (event) {
                    focusNode.unfocus();
                  },
                  hintText: '搜索音乐、歌手、歌词',
                  hintStyle: WidgetStateProperty.all<TextStyle?>(
                    TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  focusNode: focusNode,
                ),
              ),
            ),
          ),
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
