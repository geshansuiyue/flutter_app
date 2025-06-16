import 'package:flutter/widgets.dart';
import 'package:music_player/components/artist_info_view.dart';
import 'package:music_player/pages/search_result/type.dart';
import 'package:music_player/store/type.dart';
import 'package:music_player/store/user_store.dart';
import 'package:provider/provider.dart';

class Artists extends StatefulWidget {
  final List<ArtistInfo> artists;

  const Artists({super.key, required this.artists});

  @override
  State<Artists> createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  List<SubSingersInfo> _subSingers = [];

  @override
  void initState() {
    super.initState();

    context.read<UserStore>().fetchSubSingers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final subSingers = context.watch<UserStore>().subSingers;

    setState(() {
      _subSingers = subSingers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.artists.asMap().entries.map((entry) {
        final index = entry.key;
        final artist = entry.value;
        final marginBottom = index == widget.artists.length - 1 ? 0.0 : 10.0;
        final isSubscribed = _subSingers.any(
          (singer) => singer.id == artist.id,
        );

        return Column(
          children: [
            ArtistInfoView(info: artist, isSubed: isSubscribed),
            SizedBox(height: marginBottom),
          ],
        );
      }).toList(),
    );
  }
}
