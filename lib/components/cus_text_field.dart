import 'package:flutter/material.dart';

class CusTextField extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final void Function(String)? onChanged;
  final bool? autoFocus;
  final String? value;

  CusTextField({
    super.key,
    required this.onChanged,
    this.autoFocus = false,
    this.value,
  }) {
    if (value != null) {
      _controller.text = value!;
    }
    if (autoFocus == true) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      cursorColor: Colors.grey,
      cursorHeight: 17.0,
      cursorWidth: 1.0,
      enableInteractiveSelection: false,
      focusNode: _focusNode,
      autofocus: autoFocus ?? false,
      onTapOutside: (event) => _focusNode.unfocus(),
      style: const TextStyle(fontSize: 12, color: Colors.black54),
      decoration: InputDecoration(
        hintText: '搜索音乐、歌手、歌词',
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      ),
      onChanged: (value) {
        onChanged!(value);
      },
    );
  }
}
