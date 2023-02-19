import 'package:flutter/material.dart';

class GetPostTime{

  String getTime(BuildContext context, DateTime dateTime){

    String month = "";
    var date = DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);
    var time = TimeOfDay.fromDateTime(date);

    int day = dateTime.month;

    switch(day){
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "Jun";
        break;
      case 7:
        month = "Jul";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sep";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
        break;
    }

    return "${time.format(context)} on $day $month";

  }

}