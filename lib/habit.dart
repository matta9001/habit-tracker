import 'package:flutter/material.dart';
import 'dart:core';

class Habit {
  String habit;
  var days = [false, false, false, false, false, false, false];

  Habit({
    required this.habit,
  });

  @override
  String toString() {
    // TODO: To persist data simply in a key/value pair, I need to have functions that convert habits to and from strings
    // 'habitname:TFFTFFT'
    String ret = habit + ":";
    for(var d in days) {
      if(d) {
        ret += "T";
      } else {
        ret += "F";
      }
    }
    return ret;
  }

  static Habit fromString(String s){
    var split = s.split(":");
    var habitName = split[0];
    Habit h = Habit(habit: habitName);

    for (int i = 0; i < 7; i++) {
      if (split[1][i] == "T") {
        h.setBoolFromInt(i);
      }
    }
    
    return h;
  }

  Widget getHabitTile() {
    return ListTile(
      title: Text(
        habit,
        style: const TextStyle(color: Colors.white),
      ),
      //trailing: Text(date.toString())
    );
  }

  void setBoolFromInt(int i) {
    days[i] = !days[i];
  }

  bool getBoolFromInt(int i) {
    return days[i];
  }
}
