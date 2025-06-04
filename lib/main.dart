import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/components/play_info.dart';
import 'package:music_player/pages/play_detail/play_detail.dart';
import 'package:music_player/pages/playlist_detail/playlist_detail.dart';
import 'package:music_player/pages/home/home.dart';
import 'package:music_player/store/song_store.dart';
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
        path: '/playDetail',
        builder: (context, state) => BasePage(child: PlayDetail()),
      ),
      GoRoute(
        path: '/playlistDetail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return BasePage(child: PlaylistDetail(id: id));
        },
      ),
    ],
  );

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SongStoreModel())],
      child: MaterialApp.router(routerConfig: router, title: '音乐播放器'),
    ),
  );
}

class BasePage extends StatelessWidget {
  final Widget child;

  const BasePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: PlayInfo(), // 将播放栏放在这里
    );
  }
}
