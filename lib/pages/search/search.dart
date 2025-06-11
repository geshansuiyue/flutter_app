import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/components/cus_text_field.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _searchQuery = '';

  void _onChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _handleSearch() {
    Fluttertoast.showToast(msg: '搜索内容: $_searchQuery');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsetsGeometry.all(0),
        child: ListView(
          children: [
            SizedBox(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(child: CusTextField(onChanged: _onChanged)),
                  TextButton(
                    onPressed: () {
                      _handleSearch();
                    },
                    child: Text('搜索'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ],
        ),
      ),
    );
  }
}
