import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/search/search.dart';
import 'package:music_player/components/cus_text_field.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/search_result/components/artists.dart';
import 'package:music_player/pages/search_result/components/playlists.dart';
import 'package:music_player/pages/search_result/components/songs.dart';
import 'package:music_player/pages/search_result/type.dart';

class SearchResult extends StatefulWidget {
  final String keyword;
  const SearchResult({super.key, required this.keyword});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> _tabs = SearchResultTypeEnum.searchTypes.items.map((type) {
    return Tab(text: type.name, key: Key(type.code.toString()));
  }).toList();
  late SearchResultInfo _searchResultInfo = SearchResultInfo(
    song: SearchSongsInfo(songs: []),
    playlist: SearchPlaylistInfo(playlists: []),
    artist: SearchArtistInfo(artists: []),
    album: SearchAlbumInfo(albums: []),
    // voice: SearchVoiceInfo(resources: []),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadSearchData();
  }

  Future<void> _loadSearchData() async {
    try {
      var response = await Request.get(
        SearchApi().search,
        queryParameters: {
          'keywords': widget.keyword,
          'type': SearchResultTypeEnum
              .searchTypes
              .items[_tabController.index]
              .code
              .toString(),
        },
      );

      if (response['code'] == 200) {
        setState(() {
          _searchResultInfo = SearchResultInfo.fromJson(response['result']);
        });
      } else {
        Fluttertoast.showToast(msg: '获取搜索结果失败');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取搜索结果失败');
    }
  }

  void _onChanged(String value) {
    // Handle text change
  }

  void _handleSearch() {
    // Handle search action
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
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
                      autoFocus: false,
                      value: widget.keyword,
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
          SizedBox(height: 20),
          TabBar(
            tabs: _tabs,
            dividerHeight: 0,
            indicatorColor: Colors.red,
            tabAlignment: TabAlignment.start,
            controller: _tabController,
            isScrollable: true,
            indicatorPadding: EdgeInsetsGeometry.zero,
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ), // 调整标签之间的间距
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      if (_searchResultInfo.artist.artists.isNotEmpty)
                        Artists(
                          artists: _searchResultInfo.artist.artists.sublist(
                            0,
                            1,
                          ),
                        ),
                      const SizedBox(height: 20), // 添加间距
                      Songs(songs: _searchResultInfo.song.songs),
                      const SizedBox(height: 20), // 添加间距
                      if (_searchResultInfo.playlist.playlists.isNotEmpty)
                        Playlists(
                          playlists: _searchResultInfo.playlist.playlists,
                        ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Songs(songs: _searchResultInfo.song.songs),
                ),
                SingleChildScrollView(
                  child: Playlists(
                    playlists: _searchResultInfo.playlist.playlists,
                  ),
                ),
                Songs(songs: []),
                Songs(songs: []),
                Songs(songs: []),
                Songs(songs: []),
                Songs(songs: []),
                Songs(songs: []),
                Songs(songs: []),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
