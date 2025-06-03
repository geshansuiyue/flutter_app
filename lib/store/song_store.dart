import 'package:flutter/material.dart';

class SongStoreModel with ChangeNotifier {
  int curSongId = 0;
  int getCurSongId() => curSongId;

  void setCurSongId(int id) {
    curSongId = id;
    notifyListeners();
  }
}
