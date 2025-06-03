import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/components/play_info.dart';
import 'package:music_player/pages/playlist_detail/playlist_detail.dart';
import 'package:music_player/pages/home/home.dart';
import 'pages/login/login.dart';

void main() {
  final router = GoRouter(
    initialLocation: '/playlistDetail/152833237',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/playlistDetail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return PlaylistDetail(id: id);
        },
      ),
    ],
  );

  runApp(PersistentFooterApp(router: router));
}

class PersistentFooterApp extends StatelessWidget {
  final GoRouter router;

  const PersistentFooterApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: '音乐播放器',
      builder: (context, child) {
        // 使用 Stack 将底部组件固定在所有页面下方
        return Stack(
          children: [
            // 主内容区域（路由页面）
            if (child != null) child,

            // 固定在底部的组件
            Positioned(left: 0, right: 0, bottom: 0, child: PlayInfo()),
          ],
        );
      },
    );
  }
}
