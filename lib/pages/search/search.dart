import 'package:flutter/material.dart';
import 'package:music_player/components/cus_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _searchQuery = '';
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchQuery();
  }

  void _onChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  /// 从共享首选项加载搜索查询历史记录并更新 `_searchHistory` 状态。
  ///
  /// 此方法使用键名 '_searchQuery' 从持久存储中检索之前保存的
  /// 搜索查询列表。如果列表存在，它会通过调用 `setState` 更新
  /// 本地 `_searchHistory` 变量。
  ///
  /// 通常在搜索页面初始化时使用此方法来恢复用户的搜索历史。

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
        ],
      ),
    );
  }
}
