import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/pages/home/type.dart';
import 'package:music_player/store/audio_store.dart';
import 'package:provider/provider.dart';

class PlayInfo extends StatefulWidget {
  const PlayInfo({super.key});

  @override
  State<PlayInfo> createState() => _PlayInfoState();
}

class _PlayInfoState extends State<PlayInfo> {
  SongItem? song;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final curSongItem = context.watch<AudioStore>().song;
    final isPlaying = context.watch<AudioStore>().isPlaying;
    setState(() {
      song = curSongItem;
      _isPlaying = isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isPlayDetailPage = [
      '/playDetail',
      '/lyricView',
      '/songComment',
      '/search',
    ].contains(currentRoute);
    final audioProvider = Provider.of<AudioStore>(context);
    if (song == null) {
      return SizedBox.shrink(); // 如果歌曲信息未加载，返回空组件
    }

    final arStr = song != null
        ? song?.ar.map((ar) => ar.name).join('/')
        : '暂无歌手信息'; // 将歌手列表转换为字符串

    return Visibility(
      visible: !isPlayDetailPage,
      maintainState: true,
      maintainSize: false,
      maintainAnimation: true,
      child: SizedBox(
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
                child: InkWell(
                  onTap: () => context.push('/playDetail'),
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 180,
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
                          if (_isPlaying) {
                            audioProvider.pause();
                            setState(() {
                              _isPlaying = false;
                            });
                          } else {
                            audioProvider.resume();
                            setState(() {
                              _isPlaying = true;
                            });
                          }
                        },
                        icon: _isPlaying
                            ? Icon(Icons.pause_circle_outline, size: 30)
                            : Icon(Icons.play_circle_outline, size: 30),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
