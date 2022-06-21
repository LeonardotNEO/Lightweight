import 'package:flutter/material.dart';
import 'package:lifting_app/Models/excersise_model.dart';
import 'package:lifting_app/Models/Workout.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/widgets/bottom_navbar_widget.dart';
import 'package:lifting_app/views/workout/workout_view.dart';
import 'package:lifting_app/views/widgets/button_1_widget.dart';
import 'package:lifting_app/views/widgets/card_widget.dart';
import 'package:lifting_app/views/widgets/popup_menu_widget.dart';
import 'package:lifting_app/views/widgets/tip_widget.dart';
import 'package:lifting_app/views/workout/workout_in_progress_view.dart';

class Workouts extends StatefulWidget {
  @override
  _WorkoutsState createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: [
            Button1("Create workout", () => _createWorkout()),
            TipWidget("Tip: tap a workout to start it"),
            ..._getWorkoutsAsWidgets(MainPage.getCurrentUser().getWorkouts()),
            Container(
              height: 130,
            )
          ],
        ));
  }

  List<Widget> _getWorkoutsAsWidgets(List<Workout> workouts) {
    List<Widget> workOutWidgets = [];

    for (Workout workout in workouts) {
      Function _onPressed = () => _startWorkout(workout);
      Widget _child = Column(
        children: [..._getExcersisesAsListOfText(workout.getExcersises())],
      );

      Function _onPressedPopupMenu = (value) {
        setState(() {
          if (value == "edit") {
            _editWorkout(workout);
          }
          if (value == "delete") {
            _deleteWorkout(workout);
          }
        });
      };

      List<PopupMenuItem> _items = [
        PopupMenuItem(
          child: Text("Edit"),
          value: "edit",
        ),
        PopupMenuItem(
          child: Text("Delete"),
          value: "delete",
        )
      ];

      workOutWidgets.add(
        CardWidget.withHeader(
          _child,
          _onPressed,
          workout.getWorkoutName(),
          PopupMenuWidget(_onPressedPopupMenu, _items, Icons.menu),
        ),
      );
    }

    return workOutWidgets;
  }

  List<Widget> _getExcersisesAsListOfText(List<ExcersiseModel> excersises) {
    List<Widget> excersiseWidgets = [];

    for (ExcersiseModel excersise in excersises) {
      excersiseWidgets.add(Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${excersise.getName()}",
              style: TextStyle(
                  fontSize: 14,
                  color: ColorConstants.color1,
                  fontWeight: FontWeight.normal),
            ),
            Text(
              excersise.getBodypart().getName(),
              style: TextStyle(
                  fontSize: 14,
                  color: ColorConstants.color1,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ));
    }

    return excersiseWidgets;
  }

  void _startWorkout(Workout workout) async {
    Workout workoutFresh = Workout.fromJson(workout.toJson());

    MainPage.getCurrentUser().setCurrentWorkout(workoutFresh);

    // update page
    MainPage.getMainState().setState(() {});

    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => WorkoutInProgress()));

    BottomNavbar.reBuild();
  }

  void _createWorkout() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => WorkoutView.blank()));

    setState(() {});
  }

  void _editWorkout(Workout workoutModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutView.edit(workoutModel)));
  }

  void _deleteWorkout(Workout workoutModel) {
    setState(() {
      MainPage.getCurrentUser().deleteWorkout(workoutModel);
    });
  }
}
