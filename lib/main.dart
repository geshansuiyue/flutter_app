import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/components/play_info.dart';
import 'package:music_player/pages/play_detail/play_detail.dart';
import 'package:music_player/pages/playlist_detail/playlist_detail.dart';
import 'package:music_player/pages/home/home.dart';
import 'package:music_player/pages/search/search.dart';
import 'package:music_player/pages/search_result/search_result.dart';
import 'package:music_player/pages/song_comment/song_comment.dart';
import 'package:music_player/store/audio_store.dart';
import 'package:provider/provider.dart';
import 'pages/login/login.dart';

void main() {
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => BasePage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => BasePage(child: HomePage()),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => BasePage(child: Search()),
      ),
      GoRoute(
        path: '/playDetail',
        builder: (context, state) => BasePage(child: PlayDetail()),
      ),
      GoRoute(
        path: '/songComment',
        builder: (context, state) => BasePage(child: SongComment()),
      ),
      GoRoute(
        path: '/playlistDetail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return BasePage(child: PlaylistDetail(id: id));
        },
      ),
      GoRoute(
        path: '/searchResult/:keyword',
        builder: (context, state) {
          final keyword = state.pathParameters['keyword'];
          return BasePage(child: SearchResult(keyword: keyword ?? ''));
        },
      ),
    ],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => AudioStore()),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          primaryColor: Colors.blue, // 主色调（AppBar 背景）
          scaffoldBackgroundColor: Colors.white, // 页面背景色
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:
                  Colors.black54, // TextButton 文字颜色// TextButton 字体大小
            ),
          ),
          sliderTheme: SliderThemeData(
            activeTrackColor: Colors.blue, // 滑块轨道颜色
            inactiveTrackColor: Colors.grey, // 滑块未激活轨道颜色
            thumbColor: Colors.blue, // 滑块圆点颜色
          ),
        ),
        routerConfig: router,
        title: '音乐播放器',
      ),
    ),
  );
}

class BasePage extends StatelessWidget {
  final Widget child;

  const BasePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.only(top: 10), child: child),
      bottomNavigationBar: PlayInfo(), // 将播放栏放在这里
    );
  }
}
