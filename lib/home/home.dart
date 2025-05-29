import 'package:flutter/material.dart';
import 'package:music_player/components/carousel/carousel.dart';
import 'package:music_player/home/components/recommend_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('主页')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: Carousel()),
            Expanded(child: RecommendList()),
          ],
        ),
      ),
    );
  }
}
