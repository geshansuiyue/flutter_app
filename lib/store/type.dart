class UserInfo {
  int userId;
  String nickname;
  String avatarUrl;

  UserInfo({
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
  });
}

class SongCommentItem {
  UserInfo user;
  String content;
  int commentId;
  int likedCount;
  String timeStr;
  bool liked;

  SongCommentItem({
    required this.user,
    required this.content,
    required this.commentId,
    required this.likedCount,
    required this.timeStr,
    required this.liked,
  });
}

class SongCommentInfo {
  int total;
  List<SongCommentItem> hotComments;
  List<SongCommentItem> comments;

  SongCommentInfo({
    required this.total,
    required this.hotComments,
    required this.comments,
  });

  factory SongCommentInfo.fromJson(Map<String, dynamic> json) {
    // 处理 hotComments 列表
    final hotCommentsList = json['hotComments'] as List<dynamic>? ?? [];
    final hotComments = hotCommentsList
        .map(
          (cm) => SongCommentItem(
            user: UserInfo(
              userId: cm['user']['userId'] as int? ?? 0,
              avatarUrl: cm['user']['avatarUrl'] as String? ?? '',
              nickname: cm['user']['nickname'] as String? ?? '',
            ),
            commentId: cm['commentId'] as int? ?? 0,
            content: cm['content'] as String? ?? '',
            likedCount: cm['likedCount'] as int? ?? 0,
            liked: cm['liked'] as bool? ?? false,
            timeStr: cm['timeStr'] as String? ?? '',
          ),
        )
        .toList();

    // 处理 comments 列表
    final commentsList = json['comments'] as List<dynamic>? ?? [];
    final comments = commentsList
        .map(
          (cm) => SongCommentItem(
            user: UserInfo(
              userId: cm['user']['userId'] as int? ?? 0,
              avatarUrl: cm['user']['avatarUrl'] as String? ?? '',
              nickname: cm['user']['nickname'] as String? ?? '',
            ),
            commentId: cm['commentId'] as int? ?? 0,
            content: cm['content'] as String? ?? '',
            likedCount: cm['likedCount'] as int? ?? 0,
            liked: cm['liked'] as bool? ?? false,
            timeStr: cm['timeStr'] as String? ?? '',
          ),
        )
        .toList();

    return SongCommentInfo(
      total: json['total'] as int? ?? 0,
      hotComments: hotComments,
      comments: comments,
    );
  }
}
