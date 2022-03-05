import 'dart:developer';
import 'dart:ui';

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
      
        canvasColor: Colors.white,

        appBarTheme: const AppBarTheme(
          color: Colors.indigo,
        ),
        
        accentColor: Colors.indigo 
       
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    var _habits = <Widget>[];
       
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily habits'),
      ),

      body: ListView (
        children: _habits
      ),

      floatingActionButton: FloatingActionButton.extended (
        onPressed: () {
          // TODO: Load list from memory.
          final habitlist = List.generate(
            5,
            (index) => Habit(habit: 'Habit $index')
          );
          Navigator.push(context, MaterialPageRoute(builder: (context) => ManageHabits(habits: habitlist,)));
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
  

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        title: const Text('Manage habits'),
      ),

      body: ListView.builder(
        itemCount: widget.habits.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.habits[index].habit),
            onTap: () => {
              _editHabit(context, widget.habits[index])
            },
          );
        }
      ),

      floatingActionButton: FloatingActionButton.extended (
        label: Text('Add New Habit'),
        onPressed: () {
          _editHabit(context, Habit(habit: ''));
        },
      )
    );

  }
  
  void _editHabit(BuildContext context, Habit h) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditHabit(habit: h)
      )
    );

    setState(() {
      if(result == null || (result.habit).trim().length == 0) {
        // Delete a habit
        widget.habits.remove(h);
      } else {
        int idx = widget.habits.indexOf(result);
        if(idx != -1) {
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
        leading: BackButton(
          onPressed: () {
              Navigator.pop(context, widget.habit);
          } 
        ),
        actions: <Widget>[
          // Delete button
          IconButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.delete)
          ),
        ],
      ),

      body: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Text('Title:'),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: TextFormField(
                      initialValue: widget.habit.habit,
                      onChanged: (newValue) => widget.habit.habit = newValue
                    ),
                  )
                )
              ],
            ),
            const Text('test'),
            dayButtonsWidget(widget.habit)
          ]
        ),
      )
    );
  }
  
  Widget dayButtonsWidget(Habit h) {
    const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    var buttonList = <Widget>[];

    for (int i = 0; i < days.length; i++){

      ButtonStyle activeStatus;
      TextStyle activeStatusText;
      if(h.getBoolFromInt(i)) {
        activeStatusText = TextStyle(color: Colors.white);
        activeStatus = ElevatedButton.styleFrom(
          primary: Colors.blue
        );
      } else {
        activeStatusText = TextStyle(color: Colors.black);
        activeStatus = ElevatedButton.styleFrom(
          primary: Colors.white
        );
      }
      
      buttonList.add(
        FractionallySizedBox(
          widthFactor: 0.9,
          child: ElevatedButton(
            style: activeStatus,
            onPressed: () {setState(() {
              h.setBoolFromInt(i);
            });},
            child: Text(
              days[i],
              style: activeStatusText,
            ),
          )
        )
      );
    }

    return Container(
      child: Column(
        children: buttonList,
      )
    );
  }
}