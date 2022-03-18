import 'dart:developer';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'habit.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      home: const Home(),
      theme: ThemeData(
          canvasColor: Colors.black,
          appBarTheme: const AppBarTheme(color: Colors.black, elevation: 0),
          textTheme: const TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: Colors.deepPurple[700]),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)))),
          )),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  var habits = <Habit>[];
  
  void loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {

      var habitList = prefs.getStringList('habits');
      if (habitList != null){
        for (var s in habitList) {
          habits.add(Habit.fromString(s));
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    
    loadHabits();
    
    var _habits = <Widget>[];
    int today = DateTime.now().weekday - 1;
    for(var h in habits) {
      if(h.days[today]){
        _habits.add(h.getHabitTile());
      }
    }
    
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily habits'),
      ),
      body: ListView(children: _habits),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ManageHabits(
                        habits: (habits),
                      )));
        },
        label: Text('Manage Habits'),
      ),
    );
  }
}

class ManageHabits extends StatefulWidget {
  const ManageHabits({Key? key, required this.habits}) : super(key: key);

  final List<Habit> habits;

  @override
  _ManageHabitsState createState() => _ManageHabitsState();
}

class _ManageHabitsState extends State<ManageHabits> {
  
  void _saveHabits() async {
    var stringList = <String>[];
    for (var h in widget.habits) {
      stringList.add(h.toString());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage habits'),
          leading: BackButton(onPressed: () {
            _saveHabits();
            Navigator.pop(context);
          }),
        ),
        body: ListView.builder(
            itemCount: widget.habits.length * 2,
            itemBuilder: (context, index) {
              if (index % 2 == 0) {
                return ListTile(
                  title: Builder(builder: (context) {
                    return Text(
                      widget.habits[index ~/ 2].habit,
                      style: const TextStyle(color: Colors.white),
                    );
                  }),
                  onTap: () => {_editHabit(context, widget.habits[index ~/ 2])},
                );
              } else {
                return Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 8, 0),
                    child: const Divider(
                      color: Colors.grey,
                    ));
              }
            }),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Add New Habit'),
          onPressed: () {
            _editHabit(context, Habit(habit: ''));
          },
        ));
  }

  void _editHabit(BuildContext context, Habit h) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditHabit(habit: h)));

    setState(() {
      if (result == null || (result.habit).trim().length == 0) {
        // Delete a habit
        widget.habits.remove(h);
      } else {
        int idx = widget.habits.indexOf(result);
        if (idx != -1) {
          // Edit a habit
          widget.habits[idx] = result;
        } else {
          // Add a habit
          widget.habits.add(h);
        }
      }
    });
  }
}

class EditHabit extends StatefulWidget {
  final Habit habit;
  const EditHabit({Key? key, required this.habit}) : super(key: key);

  @override
  _EditHabitState createState() => _EditHabitState();
}

class _EditHabitState extends State<EditHabit> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add or modify habit'),
          leading: BackButton(onPressed: () {
            Navigator.pop(context, widget.habit);
          }),
          actions: <Widget>[
            // Delete button
            IconButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.delete)),
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(16),
            child: ListView(children: <Widget>[
              Center(
                child: TextFormField(
                  initialValue: widget.habit.habit,
                  onChanged: (newValue) => widget.habit.habit = newValue,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      hintText: 'Enter Habit Name',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              dayButtonsWidget(widget.habit)
            ])));
  }

  Widget dayButtonsWidget(Habit h) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    var buttonList = <Widget>[];

    for (int i = 0; i < days.length; i++) {
      ButtonStyle activeStatus;
      TextStyle activeStatusText;
      if (h.getBoolFromInt(i)) {
        activeStatusText = TextStyle(color: Colors.white);
        activeStatus =
            ElevatedButton.styleFrom(primary: Colors.deepPurple[700]);
      } else {
        activeStatusText = TextStyle(color: Colors.black);
        activeStatus = ElevatedButton.styleFrom();
      }

      buttonList.add(FractionallySizedBox(
          widthFactor: 0.9,
          child: ElevatedButton(
            style: activeStatus,
            onPressed: () {
              setState(() {
                h.setBoolFromInt(i);
              });
            },
            child: Text(
              days[i],
              style: activeStatusText,
            ),
          )));
    }

    return Column(
      children: buttonList,
    );
  }
}
