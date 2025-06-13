import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/api/playlist/playlist.dart';
import 'package:music_player/components/cus_text_field.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/home/type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _searchQuery = '';
  List<String> _searchHistory = [];
  List<RecommendListItem> _recommendList = [];

  @override
  void initState() {
    super.initState();
    _loadRecommendList();
    _loadSearchQuery();
  }

  Future<void> _loadRecommendList() async {
    try {
      var response = await Request.get(
        PlayListApi().recommendPlaylist,
        queryParameters: {'limit': 6},
      );

      if (response['code'] == 200) {
        List<RecommendListItem> items = (response['result'] as List<dynamic>)
            .map(
              (item) => RecommendListItem(
                picUrl: item['picUrl'],
                id: item['id'],
                name: item['name'] ?? '',
              ),
            )
            .toList();
        setState(() {
          _recommendList = items;
        });
      } else {
        Fluttertoast.showToast(msg: '获取推荐歌单失败');
      }
    } catch (e) {
      // 处理异常
      Fluttertoast.showToast(msg: '获取歌单失败');
    }
  }

  void _onChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  Future<void> _loadSearchQuery() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedQueryList = prefs
        .getStringList('_searchQuery')
        ?.toList();

    if (savedQueryList != null) {
      setState(() {
        _searchHistory = savedQueryList;
      });
    }
  }

  Future<void> _saveSearchQuery() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedQueryList = prefs
        .getStringList('_searchQuery')
        ?.toList();
    if (savedQueryList != null && savedQueryList.contains(_searchQuery)) {
      // 如果查询已存在，则不保存
      return;
    }

    if (savedQueryList != null && savedQueryList.length >= 6) {
      savedQueryList.removeAt(0); // 删除最旧的查询
    }

    await prefs.setStringList('_searchQuery', [
      ...(savedQueryList ?? []),
      _searchQuery,
    ]);

    await _loadSearchQuery();
  }

  Future<void> _deleteSearchQuery(String query) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedQueryList = prefs
        .getStringList('_searchQuery')
        ?.toList();

    if (savedQueryList != null) {
      savedQueryList.remove(query);
      await prefs.setStringList('_searchQuery', savedQueryList);
      setState(() {
        _searchHistory.remove(query);
      });
    }
  }

  void _handleSearch() async {
    if (_searchQuery.isEmpty) {
      return;
    }
    await _saveSearchQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios, size: 17),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CusTextField(
                      onChanged: _onChanged,
                      autoFocus: true,
                      value: _searchQuery,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      _handleSearch();
                    },
                    child: Text('搜索'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.emoji_people_outlined),
                  onPressed: () {},
                  label: Text('歌手'),
                ),
                TextButton.icon(
                  icon: Icon(Icons.music_video_outlined),
                  onPressed: () {},
                  label: Text('曲风'),
                ),
                TextButton.icon(
                  icon: Icon(Icons.music_note_outlined),
                  onPressed: () {},
                  label: Text('专区'),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('搜索历史', style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('_searchQuery');
                      setState(() {
                        _searchHistory.clear();
                      });
                    },
                    child: Text('清除'),
                  ),
                ],
              ),
              Wrap(
                spacing: 8.0,
                children: (_searchHistory).map((query) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchQuery = query;
                      });
                      _handleSearch();
                    },
                    child: Chip(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      labelStyle: TextStyle(fontSize: 12),
                      backgroundColor: Colors.grey[200],
                      label: Text(query),
                      onDeleted: () async {
                        await _deleteSearchQuery(query);
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('猜你喜欢', style: TextStyle(fontSize: 16)),
              GridView.builder(
                shrinkWrap: true,
                itemCount: _recommendList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 30,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = _recommendList[index];

                  return GestureDetector(
                    onTap: () {
                      context.push('/playlistDetail/${item.id}');
                    },
                    child: Text(
                      item.name,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
