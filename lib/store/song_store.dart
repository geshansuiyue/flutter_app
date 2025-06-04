import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/song/song_api.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';

class SongStoreModel with ChangeNotifier {
  int curSongId = 0;
  List<int> songList = [];
  SongItem? song;

  int getCurSongId() => curSongId;
  List<int> getSongList() => songList;
  SongItem? getSong() => song;

  Future<void> setCurSongId(int id) async {
    curSongId = id;
    await _querySongDetail(id);
    notifyListeners();
  }

  void setCurSongList(List<int> list) {
    songList = list;
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
}
