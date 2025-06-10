import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/song/song_api.dart';
import 'package:music_player/api/user/user_api.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';
import 'package:music_player/store/type.dart';

class AudioStore with ChangeNotifier {
  late AudioPlayer _player;
  bool _isPlaying = false;
  bool _isCompleted = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int _curSongId = 0;
  int _curSongIndex = 0;
  List<int> _playList = [];
  SongItem? _song;
  List<int> _likedSongList = [];
  List<SongItem> _playListSongs = [];
  String _lyric = '';
  String _tlyric = '';
  SongCommentInfo _songCommentInfo = SongCommentInfo(
    total: 0,
    hotComments: [],
    comments: [],
  );
  int _offset = 0;

  AudioPlayer get player => _player;
  bool get isPlaying => _isPlaying;
  bool get isCompleted => _isCompleted;
  Duration get duration => _duration;
  Duration get position => _position;
  int get curSongId => _curSongId;
  int get curSongIndex => _curSongIndex;
  List<int> get curPlayList => _playList;
  SongItem? get song => _song;
  List<int> get likedSongList => _likedSongList;
  String get lyric => _lyric;
  String get tlyric => _tlyric;
  SongCommentInfo get songCommentInfo => _songCommentInfo;
  int get offset => _offset;

  AudioStore() {
    _initializePlayer();
  }

  void _initializePlayer() {
    _player = AudioPlayer(
      playerId: 'audio_store_player_${DateTime.now().millisecondsSinceEpoch}',
    );

    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      _isCompleted = false;
      notifyListeners();
    });

    _player.onPositionChanged.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _player.onDurationChanged.listen((dur) {
      _duration = dur;
      notifyListeners();
    });

    _player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        _isCompleted = true;
        _isPlaying = false;
        songControll('next');
        notifyListeners();
      }
    });
  }

  // 播放控制方法
  Future<void> play(String url) async {
    try {
      await _player.stop();
      await Future.delayed(Duration(milliseconds: 100));
      await _player.play(UrlSource(url));
      notifyListeners();
    } catch (e) {
      // 如果播放失败，重新初始化播放器再尝试一次
      try {
        await _player.dispose();
        _initializePlayer();
        await Future.delayed(Duration(milliseconds: 200));
        await _player.play(UrlSource(url));
        notifyListeners();
      } catch (e2) {
        Fluttertoast.showToast(msg: '播放失败，请重试');
      }
    }
  }

  Future<void> replay() async {
    await _player.seek(Duration.zero);
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> resume() async {
    await _player.resume();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setCurSongId(int id, {bool? isInPlaylist}) async {
    _curSongId = id;
    if (isInPlaylist == true && _playListSongs.isNotEmpty) {
      final list = _playListSongs.map((song) => song.id).toList();
      _curSongIndex = list.indexOf(id);
      _playList = list;
    } else {
      final index = _playList.indexOf(id);
      if (index >= 0) {
        _curSongIndex = index;
      } else {
        // 如果歌曲不在播放列表中，添加到播放列表
        _playList.add(id);
        _curSongIndex = _playList.length - 1;
      }
    }
    await querySongDetail(id);
    await queryMusicUrl(id);
    await queryLyric(id);
    await querySongComments(id, 0);
    notifyListeners();
  }

  void setCurPlayList(List<int> list) {
    _playList = list;
    notifyListeners();
  }

  void setLikedSongList(List<int> list) {
    _likedSongList = list;
    notifyListeners();
  }

  void setCurPlayListSongs(List<SongItem> list) {
    _playListSongs = list;
    _curSongIndex = 0;
    notifyListeners();
  }

  void songControll(String type) {
    final listLength = _playList.length;
    if (type == 'next') {
      if (_curSongIndex < listLength - 1) {
        setCurSongId(_playList[_curSongIndex + 1]);
      } else {
        Fluttertoast.showToast(msg: '已经是最后一首歌了');
      }
    } else {
      if (_curSongIndex > 0) {
        setCurSongId(_playList[_curSongIndex - 1]);
      } else {
        Fluttertoast.showToast(msg: '已经是第一首歌了');
      }
    }
  }

  Future<void> querySongDetail(int songId) async {
    try {
      var response = await Request.get(
        SongApi().songDetail,
        queryParameters: {'ids': songId},
      );
      if (response['code'] == 200) {
        var curSongInfo = response['songs'][0];

        var songInfo = SongItem(
          id: curSongInfo['id'],
          name: curSongInfo['name'] ?? '',
          mainTitle: curSongInfo['mainTitle'] ?? '',
          al: AlInfo.fromJson(curSongInfo['al']),
          ar: (curSongInfo['ar'] as List<dynamic>)
              .map((arItem) => ArInfo(id: arItem['id'], name: arItem['name']))
              .toList(),
        );

        _song = songInfo;
        notifyListeners();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取歌曲详情失败，请重试');
    }
  }

  Future<void> fetchLikedList() async {
    try {
      var response = await Request.get(
        UserApi().favoriteList,
        queryParameters: {
          'uid': 85321922,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      if (response['code'] == 200) {
        var likedSongs = response['ids'] as List<dynamic>;
        var likedSongIds = likedSongs.map((id) => id as int).toList();
        setLikedSongList(likedSongIds);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取我的喜欢列表失败');
    }
  }

  Future<void> queryMusicUrl(int songId) async {
    try {
      var response = await Request.get(
        SongApi().songUrl,
        queryParameters: {'level': 'standard', 'id': songId},
      );
      if (response['code'] == 200) {
        var info = response['data'];
        var musicInfo = info[0];
        if (musicInfo['url'] != null) {
          await play(musicInfo['url']);
        } else {
          Fluttertoast.showToast(msg: '无版权，为您切换下一首');
        }
      }
      // ignore: empty_catches
    } catch (e) {
      Fluttertoast.showToast(msg: '获取歌曲链接失败，请重试');
    }
  }

  Future<void> queryLyric(int songId) async {
    try {
      var response = await Request.get(
        SongApi().lyric,
        queryParameters: {'id': songId},
      );

      if (response['code'] == 200) {
        _lyric = response['lrc']?['lyric'] ?? '';
        _tlyric = response['tlyric']?['lyric'] ?? '';
        notifyListeners();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取歌词失败，请重试');
    }
  }

  Future<void> querySongComments(int songId, int offset) async {
    try {
      var response = await Request.get(
        SongApi().songComment,
        queryParameters: {'id': songId, 'offset': offset, 'limit': 20},
      );

      if (response['code'] == 200) {
        var curSongCommentInfo = SongCommentInfo.fromJson(response);
        if (offset == 0) {
          _songCommentInfo = curSongCommentInfo;
        } else {
          _songCommentInfo.comments.addAll(curSongCommentInfo.comments);
          _songCommentInfo.hotComments.addAll(curSongCommentInfo.hotComments);
        }
        _offset = offset;

        notifyListeners();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取歌曲评论失败，请重试');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
