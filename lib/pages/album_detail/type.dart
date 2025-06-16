import 'package:music_player/pages/home/type.dart';
import 'package:music_player/pages/search_result/type.dart';

class AlbumIntInfo {
  final int commentCount;
  final int shareCount;

  AlbumIntInfo({required this.commentCount, required this.shareCount});

  factory AlbumIntInfo.fromJson(Map<String, dynamic> json) {
    return AlbumIntInfo(
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
    );
  }
}

class AlubmDetail {
  final String name;
  final String id;
  final String picUrl;
  final List<ArtistInfo> artists;
  final String description;
  final AlbumIntInfo albumIntInfo;
  final int publishTime;

  AlubmDetail({
    required this.name,
    required this.id,
    required this.picUrl,
    required this.artists,
    required this.description,
    required this.albumIntInfo,
    required this.publishTime,
  });

  factory AlubmDetail.fromJson(Map<String, dynamic> json) {
    return AlubmDetail(
      name: json['name'] ?? '',
      id: json['id']?.toString() ?? '',
      picUrl: json['picUrl'] ?? '',
      artists: (json['artists'] as List)
          .map((artist) => ArtistInfo.fromJson(artist))
          .toList(),
      description: json['description'] ?? '',
      albumIntInfo: AlbumIntInfo.fromJson(json['info']),
      publishTime: json['publishTime'] ?? 0,
    );
  }
}

class AlbumInfo {
  final List<SongItem> songs;
  final String coverUrl;
  final AlubmDetail album;

  AlbumInfo({required this.songs, required this.coverUrl, required this.album});

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    return AlbumInfo(
      songs: (json['songs'] as List)
          .map((song) => SongItem.fromJson(song))
          .toList(),
      coverUrl: json['coverUrl'] ?? '',
      album: AlubmDetail.fromJson(json['album']),
    );
  }
}
