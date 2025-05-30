import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/home/home_api.dart';
import 'package:music_player/components/playlist_view.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';

class RecommendList extends StatefulWidget {
  const RecommendList({super.key});

  @override
  State<RecommendList> createState() => _RecommendListState();
}

class _RecommendListState extends State<RecommendList> {
  List<RecommendListItem> playList = [];

  @override
  void initState() {
    super.initState();
    _fetchRecommendList();
  }

  Future<void> _fetchRecommendList() async {
    try {
      var response = await Request.get(HomeApi().personalized);
      if (response['code'] == 200) {
        List<RecommendListItem> items = (response['recommend'] as List<dynamic>)
            .map(
              (item) => RecommendListItem(
                picUrl: item['picUrl'],
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
      child: Playlistview(playList: playList, title: '推荐歌单'),
    );
  }
}
