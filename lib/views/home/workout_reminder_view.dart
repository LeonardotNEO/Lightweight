import 'package:flutter/material.dart';
import 'package:lifting_app/Models/Workout.dart';
import 'package:lifting_app/Models/WorkoutReminder.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/workout/select_workout_view.dart';
import 'package:lifting_app/views/widgets/back_button_as_logo.dart';
import 'package:lifting_app/views/workout/workouts_view.dart';

class WorkoutReminderView extends StatefulWidget {
  @override
  _WorkoutReminderViewState createState() => _WorkoutReminderViewState();
}

class _WorkoutReminderViewState extends State<WorkoutReminderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout reminders",
            style: TextStyle(color: ColorConstants.color3)),
        leading: BackButtonAsLogo(() => Navigator.pop(context)),
        backgroundColor: ColorConstants.color1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [..._daysWidgets()]),
        ),
      ),
    );
  }

  List<Widget> _daysWidgets() {
    List<Map<String, dynamic>> days = [
      {"Monday": 1},
      {"Tuesday": 2},
      {"Wednesday": 3},
      {"Thursday": 4},
      {"Friday": 5},
      {"Saturday": 6},
      {"Sunday": 7}
    ];
    List<Widget> widgets = [];

    days.forEach((element) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            element.keys.first,
            style: TextStyle(
              fontSize: 18,
              color: ColorConstants.text3,
            ),
          ),
          ..._workoutReminders(element[element.keys.first]),
          Container(
            alignment: Alignment.center,
            child: OutlinedButton.icon(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(ColorConstants.color3)),
              onPressed: () {
                setState(() {
                  MainPage.getCurrentUser().addWorkoutReminder(
                      WorkoutReminder(null, "", "", element.values.first));
                });
              },
              icon: Icon(Icons.add),
              label: Text("Add reminder"),
            ),
          ),
        ]),
      ));
    });

    return widgets;
  }

  List<Widget> _workoutReminders(int day) {
    List<Widget> widgets = [];
    List<WorkoutReminder> reminders =
        MainPage.getCurrentUser().getWorkoutReminderGivenDay(day);

    reminders.forEach((element) {
      TextEditingController _title = TextEditingController();
      TextEditingController _description = TextEditingController();
      _title.text = element.getTitle();
      _description.text = element.getDescription();

      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorConstants.color3,
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: ColorConstants.text1Dark),
                        controller: _title,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Title...",
                            hintStyle: TextStyle(color: ColorConstants.text2)),
                        onChanged: (value) {
                          element.setTitle(value);
                        },
                      ),
                    ),
                    IconButton(
                        color: ColorConstants.text1Dark,
                        onPressed: () {
                          setState(() {
                            MainPage.getCurrentUser()
                                .removeWorkoutReminder(element);
                          });
                        },
                        icon: Icon(Icons.clear))
                  ],
                ),
              ),
              Container(
                height: 30,
                child: TextField(
                  style: TextStyle(color: ColorConstants.text1Dark),
                  controller: _description,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Description...",
                      hintStyle: TextStyle(color: ColorConstants.text2)),
                  onChanged: (value) {
                    element.setTitle(value);
                  },
                ),
              ),
              element.getAttachedWorkout() == null
                  ? OutlinedButton.icon(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              BorderSide(color: ColorConstants.color1)),
                          foregroundColor:
                              MaterialStateProperty.all(ColorConstants.color1)),
                      onPressed: () => _setWorkout(element),
                      icon: Icon(Icons.add),
                      label: Text("Select workout"))
                  : Row(
                      children: [
                        Text(
                          "Attached workout: ${element.getAttachedWorkout().getWorkoutName()}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          height: 30,
                          child: OutlinedButton.icon(
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(
                                      BorderSide(color: ColorConstants.color1)),
                                  foregroundColor: MaterialStateProperty.all(
                                      ColorConstants.color1)),
                              onPressed: () => _setWorkout(element),
                              icon: Icon(
                                Icons.edit,
                                size: 20,
                              ),
                              label: Text("Change")),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ));
    });

    return widgets;
  }

  Future _setWorkout(WorkoutReminder reminder) async {
    final Workout result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SelectWorkout()));

    setState(() {
      reminder.setWorkout(result);
    });
  }
}
