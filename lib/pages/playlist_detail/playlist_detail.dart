import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/playlist/playlist.dart';
import 'package:music_player/components/song_info.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';
import 'package:music_player/pages/playlist_detail/type.dart';
import 'package:music_player/store/audio_store.dart';
import 'package:music_player/utils/helper.dart';
import 'package:provider/provider.dart';

class PlaylistDetail extends StatefulWidget {
  final String? id;

  const PlaylistDetail({super.key, required this.id});
  @override
  State<PlaylistDetail> createState() => _PlaylistDetailState();
}

class _PlaylistDetailState extends State<PlaylistDetail> {
  List<SongItem> songs = [];
  late ListDetailInfo playListDetail;
  final ScrollController _scrollController = ScrollController();
  final double _songHeight = 70.0; // AppBar的高度
  int prevIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchPlaylistDetail();
    _fetchAllSongs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final curSongIndex = context.watch<AudioStore>().curSongIndex;
    if (songs.isNotEmpty) {
      if (curSongIndex > 0 && curSongIndex != prevIndex) {
        // 如果当前歌曲在列表中，滚动到该歌曲位置
        _scrollterToIndex(curSongIndex);
        setState(() {
          prevIndex = curSongIndex;
        });
      }
    }
  }

  void _scrollterToIndex(int index) {
    final offset = index * _songHeight;

    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _fetchAllSongs() async {
    try {
      var response = await Request.get(
        PlayListApi().allListSongs,
        queryParameters: {'id': widget.id},
      );

      if (response['code'] == 200) {
        List<SongItem> items = (response['songs'] as List<dynamic>)
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
          songs = items;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取歌单歌曲失败');
    }
  }

  Future<void> _fetchPlaylistDetail() async {
    try {
      var response = await Request.get(
        PlayListApi().listDetail,
        queryParameters: {'id': widget.id},
      );
      if (response['code'] == 200) {
        ListDetailInfo info = response['playlist'] != null
            ? ListDetailInfo.fromJson(response['playlist'])
            : ListDetailInfo(
                id: 0,
                name: '',
                playCount: 0,
                coverImgUrl: '',
                description: '',
                tracks: [],
                shareCount: 0,
                commentCount: 0,
                subscribedCount: 0,
                creator: CreatorInfo(userId: 0, nickname: '', avatarUrl: ''),
              );
        setState(() {
          playListDetail = info;
        });

        if (mounted) {
          context.read<AudioStore>().setCurPlayListSongs(songs);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取歌单详情失败');
    }
  }

  void _handlePlayAll(BuildContext context) {
    if (songs.isEmpty) {
      Fluttertoast.showToast(msg: '歌单为空，无法播放');
    } else {
      context.read<AudioStore>().setCurSongId(songs[0].id);
      context.read<AudioStore>().setCurPlayList(
        songs.map((song) => song.id).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!songs.isNotEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => _handlePlayAll(context),
        backgroundColor: const Color.fromARGB(255, 119, 190, 223),
        child: Icon(Icons.play_arrow, size: 30, color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 25, 16, 16),
        child: RefreshIndicator(
          onRefresh: _fetchPlaylistDetail,
          child: SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(bottom: 10, top: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image(
                          image: NetworkImage(playListDetail.coverImgUrl),
                          width: 100,
                          height: 100,
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 142,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playListDetail.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                  child: Image(
                                    width: 20,
                                    height: 20,
                                    image: NetworkImage(
                                      playListDetail.creator.avatarUrl,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  playListDetail.creator.nickname,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  '${NumberFormatUtil.formatWithUnit(playListDetail.playCount)}次播放',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              playListDetail.description ?? '暂无简介',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Fluttertoast.showToast(msg: '分享功能暂未实现');
                      },
                      icon: const Icon(Icons.share_rounded),
                      label: Text(
                        NumberFormatUtil.formatWithUnit(
                          playListDetail.shareCount,
                        ),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Fluttertoast.showToast(msg: '评论功能暂未实现');
                      },
                      icon: const Icon(Icons.comment),
                      label: Text(
                        NumberFormatUtil.formatWithUnit(
                          playListDetail.commentCount,
                        ),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Fluttertoast.showToast(msg: '收藏功能暂未实现');
                      },
                      icon: const Icon(Icons.collections),
                      label: Text(
                        NumberFormatUtil.formatWithUnit(
                          playListDetail.subscribedCount,
                        ),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final item = songs[index];

                      final marginBottom = index == songs.length - 1
                          ? 0.0
                          : 10.0;

                      return Column(
                        children: [
                          SongInfo(song: item, isInPlaylist: true),
                          SizedBox(height: marginBottom),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
