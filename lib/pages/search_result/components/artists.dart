import 'package:flutter/widgets.dart';
import 'package:music_player/components/artist_info_view.dart';
import 'package:music_player/pages/search_result/type.dart';

class Artists extends StatelessWidget {
  final List<ArtistInfo> artists;

  const Artists({super.key, required this.artists});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: artists.asMap().entries.map((entry) {
        final index = entry.key;
        final artist = entry.value;
        final marginBottom = index == artists.length - 1 ? 0.0 : 10.0;

        return Column(
          children: [
            ArtistInfoView(info: artist),
            SizedBox(height: marginBottom),
          ],
        );
      }).toList(),
    );
  }
}
