import 'package:flutter/material.dart';
import 'package:music_player/pages/home/type.dart';
import 'package:music_player/store/audio_store.dart';
import 'package:provider/provider.dart';

class SongInfo extends StatelessWidget {
  final SongItem song;
  final bool? isInPlaylist;
  final bool needImg;

  const SongInfo({
    super.key,
    required this.song,
    this.isInPlaylist,
    this.needImg = true,
  });

  void _handlePlaySong(BuildContext context, int songId) {
    // 可能需要更新当前播放的歌曲ID
    context.read<AudioStore>().setCurSongId(songId, isInPlaylist: isInPlaylist);
  }

  @override
  Widget build(BuildContext context) {
    final arStr = song.ar.map((ar) => ar.name).join('/');
    final mainTitle = song.mainTitle.isNotEmpty ? ' - ${song.mainTitle}' : '';

    return InkWell(
      onTap: () => _handlePlaySong(context, song.id),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                if (needImg)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image(
                      image: NetworkImage(song.al.picUrl),
                      width: 60,
                      height: 60,
                    ),
                  ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            song.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            '$arStr$mainTitle',
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _handlePlaySong(context, song.id);
                  },
                  icon: Icon(Icons.play_arrow, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
