class NumberFormatUtil {
  /// 将数字转换为以万、亿为单位的字符串，保留两位小数（去除末尾多余的0）
  /// [value] 需要转换的数字
  /// 返回格式化后的字符串，例如：
  /// 12345 -> 1.23万
  /// 123456789 -> 1.23亿
  /// 10000000 -> 0.1亿
  /// 12345000 -> 1.23亿
  static String formatWithUnit(num value) {
    if (value < 10000) {
      return value.toStringAsFixed(0);
    } else if (value < 10000000) {
      return '${_formatDecimal(value / 10000)}万';
    } else {
      return '${_formatDecimal(value / 100000000)}亿';
    }
  }

  /// 格式化小数，去除末尾多余的0
  static String _formatDecimal(num value) {
    String formatted = value.toStringAsFixed(2);
    // 去除末尾的0
    formatted = formatted.replaceFirst(RegExp(r'0+$'), '');
    // 如果小数点后都是0，去除小数点
    formatted = formatted.replaceFirst(RegExp(r'\.$'), '');
    return formatted;
  }
}

String formatMilliseconds(int milliseconds) {
  // 处理负数情况
  if (milliseconds < 0) milliseconds = 0;

  // 计算分钟和秒
  int totalSeconds = milliseconds ~/ 1000;
  int minutes = totalSeconds ~/ 60;
  int seconds = totalSeconds % 60;

  // 格式化输出：确保秒数始终显示两位（例如 03:05 而非 3:5）
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String minutes = twoDigits(duration.inMinutes);
  String seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}
