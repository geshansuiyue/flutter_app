import 'package:flutter/material.dart';

class CusTextField extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();
  final void Function(String)? onChanged;

  CusTextField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.grey,
      enableInteractiveSelection: false,
      focusNode: _focusNode,
      onTapOutside: (event) => _focusNode.unfocus(),
      decoration: InputDecoration(
        hintText: '搜索音乐、歌手、歌词',
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.grey, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      onChanged: (value) {
        onChanged!(value);
      },
    );
  }
}
