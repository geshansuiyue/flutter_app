import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/song/song_api.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';

class PlayInfo extends StatefulWidget {
  const PlayInfo({super.key});

  @override
  State<PlayInfo> createState() => _PlayInfoState();
}

class _PlayInfoState extends State<PlayInfo> {
  SongItem? song;

  @override
  void initState() {
    super.initState();
    _querySongDetail();
  }

  Future<void> _querySongDetail() async {
    try {
      var response = await Request.get(
        SongApi().songDetail,
        queryParameters: {'ids': 347230},
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

        setState(() {
          song = songInfo;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取歌曲详情失败，请重试');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (song == null) {
      return SizedBox.shrink(); // 如果歌曲信息未加载，返回空组件
    }

    final arStr = song != null
        ? song?.ar.map((ar) => ar.name).join('/')
        : '暂无歌手信息'; // 将歌手列表转换为字符串

    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(20, 0, 20, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        child: Container(
          height: 60.0,
          color: const Color.fromARGB(255, 237, 222, 222),
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        image: NetworkImage(song!.al.picUrl),
                        width: 40,
                        height: 40,
                      ),
                    ),
                    SizedBox(width: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Text(
                            song!.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              color: const Color.fromARGB(255, 24, 23, 23),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            ' - $arStr',
                            style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.none,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Fluttertoast.showToast(msg: '点击了播放按钮');
                  },
                  icon: Icon(Icons.play_circle_outline, size: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
