import 'package:flutter/material.dart';
import 'dart:core';

class Habit {

  String habit;
  bool sunday;
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thursday;
  bool friday;
  bool saturday;

  Habit({
    required this.habit,
    this.sunday = false,
    this.monday = false,
    this.tuesday = false,
    this.wednesday = false,
    this.thursday = false,
    this.friday = false,
    this.saturday = false,
  });

  Widget getHabitTile() {
    return ListTile(
      title: Text(habit),
      //trailing: Text(date.toString())
    );
  }

   bool setBoolFromInt(int i) {
    switch(i) {
      case 0: sunday = !sunday; break;
      case 1: monday = !monday; break;
      case 2: tuesday = !tuesday; break;
      case 3: wednesday = !wednesday; break;
      case 4: thursday = !thursday; break;
      case 5: friday = !friday; break;
      case 6: saturday = !saturday; break;
    }
    return false;
  } 
  bool getBoolFromInt(int i) {
    switch(i) {
      case 0: return sunday;
      case 1: return monday; 
      case 2: return tuesday;
      case 3: return wednesday;
      case 4: return thursday;
      case 5: return friday;
      case 6: return saturday;
    }
    return false;
  }
  
}