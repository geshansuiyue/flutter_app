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

class RecommendListItem {
  final int id;
  final String name;
  final String picUrl;

  RecommendListItem({
    required this.id,
    required this.name,
    required this.picUrl,
  });

  factory RecommendListItem.fromJson(Map<String, dynamic> json) {
    return RecommendListItem(
      id: json['id'] as int,
      name: json['name'] as String,
      picUrl: (json['picUrl'] ?? json['coverImgUrl']) as String,
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
    return AlInfo(picUrl: json['picUrl'] as String);
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
      al: AlInfo.fromJson(json['al'] as Map<String, dynamic>),
      ar: (json['ar'] as List<dynamic>)
          .map((e) => ArInfo(id: e['id'] as int, name: e['name'] as String))
          .toList(),
    );
  }
}
