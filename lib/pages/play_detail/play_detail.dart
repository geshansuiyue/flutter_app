import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/store/song_store.dart';
import 'package:provider/provider.dart';

class PlayDetail extends StatefulWidget {
  const PlayDetail({super.key});

  @override
  State<PlayDetail> createState() => _PlayDetailState();
}

class _PlayDetailState extends State<PlayDetail> {
  @override
  void initState() {
    super.initState();
    // 初始化或加载数据
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentSongId = context.watch<SongStoreModel>().getCurSongId();
    if (currentSongId != 0) {
      Fluttertoast.showToast(msg: '当前播放的歌曲ID: $currentSongId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(onTap: () => context.pop(), child: const Text('播放详情')),
    );
  }
}
