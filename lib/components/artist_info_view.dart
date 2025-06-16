import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/api/artist/artist.dart';
import 'package:music_player/api/user/user_api.dart';
import 'package:music_player/http/request.dart';
import 'package:music_player/pages/search_result/type.dart';
import 'package:music_player/store/user_store.dart';
import 'package:music_player/utils/helper.dart';
import 'package:provider/provider.dart';

class ArtistInfoView extends StatefulWidget {
  final ArtistInfo info;
  final bool isSubed;
  const ArtistInfoView({super.key, required this.info, required this.isSubed});

  @override
  State<ArtistInfoView> createState() => _ArtistInfoViewState();
}

class _ArtistInfoViewState extends State<ArtistInfoView> {
  int _fansCount = 0;
  int _songsCount = 0;

  @override
  void initState() {
    super.initState();
    _queryArtistFans();
    _queryArtistSongs();
  }

  Future<void> _queryArtistFans() async {
    try {
      var response = await Request.get(
        ArtistApi().fans,
        queryParameters: {'id': widget.info.id},
      );

      if (response['code'] == 200) {
        setState(() {
          _fansCount = response['data']['fansCnt'];
        });
      } else {
        Fluttertoast.showToast(msg: '获取粉丝数量失败');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取粉丝数量失败');
    }
  }

  Future<void> _queryArtistSongs() async {
    try {
      var response = await Request.get(
        ArtistApi().songs,
        queryParameters: {'id': widget.info.id, 'limit': 1},
      );

      if (response['code'] == 200) {
        setState(() {
          _songsCount = response['total'];
        });
      } else {
        Fluttertoast.showToast(msg: '获取歌曲数量失败');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '获取歌曲数量失败');
    }
  }

  Future<void> _toggetSubSinger() async {
    try {
      var response = await Request.get(
        UserApi().toggleSubSinger,
        queryParameters: {
          'id': widget.info.id,
          't': widget.isSubed ? 2 : 1,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      if (response['code'] == 200) {
        if (mounted) {
          context.read<UserStore>().fetchSubSingers();
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '操作失败，请重试');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = '歌手: ${widget.info.name}';

    return InkWell(
      child: SizedBox(
        height: 45,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    widget.info.picUrl,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(221, 32, 6, 6),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '粉丝数: ${NumberFormatUtil.formatWithUnit(_fansCount)}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '歌曲数: $_songsCount',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: () {
                _toggetSubSinger();
              },
              child: Chip(
                label: Text(
                  widget.isSubed ? '取消关注' : '关注',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                backgroundColor: widget.isSubed ? Colors.red : Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
