import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/pages/home/type.dart';

class PlaylistView extends StatelessWidget {
  final List<RecommendListItem> playList;
  final String title;

  const PlaylistView({super.key, required this.playList, required this.title});

  void _handleToDetail(int id, BuildContext context) {
    context.push('/playlistDetail/$id');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: const Color.fromARGB(219, 0, 0, 0),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: playList.length,
                itemBuilder: (context, index) {
                  final item = playList[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _handleToDetail(item.id, context),
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image(
                              height: 100,
                              image: NetworkImage(item.picUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: 100,
                        child: Text(
                          item.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
