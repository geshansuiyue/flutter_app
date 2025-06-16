import 'package:flutter/widgets.dart';
import 'package:music_player/components/hor_playlist_view.dart';
import 'package:music_player/pages/home/type.dart';

class Playlists extends StatelessWidget {
  final List<RecommendListItem> playlists;

  const Playlists({super.key, required this.playlists});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: playlists.asMap().entries.map((entry) {
        final index = entry.key;
        final playlist = entry.value;
        final marginBottom = index == playlists.length - 1 ? 0.0 : 10.0;

        return Column(
          children: [
            HorPlaylistView(playlist: playlist),
            SizedBox(height: marginBottom),
          ],
        );
      }).toList(),
    );
  }
}
