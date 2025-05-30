import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/home/home_api.dart';
import 'package:music_player/components/playlist_view.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';

class MyPlaylist extends StatefulWidget {
  const MyPlaylist({super.key});

  @override
  State<MyPlaylist> createState() => _MyPlaylistState();
}

class _MyPlaylistState extends State<MyPlaylist> {
  List<RecommendListItem> playList = [];

  @override
  void initState() {
    super.initState();
    _fetchRecommendList();
  }

  Future<void> _fetchRecommendList() async {
    try {
      var response = await Request.get(
        HomeApi().myPlaylist,
        queryParameters: {'uid': 85321922},
      );
      if (response['code'] == 200) {
        List<RecommendListItem> items = (response['playlist'] as List<dynamic>)
            .map(
              (item) => RecommendListItem(
                picUrl: item['coverImgUrl'],
                id: item['id'],
                name: item['name'] ?? '',
              ),
            )
            .toList();
        setState(() {
          playList = items;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取推荐歌单失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Playlistview(playList: playList, title: '我的歌单'),
    );
  }
}
