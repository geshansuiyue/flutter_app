import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/pages/playlist_detail/playlist_detail.dart';
import 'package:music_player/pages/home/home.dart';
import 'pages/login/login.dart';

void main() {
  final router = GoRouter(
    initialLocation: '/playlistDetail/12501254691',
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

  runApp(MaterialApp.router(routerConfig: router, title: '音乐播放器'));
}
