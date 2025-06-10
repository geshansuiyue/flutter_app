import 'package:flutter/material.dart';
import 'package:music_player/store/type.dart';

class CommentInfo extends StatelessWidget {
  final List<SongCommentItem> comments;

  const CommentInfo({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
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
                        icon: Icon(Icons.thumb_up_outlined),
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
    );
  }
}
