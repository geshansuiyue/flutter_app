import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/api/user/user_api.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';
import 'package:music_player/store/audio_store.dart';
import 'package:music_player/utils/helper.dart';
import 'package:provider/provider.dart';

class PlayDetail extends StatefulWidget {
  const PlayDetail({super.key});

  @override
  State<PlayDetail> createState() => _PlayDetailState();
}

class _PlayDetailState extends State<PlayDetail> {
  SongItem? song;
  bool _isPlaying = false;
  List<int> _likedList = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      context.read<AudioStore>().fetchLikedList();
    }
    // 初始化或加载数据
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentSong = context.watch<AudioStore>().song;
    final isPlaying = context.watch<AudioStore>().isPlaying;
    final likedList = context.watch<AudioStore>().likedSongList;

    if (currentSong?.id != null) {
      setState(() {
        song = currentSong;
        _isPlaying = isPlaying;
        _likedList = likedList;
      });
    }
  }

  void _songControll(String type) {
    final songStore = context.read<AudioStore>();
    if (type == 'next') {
      songStore.songControll('next');
    } else if (type == 'prev') {
      songStore.songControll('prev');
    }
  }

  void _handleSlideSeek(double value) {}

  void _handlePlayControll() {
    if (_isPlaying) {
      context.read<AudioStore>().pause();
    } else {
      final isCompleted = context.read<AudioStore>().isCompleted;
      if (isCompleted) {
        context.read<AudioStore>().replay();
      } else {
        context.read<AudioStore>().resume();
      }
    }
  }

  Future<void> _likeSong(int id, bool isLiked) async {
    try {
      var response = await Request.get(
        UserApi().favorite,
        queryParameters: {
          'id': id,
          'like': !isLiked,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      if (response['code'] == 200) {
        if (mounted) {
          context.read<AudioStore>().fetchLikedList();
        }
      } else {
        Fluttertoast.showToast(msg: '请求失败，请重试');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '请求失败，请重试');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (song == null) {
      return const Center(child: Text('No song selected'));
    }

    final singersStr = song!.ar.map((ar) => ar.name).join('/');
    final isLiked = _likedList.contains(song!.id);
    final curDuration = context.watch<AudioStore>().duration;
    final curPosition = context.watch<AudioStore>().position;
    final percent = curDuration > Duration.zero
        ? (curPosition.inMilliseconds / curDuration.inMilliseconds) > 1.0
              ? 1.0
              : (curPosition.inMilliseconds / curDuration.inMilliseconds)
        : 0.0;

    return Center(
      child: SizedBox(
        child: Padding(
          // 修复：使用 EdgeInsets 而不是 EdgeInsetsGeometry
          padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.expand_more_sharp, size: 30),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      song!.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // 占位符，保持对齐
                ],
              ),
              SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(song!.al.picUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song!.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          singersStr,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          tooltip: isLiked ? '不喜欢' : '喜欢',
                          onPressed: () => _likeSong(song!.id, isLiked),
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                          ),
                          color: isLiked ? Colors.red : Colors.black,
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.message)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 修复：添加 Container 为 Slider 提供约束
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Slider(
                      value: percent,
                      onChanged: (value) {
                        _handleSlideSeek(value);
                      },
                    ),
                  ),
                  Padding(
                    // 修复：使用 EdgeInsets 而不是 EdgeInsetsGeometry
                    padding: EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 修复：时间显示可能需要调整
                        Text(formatDuration(curPosition)),
                        Text(formatDuration(curDuration)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.reorder, size: 35),
                    onPressed: () {
                      Fluttertoast.showToast(msg: '随机播放');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_previous, size: 40),
                    onPressed: () {
                      _songControll('prev');
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                    ),
                    onPressed: () {
                      _handlePlayControll();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, size: 40),
                    onPressed: () {
                      _songControll('next');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.playlist_play, size: 35),
                    onPressed: () {
                      Fluttertoast.showToast(msg: '循环播放');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
