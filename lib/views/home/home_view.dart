import 'package:flutter/material.dart';
import 'package:lifting_app/Models/Workout.dart';
import 'package:lifting_app/Models/WorkoutReminder.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/home/logIn_view.dart';
import 'package:lifting_app/views/home/register_view.dart';
import 'package:lifting_app/views/widgets/bottom_navbar_widget.dart';
import 'package:lifting_app/views/widgets/card_widget.dart';
import 'package:lifting_app/views/workout/workout_in_progress_view.dart';
import 'package:lifting_app/views/home/workout_reminder_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int chartToShow = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: MainPage.getCurrentUser().getUsername() != "Guest"
          ? _loggedInPage()
          : _loggedOutPage(),
    );
  }

  Widget _loggedInPage() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome back ${MainPage.getCurrentUser().getUsername()}!",
            style: TextStyle(fontSize: 16, color: ColorConstants.text3),
          ),
          MainPage.getCurrentUser().getWorkoutHistory().isNotEmpty
              ? _quickStartLastWorkout()
              : SizedBox.shrink(),
          _quickStartEmptyWorkout(),
          _workoutReminderBox(),
          CardWidget.withHeader(
            _volumeOverTimeChart(),
            null,
            "Volume over time",
            SizedBox.shrink(),
          ),
          Container(
            height: 100,
            width: double.infinity,
          )
        ],
      ),
    );
  }

  Widget _loggedOutPage() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _registerLoginBox(),
          MainPage.getCurrentUser().getWorkoutHistory().isNotEmpty
              ? _quickStartLastWorkout()
              : SizedBox.shrink(),
          _quickStartEmptyWorkout(),
          _workoutReminderBox(),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CardWidget.withHeader(
              _volumeOverTimeChart(),
              null,
              "Volume over time",
              SizedBox.shrink(),
            ),
          ),
          Container(
            height: 100,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _quickStartLastWorkout() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: GestureDetector(
        onTap: () =>
            _startWorkout(MainPage.getCurrentUser().getWorkoutHistory().first),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: ColorConstants.color3,
            ),
            padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
            height: 90,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 75,
                        color: ColorConstants.text1Dark,
                      ),
                      Icon(
                        Icons.directions_run,
                        size: 75,
                        color: ColorConstants.text1Dark,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Start last workout",
                          style: TextStyle(
                              fontSize: 16,
                              color: ColorConstants.color1,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: ColorConstants.color1,
                        )
                      ],
                    ),
                    Text(
                      MainPage.getCurrentUser()
                          .getWorkoutHistory()
                          .first
                          .getWorkoutName(),
                      style: TextStyle(color: ColorConstants.color1),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget _quickStartEmptyWorkout() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: GestureDetector(
        onTap: () => _startWorkout(Workout.withName("Workout 1")),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: ColorConstants.color3,
            ),
            padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
            height: 90,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 75,
                        color: ColorConstants.text1Dark,
                      ),
                      Icon(
                        Icons.directions_run,
                        size: 75,
                        color: ColorConstants.text1Dark,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Start empty workout",
                          style: TextStyle(
                              fontSize: 16,
                              color: ColorConstants.color1,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: ColorConstants.color1,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget _workoutReminderBox() {
    List<Widget> _workoutReminders() {
      List<Widget> workoutReminders = [];

      MainPage.getCurrentUser().getTodaysWorkoutReminder().forEach((element) {
        workoutReminders.add(Container(
          padding: EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    element.getTitle(),
                    style: TextStyle(
                        fontSize: 16, color: ColorConstants.text1Dark),
                  ),
                  SizedBox(
                      width: 35,
                      height: 35,
                      child: IconButton(
                          onPressed: () =>
                              _startWorkout(element.getAttachedWorkout()),
                          icon: Icon(
                            Icons.arrow_forward,
                            color: ColorConstants.text1Dark,
                          )))
                ],
              )
            ],
          ),
        ));
      });

      return workoutReminders;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: GestureDetector(
        onTap: null,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              color: ColorConstants.color3,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    MainPage.getCurrentUser().getWorkoutReminders().length == 0
                        ? "You have no workout reminders!"
                        : (MainPage.getCurrentUser()
                                    .getTodaysWorkoutReminder()
                                    .length ==
                                0
                            ? "You have no planned workout for today!"
                            : "You have a planned workout for today!"),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.color1),
                  ),
                  SizedBox(
                      height: 35,
                      width: 35,
                      child: IconButton(
                        color: ColorConstants.color1,
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkoutReminderView()));

                          setState(() {});
                        },
                        icon: Icon(Icons.today),
                      ))
                ],
              ),
              ..._workoutReminders()
            ],
          ),
        ),
      ),
    );
  }

  Widget _volumeOverTimeChart() {
    Widget chart(List<dynamic> dataSource) {
      return Container(
        height: 190,
        child: SfCartesianChart(
            plotAreaBorderColor: ColorConstants.color1,
            plotAreaBorderWidth: 0,
            primaryXAxis: DateTimeAxis(),
            series: <ChartSeries>[
              // Renders line chart
              LineSeries<Workout, DateTime>(
                opacity: 1,
                width: 2,
                color: ColorConstants.color1,
                dataSource: dataSource,
                xValueMapper: (Workout workout, _) => workout.getDateFinished(),
                yValueMapper: (Workout workout, _) =>
                    workout.getWorkoutVolume(),
              )
            ]),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    chartToShow = 1;
                  });
                },
                child:
                    Text("W", style: TextStyle(color: ColorConstants.color1))),
            TextButton(
                onPressed: () {
                  setState(() {
                    chartToShow = 2;
                  });
                },
                child:
                    Text("M", style: TextStyle(color: ColorConstants.color1))),
            TextButton(
                onPressed: () {
                  setState(() {
                    chartToShow = 3;
                  });
                },
                child:
                    Text("Y", style: TextStyle(color: ColorConstants.color1)))
          ],
        ),
        chartToShow == 1
            ? chart(MainPage.getCurrentUser().getWorkoutsThisWeek())
            : SizedBox.shrink(),
        chartToShow == 2
            ? chart(MainPage.getCurrentUser().getWorkoutsThisMonth())
            : SizedBox.shrink(),
        chartToShow == 3
            ? chart(MainPage.getCurrentUser().getWorkoutsThisYear())
            : SizedBox.shrink()
      ],
    );
  }

  Widget _registerLoginBox() {
    return Container(
      decoration: BoxDecoration(
          color: ColorConstants.color3,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You are using the app as a guest",
            style: TextStyle(
                color: ColorConstants.color1,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              "By registering you are gaining extra functionality. For example: progression and tailored nutitrional and weightlifting advice!",
              style: TextStyle(
                  color: ColorConstants.color1,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton.icon(
                      icon: Icon(Icons.login),
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              BorderSide(color: ColorConstants.color1)),
                          foregroundColor:
                              MaterialStateProperty.all(ColorConstants.color1),
                          backgroundColor:
                              MaterialStateProperty.all(ColorConstants.color3)),
                      onPressed: () =>
                          MainPage.setCurrentPage(LogIn(), "Log in"),
                      label: Text("Log in")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton.icon(
                      icon: Icon(Icons.app_registration),
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              BorderSide(color: ColorConstants.color1)),
                          foregroundColor:
                              MaterialStateProperty.all(ColorConstants.color1),
                          backgroundColor:
                              MaterialStateProperty.all(ColorConstants.color3)),
                      onPressed: () =>
                          MainPage.setCurrentPage(Register(), "Register"),
                      label: Text("Register")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _statsBox() {
    double _totalHoursExcersised;
    double _totalWorkouts;
    double _avergaCaloriesBurnedThisWeek;
    double _workoutsThisWeek;
    double _workoutsPerWeekGoal;
  }
}
