import 'package:music_player/pages/home/type.dart';

class SearchResultTypeItem {
  final String name;
  final int code;

  SearchResultTypeItem({required this.name, required this.code});
}

class SearchResultType {
  List<SearchResultTypeItem> items;

  SearchResultType({required this.items});
}

class SearchResultTypeEnum {
  static final SearchResultType searchTypes = SearchResultType(
    items: [
      SearchResultTypeItem(name: '综合', code: 1018),
      SearchResultTypeItem(name: '单曲', code: 1),
      SearchResultTypeItem(name: '歌单', code: 1000),
      SearchResultTypeItem(name: '专辑', code: 10),
      SearchResultTypeItem(name: '播客', code: 1009),
      SearchResultTypeItem(name: '歌手', code: 100),
      SearchResultTypeItem(name: '用户', code: 1002),
      SearchResultTypeItem(name: '歌词', code: 1006),
      SearchResultTypeItem(name: '视频', code: 1014),
      SearchResultTypeItem(name: '声音', code: 2000),
    ],
  );
}

class SearchSongsInfo {
  final List<SongItem> songs;

  SearchSongsInfo({required this.songs});

  factory SearchSongsInfo.fromJson(Map<String, dynamic> json) {
    return SearchSongsInfo(
      songs: (json['songs'] as List).map((e) => SongItem.fromJson(e)).toList(),
    );
  }
}

class SearchPlaylistInfo {
  final List<RecommendListItem> playlists;

  SearchPlaylistInfo({required this.playlists});

  factory SearchPlaylistInfo.fromJson(Map<String, dynamic> json) {
    return SearchPlaylistInfo(
      playlists: (json['playLists'] as List)
          .map((e) => RecommendListItem.fromJson(e))
          .toList(),
    );
  }
}

class ArtistInfo {
  final String name;
  final int id;
  final String picUrl;

  ArtistInfo({required this.name, required this.id, required this.picUrl});

  factory ArtistInfo.fromJson(Map<String, dynamic> json) {
    return ArtistInfo(
      name: json['name'] as String,
      id: json['id'] as int,
      picUrl: json['picUrl'] as String,
    );
  }
}

class SearchArtistInfo {
  final List<ArtistInfo> artists;

  SearchArtistInfo({required this.artists});

  factory SearchArtistInfo.fromJson(Map<String, dynamic> json) {
    return SearchArtistInfo(
      artists: (json['artists'] as List)
          .map((e) => ArtistInfo.fromJson(e))
          .toList(),
    );
  }
}

class AlbumInfo {
  final String name;
  final int id;
  final String picUrl;
  final int publishTime;

  AlbumInfo({
    required this.publishTime,
    required this.name,
    required this.id,
    required this.picUrl,
  });

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    return AlbumInfo(
      publishTime: json['publishTime'] as int,
      name: json['name'] as String,
      id: json['id'] as int,
      picUrl: json['blurPicUrl'] as String,
    );
  }
}

final class SearchAlbumInfo {
  final List<AlbumInfo> albums;

  SearchAlbumInfo({required this.albums});

  factory SearchAlbumInfo.fromJson(Map<String, dynamic> json) {
    return SearchAlbumInfo(
      albums: (json['albums'] as List)
          .map((e) => AlbumInfo.fromJson(e))
          .toList(),
    );
  }
}

class VoiceInfo {
  final String name;
  final String description;
  final String coverUrl;
  final int id;
  final int listenerCount;

  VoiceInfo({
    required this.name,
    required this.description,
    required this.coverUrl,
    required this.id,
    required this.listenerCount,
  });

  factory VoiceInfo.fromJson(Map<String, dynamic> json) {
    return VoiceInfo(
      name: json['name'] as String,
      description: json['description'] as String,
      coverUrl: json['coverUrl'] as String,
      id: json['id'] as int,
      listenerCount: json['listenerCount'] as int,
    );
  }
}

class SearchVoiceInfo {
  final List<VoiceInfo> resources;

  SearchVoiceInfo({required this.resources});

  factory SearchVoiceInfo.fromJson(Map<String, dynamic> json) {
    return SearchVoiceInfo(
      resources: (json['resources'] as List)
          .map((e) => VoiceInfo.fromJson(e))
          .toList(),
    );
  }
}

class UserInfo {
  final String nickname;
  final int userId;
  final String avatarUrl;
  final String detailDescription;

  UserInfo({
    required this.nickname,
    required this.userId,
    required this.avatarUrl,
    required this.detailDescription,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      nickname: json['nickname'] as String,
      userId: json['userId'] as int,
      avatarUrl: json['avatarUrl'] as String,
      detailDescription: json['detailDescription'] as String,
    );
  }
}

class SearchResultInfo {
  final SearchSongsInfo song;
  final SearchPlaylistInfo playlist;
  final SearchArtistInfo artist;
  final SearchAlbumInfo album;
  // final SearchVoiceInfo voice;

  SearchResultInfo({
    required this.song,
    required this.playlist,
    required this.artist,
    required this.album,
    // required this.voice,
  });

  factory SearchResultInfo.fromJson(Map<String, dynamic> json) {
    return SearchResultInfo(
      song: SearchSongsInfo.fromJson(json['song']),
      playlist: SearchPlaylistInfo.fromJson(json['playList']),
      artist: SearchArtistInfo.fromJson(json['artist']),
      album: SearchAlbumInfo.fromJson(json['album']),
      // voice: SearchVoiceInfo.fromJson(json['voicelist']),
    );
  }
}
