import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:music_player/api/album/album.dart';
import 'package:music_player/components/song_info.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/album_detail/type.dart';
import 'package:music_player/store/audio_store.dart';
import 'package:music_player/utils/helper.dart';
import 'package:provider/provider.dart';

class AlbumDetail extends StatefulWidget {
  final String? id;

  const AlbumDetail({super.key, required this.id});
  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetail> {
  AlbumInfo albumInfo = AlbumInfo(
    songs: [],
    coverUrl: '',
    album: AlubmDetail(
      name: '',
      id: '',
      picUrl: '',
      artists: [],
      description: '',
      albumIntInfo: AlbumIntInfo(commentCount: 0, shareCount: 0),
      publishTime: 0,
    ),
  );
  final ScrollController _scrollController = ScrollController();
  final double _songHeight = 70.0; // AppBar的高度
  int prevIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchPlaylistDetail();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final curSongIndex = context.watch<AudioStore>().curSongIndex;
    if (albumInfo.songs.isNotEmpty) {
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

  Future<void> _fetchPlaylistDetail() async {
    try {
      var response = await Request.get(
        AlbumApi().albumDetail,
        queryParameters: {'id': widget.id},
      );
      if (response['code'] == 200) {
        AlbumInfo info = AlbumInfo.fromJson(response);
        setState(() {
          albumInfo = info;
        });

        if (mounted) {
          context.read<AudioStore>().setCurPlayListSongs(info.songs);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取歌单详情失败');
    }
  }

  void _handlePlayAll(BuildContext context) {
    final songs = albumInfo.songs;

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
    final songs = albumInfo.songs;
    final artists = albumInfo.album.artists;
    final artistsStr = artists.isNotEmpty
        ? artists.map((artist) => artist.name).join(' / ')
        : '未知艺术家';

    DateTime dateTimeFromMillis = DateTime.fromMillisecondsSinceEpoch(
      albumInfo.album.publishTime,
    );
    final String publishDate = DateFormat(
      'yyyy-MM-dd',
    ).format(dateTimeFromMillis);

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
                          image: NetworkImage(albumInfo.album.picUrl),
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
                              albumInfo.album.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '歌手：$artistsStr',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '发行时间：$publishDate',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              albumInfo.album.description,
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
                          albumInfo.album.albumIntInfo.shareCount,
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
                          albumInfo.album.albumIntInfo.commentCount,
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
                          albumInfo.album.albumIntInfo.shareCount,
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
                          SongInfo(
                            song: item,
                            isInPlaylist: true,
                            needImg: false,
                          ),
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
