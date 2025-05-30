import 'package:flutter/material.dart';
import 'package:music_player/pages/home/type.dart';

class SongInfo extends StatelessWidget {
  final SongItem song;

  const SongInfo({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final arStr = song.ar.map((ar) => ar.name).join('/');
    final mainTitle = song.mainTitle.isNotEmpty ? ' - ${song.mainTitle}' : '';

    return (SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
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
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    Text(
                      '$arStr$mainTitle',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(children: [Icon(Icons.play_arrow, color: Colors.black54)]),
        ],
      ),
    ));
  }
}
