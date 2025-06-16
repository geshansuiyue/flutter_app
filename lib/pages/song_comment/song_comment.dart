import 'package:flutter/material.dart';
import 'package:music_player/components/comment_info.dart';
import 'package:music_player/pages/home/type.dart';
import 'package:music_player/store/audio_store.dart';
import 'package:music_player/store/type.dart';
import 'package:provider/provider.dart';

class SongComment extends StatefulWidget {
  const SongComment({super.key});

  @override
  State<SongComment> createState() => _SongCommentState();
}

class _SongCommentState extends State<SongComment>
    with SingleTickerProviderStateMixin {
  SongItem? song;
  SongCommentInfo songCommentInfo = SongCommentInfo(
    total: 0,
    hotComments: [],
    comments: [],
  );
  late TabController tabController;
  int offset = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final curSongItem = context.watch<AudioStore>().song;
    final curSongCommentInfo = context.watch<AudioStore>().songCommentInfo;
    final curOffset = context.watch<AudioStore>().offset;

    setState(() {
      song = curSongItem;
      songCommentInfo = curSongCommentInfo;
      offset = curOffset;
    });
  }

  Future<void> _loadMoreComments() async {
    await context.read<AudioStore>().querySongComments(song!.id, offset + 1);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arStr = song!.ar.map((ar) => ar.name).join('/');
    final mainTitle = song!.mainTitle.isNotEmpty ? ' - ${song!.mainTitle}' : '';
    final songArtistStr = song?.ar.map((ar) => ar.name).join('/') ?? '暂无歌手信息';
    final str = '${song!.name} - $arStr$mainTitle';

    return Scaffold(
      appBar: AppBar(title: Text('评论')),
      body: Padding(
        padding: EdgeInsets.fromLTRB(18, 20, 18, 18),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(
                    image: NetworkImage(song!.al.picUrl),
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 180,
                  child: Text(
                    str,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    songArtistStr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  height: 35,
                  child: Text('评论数(${songCommentInfo.total})'),
                ),
                Expanded(
                  child: TabBar(
                    dividerHeight: 0,
                    isScrollable: false,
                    controller: tabController,
                    indicator: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 0,
                        ),
                      ),
                    ),
                    tabs: const [
                      Tab(text: '热门'),
                      Tab(text: '最新'),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController, // 关联控制器
                children: [
                  CommentInfo(
                    comments: songCommentInfo.hotComments,
                    loadMoreComments: _loadMoreComments,
                    isHotComments: true,
                  ),
                  CommentInfo(
                    comments: songCommentInfo.comments,
                    loadMoreComments: _loadMoreComments,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
