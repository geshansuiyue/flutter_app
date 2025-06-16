import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/user/user_api.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';
import 'package:music_player/pages/play_detail/components/info.dart';
import 'package:music_player/store/audio_store.dart';
import 'package:music_player/store/type.dart';
import 'package:music_player/utils/helper.dart';
import 'package:provider/provider.dart';

import 'components/lyric.dart';

class PlayDetail extends StatefulWidget {
  const PlayDetail({super.key});

  @override
  State<PlayDetail> createState() => _PlayDetailState();
}

class _PlayDetailState extends State<PlayDetail> {
  SongItem? _song;
  bool _isPlaying = false;
  List<int> _likedList = [];
  bool _isShowLyric = false;
  late SongCommentInfo _songCommentInfo;

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
    final songCommentInfo = context.watch<AudioStore>().songCommentInfo;

    if (currentSong?.id != null) {
      setState(() {
        _song = currentSong;
        _isPlaying = isPlaying;
        _likedList = likedList;
        _songCommentInfo = songCommentInfo;
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

  void _changIsLyric(bool isLyric) {
    setState(() {
      _isShowLyric = isLyric;
    });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_song == null) {
      return const Center(child: Text('No song selected'));
    }

    final isLiked = _likedList.contains(_song!.id);
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
          padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
          child: Column(
            children: [
              _isShowLyric
                  ? LyricView(changeIsLyric: _changIsLyric)
                  : Info(
                      song: _song!,
                      total: _songCommentInfo.total,
                      isLiked: isLiked,
                      likeSong: _likeSong,
                      changeIsLyric: _changIsLyric,
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
