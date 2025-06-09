import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/store/audio_store.dart';
import 'package:provider/provider.dart';

class CustomUINetease extends UINetease {
  @override
  TextStyle getPlayingMainTextStyle() =>
      TextStyle(color: Colors.red, fontSize: 14.0, fontWeight: FontWeight.bold);

  @override
  TextStyle getOtherMainTextStyle() => TextStyle(
    color: Colors.black45,
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  );

  TextStyle getMainTextStyle() =>
      TextStyle(color: Colors.grey, fontSize: defaultSize);
}

class LyricView extends StatefulWidget {
  const LyricView({super.key});

  @override
  State<LyricView> createState() => _LyricViewState();
}

class _LyricViewState extends State<LyricView> {
  String _lyric = "暂无歌词";
  bool _isPlaying = false;
  int currentPosition = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final lyric = context.watch<AudioStore>().lyric;
    final isPlaying = context.watch<AudioStore>().isPlaying;
    final position = context.watch<AudioStore>().position;

    setState(() {
      _lyric = lyric;
      _isPlaying = isPlaying;
      currentPosition = position.inMilliseconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    var lyricModel = LyricsModelBuilder.create()
        .bindLyricToMain(_lyric)
        .getModel();

    var customUI = CustomUINetease();

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // 速度为负，表示向左滑动
          context.pop();
        }
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: LyricsReader(
            model: lyricModel,
            position: currentPosition,
            lyricUi: customUI,
            playing: _isPlaying,
            size: Size(
              double.infinity,
              MediaQuery.of(context).size.height - 100,
            ),
            emptyBuilder: () => const Center(
              child: Text("暂无歌词", style: TextStyle(color: Colors.red)),
            ),
          ),
        ),
      ),
    );
  }
}
