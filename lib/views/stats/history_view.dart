import 'package:flutter/material.dart';
import 'package:lifting_app/Models/User.dart';
import 'package:lifting_app/Models/Workout.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/widgets/card_widget.dart';
import 'package:lifting_app/views/workout/workoutSummary_view.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: _showWorkoutHistory());
  }

  Widget _showWorkoutHistory() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ...getWorkoutHistoryWidgets(Workout.getWorkoutsSortedByDate(
              MainPage.getCurrentUser().getWorkoutHistory()))
        ],
      ),
    );
  }

  List<Widget> getWorkoutHistoryWidgets(List<Workout> workouts) {
    List<Widget> workoutWidgets = [
      Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 20, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Name",
              style: TextStyle(
                  color: ColorConstants.color3, fontWeight: FontWeight.bold),
            ),
            Text(
              "Date",
              style: TextStyle(
                  color: ColorConstants.color3, fontWeight: FontWeight.bold),
            ),
            Text(
              "Volume (kg)",
              style: TextStyle(
                  color: ColorConstants.color3, fontWeight: FontWeight.bold),
            )
          ],
        ),
      )
    ];

    for (Workout workout in workouts) {
      Function _onPressed = () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => WorkoutSummary(workout)));

      CardWidget card = CardWidget(
        _singleWorkoutHistoryWidget(workout),
        _onPressed,
      );

      workoutWidgets.add(Padding(
        padding: const EdgeInsets.only(top: 3),
        child: card,
      ));
    }

    return workoutWidgets;
  }

  Widget _singleWorkoutHistoryWidget(Workout workout) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 100,
          child: Text(workout.getWorkoutName(),
              style: TextStyle(color: ColorConstants.color1)),
        ),
        Container(
          alignment: Alignment.center,
          width: 100,
          child: Text(workout.getDateFinished().toIso8601String().split("T")[0],
              style: TextStyle(color: ColorConstants.color1)),
        ),
        Container(
          alignment: Alignment.centerRight,
          width: 100,
          child: Text(workout.getWorkoutVolume().toString(),
              style: TextStyle(color: ColorConstants.color1)),
        )
      ],
    );
  }
}
