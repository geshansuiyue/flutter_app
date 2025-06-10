import 'package:flutter/material.dart';
import 'package:music_player/store/type.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CommentInfo extends StatefulWidget {
  final List<SongCommentItem> comments;
  final Future<void> Function() loadMoreComments;
  final bool isHotComments;

  const CommentInfo({
    super.key,
    required this.comments,
    required this.loadMoreComments,
    this.isHotComments = false,
  });

  @override
  State<CommentInfo> createState() => _CommentInfoState();
}

class _CommentInfoState extends State<CommentInfo> {
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  Future<void> _loading() async {
    await widget.loadMoreComments();

    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: false,
      enablePullUp: !widget.isHotComments,
      onLoading: _loading,
      child: ListView.builder(
        itemCount: widget.comments.length,
        itemBuilder: (context, index) {
          final comment = widget.comments[index];
          final userInfo = comment.user;

          return ListTile(
            contentPadding: EdgeInsets.all(0),
            titleAlignment: ListTileTitleAlignment.titleHeight,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.network(
                userInfo.avatarUrl,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userInfo.nickname, style: TextStyle(fontSize: 13)),
                        Text(
                          comment.timeStr,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          comment.likedCount.toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            comment.liked
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            color: comment.liked ? Colors.red : Colors.grey,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(comment.content, style: TextStyle(fontSize: 13)),
              ],
            ),
          );
        },
      ),
    );
  }
}
