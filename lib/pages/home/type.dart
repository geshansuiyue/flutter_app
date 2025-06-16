class CarouselItem {
  final String pic;
  final String bannerId;
  final String typeTitle;

  CarouselItem({
    required this.pic,
    required this.bannerId,
    required this.typeTitle,
  });
}

class CarouselResponse {
  final List<CarouselItem> banners;

  CarouselResponse({required this.banners});
}

class ListCreator {
  final String nickname;
  final String avatarUrl;
  final int userId;

  ListCreator({
    required this.nickname,
    required this.avatarUrl,
    required this.userId,
  });

  factory ListCreator.fromJson(Map<String, dynamic> json) {
    return ListCreator(
      nickname: json['nickname'] as String,
      avatarUrl: json['avatarUrl'] as String,
      userId: json['userId'] as int,
    );
  }
}

class RecommendListItem {
  final int id;
  final String name;
  final String picUrl;
  final int trackCount;
  final int playCount;
  final ListCreator? creator;

  RecommendListItem({
    required this.id,
    required this.name,
    required this.picUrl,
    required this.trackCount,
    required this.playCount,
    this.creator,
  });

  factory RecommendListItem.fromJson(Map<String, dynamic> json) {
    return RecommendListItem(
      id: json['id'] as int,
      name: json['name'] as String,
      picUrl: (json['picUrl'] ?? json['coverImgUrl']) as String,
      trackCount: (json['trackCount'] ?? 0) as int,
      playCount: (json['playCount'] ?? 0) as int,
      creator: json['creator'] != null
          ? ListCreator.fromJson(json['creator'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ArInfo {
  final int id;
  final String name;

  ArInfo({required this.id, required this.name});
}

class AlInfo {
  final String picUrl;

  AlInfo({required this.picUrl});

  /// 工厂方法：从 Map 转换为 AlInfo 对象
  factory AlInfo.fromJson(Map<String, dynamic> json) {
    return AlInfo(picUrl: (json['picUrl'] ?? '') as String);
  }
}

class SongItem {
  final int id;
  final String name;
  final String mainTitle;
  final List<ArInfo> ar;
  final AlInfo al;

  SongItem({
    required this.id,
    required this.name,
    required this.mainTitle,
    required this.al,
    required this.ar,
  });

  factory SongItem.fromJson(Map<String, dynamic> json) {
    return SongItem(
      id: json['id'] as int,
      name: json['name'] as String,
      mainTitle: (json['mainTitle'] ?? '') as String,
      al: AlInfo.fromJson(
        (json['al'] ?? json['album']) as Map<String, dynamic>,
      ),
      ar: ((json['ar'] ?? json['artists']) as List<dynamic>)
          .map((e) => ArInfo(id: e['id'] as int, name: e['name'] as String))
          .toList(),
    );
  }
}
