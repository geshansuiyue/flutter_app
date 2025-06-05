class NumberFormatUtil {
  /// 将数字转换为以万、亿为单位的字符串，保留两位小数
  /// [value] 需要转换的数字
  /// 返回格式化后的字符串，例如：12345 -> 1.23万，123456789 -> 1.23亿
  static String formatWithUnit(num value) {
    if (value < 10000) {
      return value.toStringAsFixed(0);
    } else if (value < 100000000) {
      return '${(value / 10000).toStringAsFixed(2)}万';
    } else {
      return '${(value / 100000000).toStringAsFixed(2)}亿';
    }
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
