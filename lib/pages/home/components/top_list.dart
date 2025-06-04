import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/home/home_api.dart';
import 'package:music_player/components/playlist_view.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';

class TopList extends StatefulWidget {
  const TopList({super.key});

  @override
  State<TopList> createState() => _TopListState();
}

class _TopListState extends State<TopList> {
  List<RecommendListItem> list = [];

  @override
  void initState() {
    super.initState();
    _fetchTopList();
  }

  Future<void> _fetchTopList() async {
    try {
      var response = await Request.get(HomeApi().topList);
      if (response['code'] == 200) {
        List<RecommendListItem> items = (response['list'] as List<dynamic>)
            .map(
              (item) => RecommendListItem(
                id: item['id'],
                name: item['description'] ?? '',
                picUrl: item['coverImgUrl'],
              ),
            )
            .toList()
            .sublist(0, 6);
        setState(() {
          list = items;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取排行榜失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Playlistview(playList: list, title: '排行榜'),
    );
  }
}
