import 'package:flutter/material.dart';

class RecommendList extends StatefulWidget {
  const RecommendList({super.key});

  @override
  State<RecommendList> createState() => _RecommendListState();
}

class _RecommendListState extends State<RecommendList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const Text('推荐列表'),
          // 限制水平列表的高度
          SizedBox(
            height: 100, // 设置适当的高度
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 20,
              itemBuilder: (context, index) {
                // 使用Card或Container替代ListTile
                return Container(
                  width: 200, // 设置每个项目的宽度
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('推荐歌曲 ${index + 1}'),
                      Text('歌手 ${index + 1}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
