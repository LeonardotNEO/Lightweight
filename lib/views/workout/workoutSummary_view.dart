import 'package:flutter/material.dart';
import 'package:lifting_app/Models/Workout.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/widgets/back_button_as_logo.dart';
import 'package:lifting_app/views/widgets/excersises_as_list_editable_widget.dart';

class WorkoutSummary extends StatefulWidget {
  Workout _workout;

  WorkoutSummary(this._workout);

  @override
  _WorkoutSummaryState createState() => _WorkoutSummaryState();
}

class _WorkoutSummaryState extends State<WorkoutSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.color1,
        title: Text(
          "${widget._workout.getWorkoutName()} summary",
          style: TextStyle(color: ColorConstants.color3),
        ),
        leading: BackButtonAsLogo(() => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _topBarInformation(),
              ExcersisesAsListEditable(
                  widget._workout, MainPage.getCurrentUser(), _rebuild)
            ],
          ),
        ),
      ),
    );
  }

  void _rebuild() {
    setState(() {});
  }

  Widget _topBarInformation() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 5),
      child: Container(
          decoration: BoxDecoration(
              color: ColorConstants.color1,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          padding: EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statsText(),
              _workoutStatsArea(),
            ],
          )),
    );
  }

  Widget _statsText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        "Stats",
        style: TextStyle(
            color: ColorConstants.color3,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _workoutStatsArea() {
    return Wrap(
      children: [
        ..._workoutStatsButtons({
          "Name:": widget._workout.getWorkoutName(),
          "Duration:": widget._workout.getDuration(),
          "Volume:": widget._workout.getWorkoutVolume().toString(),
          "Date:": widget._workout.getDateFinished().day.toString() +
              "." +
              widget._workout.getDateFinished().month.toString() +
              "." +
              widget._workout.getDateFinished().year.toString() +
              " " +
              widget._workout.getDateFinished().hour.toString() +
              "." +
              widget._workout.getDateFinished().minute.toString(),
        })
      ],
    );
  }

  List<Widget> _workoutStatsButtons(Map<String, String> strings) {
    List<Widget> widgets = [];

    strings.forEach((key, value) {
      widgets.add(_workoutStatsButton(key, value));
    });

    return widgets;
  }

  Widget _workoutStatsButton(String string1, String string2) {
    return Container(
      padding: EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
      height: 35,
      width: 185,
      child: OutlinedButton(
        style: ButtonStyle(
            side: MaterialStateProperty.all(
                BorderSide(color: ColorConstants.color3, width: 0.7)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)))),
        onPressed: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              string1,
              style: TextStyle(fontSize: 12, color: ColorConstants.text3),
            ),
            Text(string2,
                style: TextStyle(fontSize: 12, color: ColorConstants.text3)),
          ],
        ),
      ),
    );
  }
}
