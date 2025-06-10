import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/pages/home/type.dart';

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.song,
    required this.isLiked,
    required this.likeSong,
    required this.changeIsLyric,
  });
  final SongItem song;
  final bool isLiked;
  final Function(int, bool) likeSong;
  final Function(bool) changeIsLyric;

  @override
  Widget build(BuildContext context) {
    final singersStr = song.ar.map((ar) => ar.name).join('/');

    return SizedBox(
      height: MediaQuery.of(context).size.height - 220,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.expand_more_sharp, size: 30),
                onPressed: () {
                  context.pop();
                },
              ),
              SizedBox(
                width: 200,
                child: Text(
                  song.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 15.0, color: Colors.black87),
                ),
              ),
              const SizedBox(width: 48), // 占位符，保持对齐
            ],
          ),
          SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: () {
                changeIsLyric(true);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(song.al.picUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 23),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      singersStr,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      tooltip: isLiked ? '不喜欢' : '喜欢',
                      onPressed: () => likeSong(song.id, isLiked),
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                      ),
                      color: isLiked ? Colors.red : Colors.black,
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.message)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
