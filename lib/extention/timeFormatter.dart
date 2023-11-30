import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimeFormatter {
  static String formatCustomTime(Timestamp timestamp) {
    DateTime customDateTime = timestamp.toDate();
    DateTime currentDateTime = DateTime.now();

    // Định dạng cho ngày tháng
    DateFormat dateFormatter = DateFormat('d/M/yyyy');

    // Định dạng cho giờ
    DateFormat timeFormatter = DateFormat('H:mm');
    DateFormat monthFormatter = DateFormat('dd/MM');


    // So sánh để xác định ngày
    if (customDateTime.year == currentDateTime.year &&
        customDateTime.month == currentDateTime.month &&
        customDateTime.day == currentDateTime.day) {
      // Nếu thời gian nằm trong ngày hiện tại, hiển thị giờ
      return timeFormatter.format(customDateTime);
    }
    else
      if (customDateTime.year == currentDateTime.year && customDateTime.day != currentDateTime.day ||customDateTime.month != currentDateTime.month)
      {
      return  monthFormatter.format(customDateTime);
     }
      else{
      return "${timeFormatter.format(customDateTime)} ${dateFormatter.format(customDateTime)}";

    }
    }

  static Duration calculateTimeDifference(Timestamp timestamp1, Timestamp timestamp2) {
    // Chuyển Timestamp thành DateTime
    DateTime dateTime1 = timestamp1.toDate();
    DateTime dateTime2 = timestamp2.toDate();

    // Tính khoảng thời gian giữa hai DateTime
    Duration difference = dateTime2.difference(dateTime1);

    return difference;
  }
}
