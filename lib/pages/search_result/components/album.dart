import 'package:flutter/widgets.dart';
import 'package:music_player/components/hor_album_view.dart';
import 'package:music_player/pages/search_result/type.dart';

class Albums extends StatelessWidget {
  final List<AlbumInfo> albums;

  const Albums({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: albums.asMap().entries.map((entry) {
        final index = entry.key;
        final album = entry.value;
        final marginBottom = index == albums.length - 1 ? 0.0 : 10.0;

        return Column(
          children: [
            HorAlbumView(album: album),
            SizedBox(height: marginBottom),
          ],
        );
      }).toList(),
    );
  }
}
