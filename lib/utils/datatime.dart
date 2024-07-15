String messageTime(int timeStamp) {
  // 当前时间
  int time = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  // 对比
  int distance = time - timeStamp;
  if (distance <= 60) {
    return '刚刚';
  } else if (distance <= 3600) {
    return '${(distance / 60).floor()}分钟前';
  } else if (distance <= 43200) {
    return '${(distance / 60 / 60).floor()}小时前';
  } else if (DateTime.fromMillisecondsSinceEpoch(time * 1000).year ==
      DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000).year) {
    return customStampStr(
        Timestamp: timeStamp, Date: 'MM/DD hh:mm', toInt: false);
  } else {
    return customStampStr(
        Timestamp: timeStamp, Date: 'YY/MM/DD hh:mm', toInt: false);
  }
}

// 时间戳转时间
String customStampStr({
  required int Timestamp, // 为空则显示当前时间
  required String Date, // 显示格式，比如：'YY年MM月DD日 hh:mm:ss'
  bool toInt = true, // 去除0开头
}) {
  if (Timestamp == 0) {
    Timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  }

  String timeStr =
      (DateTime.fromMillisecondsSinceEpoch(Timestamp * 1000)).toString();

  dynamic dateArr = timeStr.split(' ')[0];
  dynamic timeArr = timeStr.split(' ')[1];

  String YY = dateArr.split('-')[0];
  String MM = dateArr.split('-')[1];
  String DD = dateArr.split('-')[2];

  String hh = timeArr.split(':')[0];
  String mm = timeArr.split(':')[1];
  String ss = timeArr.split(':')[2];

  ss = ss.split('.')[0];

  // 去除0开头
  if (toInt) {
    MM = (int.parse(MM)).toString();
    DD = (int.parse(DD)).toString();
    hh = (int.parse(hh)).toString();
    mm = (int.parse(mm)).toString();
  }

  if (Date == "") {
    return timeStr;
  }

  Date = Date.replaceAll('YY', YY)
      .replaceAll('MM', MM)
      .replaceAll('DD', DD)
      .replaceAll('hh', hh)
      .replaceAll('mm', mm)
      .replaceAll('ss', ss);

  return Date;
}
