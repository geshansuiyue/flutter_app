import 'package:music_player/pages/home/type.dart';

class CreatorInfo {
  final int userId;
  final String nickname;
  final String avatarUrl;

  CreatorInfo({
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
  });

  /// 工厂方法：从 Map 转换为 CreatorInfo 对象
  factory CreatorInfo.fromJson(Map<String, dynamic> json) {
    return CreatorInfo(
      userId: json['userId'],
      nickname: json['nickname'],
      avatarUrl: json['avatarUrl'],
    );
  }
}

class ListDetailInfo {
  final int id;
  final String name;
  final int playCount;
  final String coverImgUrl;
  final String? description;
  final List<SongItem> tracks;
  final CreatorInfo creator;
  final int shareCount;
  final int commentCount;
  final int subscribedCount;

  ListDetailInfo({
    required this.id,
    required this.name,
    required this.playCount,
    required this.coverImgUrl,
    this.description,
    required this.tracks,
    required this.creator,
    required this.shareCount,
    required this.commentCount,
    required this.subscribedCount,
  });

  /// 工厂方法：从 Map 转换为 AlInfo 对象
  factory ListDetailInfo.fromJson(Map<String, dynamic> json) {
    return ListDetailInfo(
      id: json['id'],
      name: json['name'],
      shareCount: json['shareCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      subscribedCount: json['subscribedCount'] ?? 0,
      playCount: json['playCount'] ?? 0,
      coverImgUrl: json['coverImgUrl'],
      description: json['description'],
      tracks: (json['tracks'] as List<dynamic>)
          .map(
            (item) => SongItem(
              id: item['id'],
              name: item['name'] ?? '',
              mainTitle: item['mainTitle'] ?? '',
              al: AlInfo.fromJson(item['al']),
              ar: (item['ar'] as List<dynamic>)
                  .map(
                    (arItem) => ArInfo(id: arItem['id'], name: arItem['name']),
                  )
                  .toList(),
            ),
          )
          .toList(),
      creator: CreatorInfo.fromJson(json['creator']),
    );
  }
}
