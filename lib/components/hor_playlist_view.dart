import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/pages/home/type.dart';
import 'package:music_player/utils/helper.dart';

class HorPlaylistView extends StatelessWidget {
  final RecommendListItem playlist;

  const HorPlaylistView({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 50,
        child: InkWell(
          onTap: () {
            context.push('/playlistDetail/${playlist.id}');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                playlist.picUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.name,
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '${playlist.trackCount.toString()}首歌',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'by ${playlist.creator?.nickname}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '播放 ${NumberFormatUtil.formatWithUnit(playlist.playCount)}次',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
