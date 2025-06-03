import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/api/song/song_api.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';
import 'package:music_player/store/song_store.dart';
import 'package:provider/provider.dart';

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentSongId = context.watch<SongStoreModel>().getCurSongId();
    if (currentSongId != 0) {
      Fluttertoast.showToast(msg: currentSongId.toString());
      _querySongDetail(currentSongId);
    }
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

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
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
                  Expanded(
                    child: Row(
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
                        Expanded(
                          child: Marquee(
                            text: '${song!.name} - ${arStr!}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                            ),
                            scrollAxis: Axis.horizontal, // 滚动方向（水平/垂直）
                            crossAxisAlignment:
                                CrossAxisAlignment.center, // 垂直方向对齐
                            blankSpace: 20.0, // 首尾空白间距
                            velocity: 50.0, // 滚动速度（像素/秒）
                            fadingEdgeEndFraction: 0.1, // 渐隐边缘长度
                          ),
                        ),
                      ],
                    ),
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
      ),
    );
  }
}
