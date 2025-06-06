import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/api/user/user_api.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';
import 'package:music_player/store/song_store.dart';
import 'package:music_player/utils/helper.dart';
import 'package:provider/provider.dart';

class PlayDetail extends StatefulWidget {
  const PlayDetail({super.key});

  @override
  State<PlayDetail> createState() => _PlayDetailState();
}

class _PlayDetailState extends State<PlayDetail> {
  SongItem? song;
  double _percent = 0.0;
  int _curSongTime = 0;
  bool _isPlaying = false;
  AudioPlayer? _player;
  List<int> _likedList = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      context.read<SongStoreModel>().fetchLikedList();
    }
    // 初始化或加载数据
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentSong = context.watch<SongStoreModel>().getSong();
    final curSongTime = context.watch<SongStoreModel>().getCurSongTime();
    final isPlaying = context.watch<SongStoreModel>().getIsPlaying();
    final player = context.watch<SongStoreModel>().getPlayer();
    final likedList = context.watch<SongStoreModel>().getLikedSongList();
    if (currentSong?.id != null) {
      setState(() {
        song = currentSong;
        _curSongTime = curSongTime;
        _isPlaying = isPlaying;
        _player = player;
        _likedList = likedList;
      });
    }
  }

  void _songControll(String type) {
    final songStore = context.read<SongStoreModel>();
    if (type == 'next') {
      songStore.songControll('next');
    } else if (type == 'prev') {
      songStore.songControll('prev');
    }
  }

  void _handlePlayControll() {
    if (_isPlaying) {
      _player?.pause();
      context.read<SongStoreModel>().setIsPlaying(false);
    } else {
      _player?.resume();
      context.read<SongStoreModel>().setIsPlaying(true);
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
          context.read<SongStoreModel>().fetchLikedList();
        }
      } else {
        Fluttertoast.showToast(msg: '请求失败，请重试');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '请求失败，请重试');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (song == null) {
      return const Center(child: Text('No song selected'));
    }

    final singersStr = song!.ar.map((ar) => ar.name).join('/');
    final isLiked = _likedList.contains(song!.id);

    return Center(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(15.0, 30.0, 15.0, 15.0),
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
                  Slider(
                    value: _percent,
                    onChanged: (value) {
                      Fluttertoast.showToast(msg: '滑动$value');
                      setState(() {
                        _percent = value;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 18.0, right: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatMilliseconds(_curSongTime)),
                        Text(formatMilliseconds(_curSongTime)),
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
