import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:music_player/store/audio_store.dart';
import 'package:provider/provider.dart';

class CustomUINetease extends UINetease {
  CustomUINetease() {
    // 设置行间距
    lineGap = 16.0; // 歌词行之间的间距（默认通常是16-20）
    inlineGap = 4.0; // 主歌词和翻译歌词之间的间距（默认通常是10）
  }

  @override
  TextStyle getPlayingMainTextStyle() =>
      TextStyle(color: Colors.red, fontSize: 14.0, fontWeight: FontWeight.bold);

  @override
  TextStyle getOtherMainTextStyle() => TextStyle(
    color: Colors.black45,
    fontSize: 13.0,
    fontWeight: FontWeight.bold,
  );

  TextStyle getMainTextStyle() =>
      TextStyle(color: Colors.grey, fontSize: defaultSize);

  @override
  TextStyle getPlayingExtTextStyle() => TextStyle(
    color: Colors.red.withValues(alpha: 0.8),
    fontSize: 13.0,
    fontWeight: FontWeight.normal,
  );

  @override
  TextStyle getOtherExtTextStyle() =>
      TextStyle(color: Colors.grey.withValues(alpha: 0.7), fontSize: 12.0);
}

class LyricView extends StatefulWidget {
  const LyricView({super.key, required this.changeIsLyric});

  final Function(bool) changeIsLyric;

  @override
  State<LyricView> createState() => _LyricViewState();
}

class _LyricViewState extends State<LyricView> {
  String _lyric = "暂无歌词";
  String _tlyric = "";
  bool _isPlaying = false;
  int currentPosition = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final lyric = context.watch<AudioStore>().lyric;
    final tlyric = context.watch<AudioStore>().tlyric;
    final isPlaying = context.watch<AudioStore>().isPlaying;
    final position = context.watch<AudioStore>().position;

    setState(() {
      _lyric = lyric;
      _tlyric = tlyric;
      _isPlaying = isPlaying;
      currentPosition = position.inMilliseconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    var lyricModelBuilder = LyricsModelBuilder.create().bindLyricToMain(_lyric);

    if (_tlyric.isNotEmpty) {
      lyricModelBuilder.bindLyricToExt(_tlyric);
    }

    var lyricModel = lyricModelBuilder.getModel();

    var customUI = CustomUINetease();

    return SizedBox(
      height: MediaQuery.of(context).size.height - 220,
      child: GestureDetector(
        onTap: () {
          widget.changeIsLyric(false);
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: LyricsReader(
              model: lyricModel,
              position: currentPosition,
              lyricUi: customUI,
              playing: _isPlaying,
              onTap: () {
                widget.changeIsLyric(false);
              },
              size: Size(
                double.infinity,
                MediaQuery.of(context).size.height - 250,
              ),
              emptyBuilder: () => const Center(
                child: Text("暂无歌词", style: TextStyle(color: Colors.red)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
