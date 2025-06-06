import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/song/song_api.dart';
import 'package:music_player/api/user/user_api.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';

class SongStoreModel with ChangeNotifier {
  int curSongId = 0;
  int curSongTime = 0;
  int curSongIndex = 0;
  List<int> songList = [];
  SongItem? song;
  bool _isPlaying = false;
  AudioPlayer? player;
  List<int> likedSongList = [];
  int duration = 0;
  Timer? timer;

  int getCurSongId() => curSongId;
  List<int> getSongList() => songList;
  SongItem? getSong() => song;
  int getCurSongTime() => curSongTime;
  bool getIsPlaying() => _isPlaying;
  AudioPlayer? getPlayer() => player;
  List<int> getLikedSongList() => likedSongList;
  int getDuration() => duration;
  Timer? getTimer() => timer;

  Future<void> setCurSongId(int id) async {
    curSongId = id;
    if (songList.isNotEmpty) {
      curSongIndex = songList.indexOf(id);
    }
    await _querySongDetail(id);
    timer?.cancel();
    duration = 0;
    notifyListeners();
  }

  void setCurSongList(List<int> list) {
    songList = list;
    notifyListeners();
  }

  void setCurSongTime(int time) {
    curSongTime = time;
    notifyListeners();
  }

  void setCurSongIndex(int index) {
    curSongIndex = index;
  }

  void setIsPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    if (!isPlaying) {
      timer?.cancel();
    } else {
      startTimer();
    }
    notifyListeners();
  }

  void setPlayer(AudioPlayer audioPlayer) {
    player = audioPlayer;
  }

  void setLikedSongList(List<int> list) {
    likedSongList = list;
    notifyListeners();
  }

  void songControll(String type) {
    final listLength = songList.length;
    if (type == 'next') {
      if (curSongIndex < listLength - 1) {
        setCurSongId(songList[curSongIndex + 1]);
        setCurSongIndex(curSongIndex + 1);
      } else {
        Fluttertoast.showToast(msg: '已经是最后一首歌了');
      }
    } else {
      if (curSongIndex > 0) {
        curSongIndex--;
        setCurSongId(songList[curSongIndex]);
      } else {
        Fluttertoast.showToast(msg: '已经是第一首歌了');
      }
    }
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      duration = duration + 1000;
      notifyListeners();
    });
  }

  void clearTimer() {
    duration = 0;
    timer?.cancel();
    notifyListeners();
  }

  Future<void> _querySongDetail(int songId) async {
    try {
      var response = await Request.get(
        SongApi().songDetail,
        queryParameters: {'ids': songId},
      );
      if (response['code'] == 200) {
        var curSongInfo = response['songs'][0];

        var songInfo = SongItem(
          id: curSongInfo['id'],
          name: curSongInfo['name'] ?? '',
          mainTitle: curSongInfo['mainTitle'] ?? '',
          al: AlInfo.fromJson(curSongInfo['al']),
          ar: (curSongInfo['ar'] as List<dynamic>)
              .map((arItem) => ArInfo(id: arItem['id'], name: arItem['name']))
              .toList(),
        );

        song = songInfo;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取歌曲详情失败，请重试');
    }
  }

  Future<void> fetchLikedList() async {
    try {
      var response = await Request.get(
        UserApi().favoriteList,
        queryParameters: {
          'uid': 85321922,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      if (response['code'] == 200) {
        var likedSongs = response['ids'] as List<dynamic>;
        var likedSongIds = likedSongs.map((id) => id as int).toList();
        setLikedSongList(likedSongIds);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取我的喜欢列表失败');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
