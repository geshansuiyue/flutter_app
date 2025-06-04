import 'package:flutter/material.dart';

class SongStoreModel with ChangeNotifier {
  int curSongId = 0;
  List<int> songList = [];

  int getCurSongId() => curSongId;
  List<int> getSongList() => songList;

  void setCurSongId(int id) {
    curSongId = id;
    notifyListeners();
  }

  void setCurSongList(List<int> list) {
    songList = list;
    notifyListeners();
  }
}
