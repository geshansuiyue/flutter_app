import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/user/user_api.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/store/type.dart';

class UserStore with ChangeNotifier {
  List<SubSingersInfo> _subSingers = [];

  List<SubSingersInfo> get subSingers => _subSingers;

  Future<void> fetchSubSingers() async {
    try {
      var response = await Request.get(
        UserApi().subSingers,
        queryParameters: {
          'limit': 1000,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      if (response['code'] == 200) {
        _subSingers = response['data']
            .map<SubSingersInfo>((item) => SubSingersInfo.fromJson(item))
            .toList();
        notifyListeners();
      } else {
        Fluttertoast.showToast(msg: '获取关注歌手失败');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取关注歌手失败');
    }
  }
}
