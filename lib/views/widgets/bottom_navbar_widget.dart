import 'package:flutter/material.dart';
import 'package:lifting_app/Models/Workout.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/excersise/excersises_view.dart';
import 'package:lifting_app/views/home/home_view.dart';
import 'package:lifting_app/views/social/social_view.dart';
import 'package:lifting_app/views/stats/stats_view.dart';
import 'package:lifting_app/views/store_view.dart';
import 'package:lifting_app/views/widgets/toolbar_with_buttons.dart';
import 'package:lifting_app/views/workout/workout_in_progress_view.dart';
import 'package:lifting_app/views/workout/workouts_view.dart';

class BottomNavbar extends StatefulWidget {
  static _BottomNavbarState _state = _BottomNavbarState();

  static reBuild() {
    _state.setState(() {});
  }

  @override
  _BottomNavbarState createState() => _state;
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: ColorConstants.color1),
        child: MainPage.getCurrentUser().getCurrentWorkout() != null
            ? _workoutInProgressBar()
            : _noWorkoutInProgress());
  }

  Widget _workoutInProgressBar() {
    return MainPage.getCurrentPage() is WorkoutInProgress
        ? SizedBox.shrink()
        : SizedBox(
            height: 130,
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: double.infinity, height: 60),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ColorConstants.color3),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0))),
                      ),
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WorkoutInProgress()));

                        BottomNavbar.reBuild();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: Column(
                          children: [
                            Text(
                              "${MainPage.getCurrentUser().getCurrentWorkout().getWorkoutName()} is in progress...",
                              style: TextStyle(
                                  fontSize: 16, color: ColorConstants.color1),
                            ),
                            Text(
                              "Tap here go to current workout",
                              style: TextStyle(
                                  fontSize: 12, color: ColorConstants.color1),
                            )
                          ],
                        ),
                      )),
                ),
                _getButtons()
              ],
            ),
          );
  }

  Widget _noWorkoutInProgress() {
    return SizedBox(
      height: 70,
      child: Column(
        children: [SizedBox.shrink(), _getButtons()],
      ),
    );
  }

  Widget _getButtons() {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () => MainPage.setCurrentPage(Home(), "Home"),
            child: Column(
              children: [
                Icon(Icons.home, color: ColorConstants.color3),
                Text(
                  "Home",
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.color3,
                      fontWeight: MainPage.getCurrentPage() is Home
                          ? FontWeight.bold
                          : FontWeight.normal),
                )
              ],
            )),
        TextButton(
            onPressed: () {
              setState(() {
                MainPage.setCurrentPage(Workouts(), "Workouts");
              });
            },
            child: Column(
              children: [
                Icon(Icons.fitness_center, color: ColorConstants.color3),
                Text(
                  "Workout",
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.color3,
                      fontWeight: MainPage.getCurrentPage() is Workouts
                          ? FontWeight.bold
                          : FontWeight.normal),
                )
              ],
            )),
        TextButton(
            style: ButtonStyle(),
            onPressed: () => MainPage.setCurrentPage(
                  ExcersisesPage(),
                  "Excersises",
                ),
            child: Column(
              children: [
                Icon(Icons.list, color: ColorConstants.color3),
                Text(
                  "Excersises",
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.color3,
                      fontWeight: MainPage.getCurrentPage() is ExcersisesPage
                          ? FontWeight.bold
                          : FontWeight.normal),
                )
              ],
            )),
        TextButton(
            onPressed: () => MainPage.setCurrentPage(
                  Stats(),
                  "Stats",
                ),
            child: Column(
              children: [
                Icon(
                  Icons.stacked_bar_chart,
                  color: ColorConstants.color3,
                ),
                Text(
                  "Stats",
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.color3,
                      fontWeight: MainPage.getCurrentPage() is Stats
                          ? FontWeight.bold
                          : FontWeight.normal),
                )
              ],
            )),
        TextButton(
            onPressed: () {
              MainPage.setCurrentPage(
                SocialView(),
                "Social",
              );
            },
            child: Column(
              children: [
                Icon(
                  Icons.groups,
                  color: ColorConstants.color3,
                ),
                Text(
                  "Social",
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.color3,
                      fontWeight: MainPage.getCurrentPage() is SocialView
                          ? FontWeight.bold
                          : FontWeight.normal),
                )
              ],
            )),
      ],
    );
  }
}
