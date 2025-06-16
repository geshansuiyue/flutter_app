import 'package:flutter/material.dart';
import 'package:music_player/components/song_info.dart';
import 'package:music_player/pages/home/type.dart';

class Songs extends StatelessWidget {
  final List<SongItem> songs;

  const Songs({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: songs.asMap().entries.map((entry) {
        final index = entry.key;
        final song = entry.value;
        final marginBottom = index == songs.length - 1 ? 0.0 : 10.0;

        return Column(
          children: [
            SongInfo(song: song, needImg: false),
            SizedBox(height: marginBottom),
          ],
        );
      }).toList(),
    );
  }
}
