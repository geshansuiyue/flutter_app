import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/home/home_api.dart';
import 'package:music_player/components/song_info.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';

class RecommendSongs extends StatefulWidget {
  const RecommendSongs({super.key});

  @override
  State<RecommendSongs> createState() => _RecommendSongsState();
}

class _RecommendSongsState extends State<RecommendSongs> {
  List<SongItem> songList = [];

  @override
  void initState() {
    super.initState();
    _fetchRecommendSongs();
  }

  Future<void> _fetchRecommendSongs() async {
    try {
      var response = await Request.get(HomeApi().recommendSongs);
      if (response['code'] == 200) {
        List<SongItem> items = (response['data']['dailySongs'] as List<dynamic>)
            .map(
              (item) => SongItem(
                id: item['id'],
                name: item['name'] ?? '',
                mainTitle: item['mainTitle'] ?? '',
                al: AlInfo.fromJson(item['al']),
                ar: (item['ar'] as List<dynamic>)
                    .map(
                      (arItem) =>
                          ArInfo(id: arItem['id'], name: arItem['name']),
                    )
                    .toList(),
              ),
            )
            .toList();
        setState(() {
          songList = items;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取推荐歌曲失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '推荐歌曲',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: const Color.fromARGB(219, 0, 0, 0),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: songList.length > 3 ? 3 : songList.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = songList[index];
                final marginBottom = index == 2 || index == songList.length - 1
                    ? 0.0
                    : 10.0;

                return Column(
                  children: [
                    SongInfo(song: item),
                    SizedBox(height: marginBottom),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
