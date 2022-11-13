import 'package:flutter/material.dart';

class GetTime{

  getTime(timestamp, context){
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var time = TimeOfDay.fromDateTime(date);

    return time.format(context);
  }

}