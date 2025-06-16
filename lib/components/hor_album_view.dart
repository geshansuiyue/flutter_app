import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:music_player/pages/search_result/type.dart';

class HorAlbumView extends StatelessWidget {
  final AlbumInfo album;

  const HorAlbumView({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final String artistName = album.artists.map((ar) => ar.name).join(' / ');
    DateTime dateTimeFromMillis = DateTime.fromMillisecondsSinceEpoch(
      album.publishTime,
    );
    final String publistDate = DateFormat(
      'yyyy-MM-dd',
    ).format(dateTimeFromMillis);

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 50,
        child: InkWell(
          onTap: () {
            context.push('/playlistDetail/${album.id}');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                album.picUrl,
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
                      album.name,
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          artistName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                        SizedBox(width: 5),
                        Text(
                          publistDate,
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
