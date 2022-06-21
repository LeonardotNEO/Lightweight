import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lifting_app/Models/ExcersisePackage.dart';
import 'package:lifting_app/Models/excersise_model.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/excersise/excersises_view.dart';
import 'package:lifting_app/views/stats/history_view.dart';
import 'package:lifting_app/views/widgets/excersises_as_list_editable_widget.dart';
import 'package:lifting_app/Models/User.dart';
import 'package:lifting_app/Models/Workout.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:system_setting/system_setting.dart';

class WorkoutInProgress extends StatefulWidget {
  User _currentUser = MainPage.getCurrentUser();
  Workout _currentWorkout = MainPage.getCurrentUser().getCurrentWorkout();
  bool _showSpotifyBar = MainPage.getCurrentUser().getSpotifyBarOn();
  bool _showSnapBar = MainPage.getCurrentUser().getSnapBarOn();
  bool _showStatusBar = true;
  bool _scrollToBottom = false;
  ScrollController _scrollController = ScrollController();

  WorkoutInProgress();

  @override
  _WorkoutInProgressState createState() => _WorkoutInProgressState();
}

class _WorkoutInProgressState extends State<WorkoutInProgress> {
  ValueNotifier<String> _timer;
  CustomTimer customTimer = new CustomTimer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget._currentWorkout.startWorkoutTimer();

    _timer = ValueNotifier(widget._currentWorkout.getTimerElapsed());

    customTimer.startTimer();

    if (widget._currentWorkout != null) {
      customTimer.streamController.stream.listen((data) {
        _timer.value = widget._currentWorkout.getTimerElapsed();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // scroll to bottom if _scrollToBottom is true
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget._scrollToBottom) {
        _scrollToBottom();
      }
    });

    return Scaffold(
        appBar: _topBar(),
        body: SingleChildScrollView(
          controller: widget._scrollController,
          child: Column(children: [
            ExcersisesAsListEditable(
                MainPage.getCurrentUser().getCurrentWorkout(),
                MainPage.getCurrentUser(),
                _rebuild),
          ]),
        ),
        bottomSheet: _bottomSheet());
  }

  void _rebuild() {
    setState(() {});
  }

  Widget _bottomSheet() {
    List<Widget> widgets = [];
    double bottomSheetHeight = 0;

    if (widget._showSnapBar) {
      widgets.add(_snapBar());
      bottomSheetHeight += 35;
    }
    if (widget._showSpotifyBar) {
      widgets.add(_spotifyBar());
      bottomSheetHeight += 35;
    }

    Widget returnWidget = Container(
      height: bottomSheetHeight,
      child: Column(
        children: [...widgets],
      ),
    );

    return widgets.isEmpty ? null : returnWidget;
  }

  Widget _topBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 85,
      titleSpacing: 0,
      elevation: 0,
      backgroundColor: ColorConstants.color1,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 34),
        child: Column(
          children: [
            SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 750,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: ColorConstants.color3,
                        )),
                    TextButton(
                      onPressed: () =>
                          print(widget._currentWorkout.getTimerElapsed()),
                      child: ValueListenableBuilder(
                          valueListenable: _timer,
                          builder: (context, value, widget) {
                            return Text(
                              value,
                              style: TextStyle(
                                  color: ColorConstants.color3, fontSize: 17),
                            );
                          }),
                    ),
                    TextButton.icon(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(ColorConstants.color3)),
                      onPressed: () => _selectExcersise(context),
                      label: Text("Add"),
                      icon: Icon(Icons.add),
                    ),
                    TextButton.icon(
                      onPressed: () => _endWorkout(),
                      label: Text("Finish",
                          style: TextStyle(color: Colors.greenAccent[700])),
                      icon: Icon(
                        Icons.check,
                        color: Colors.greenAccent[700],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _cancelWorkout(),
                      label: Text("Cancel",
                          style: TextStyle(color: Colors.redAccent[700])),
                      icon: Icon(Icons.clear, color: Colors.redAccent[700]),
                    ),
                    TextButton.icon(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(ColorConstants.color3)),
                      onPressed: () {
                        MainPage.setCurrentPage(HistoryPage(), "History");
                        Navigator.pop(context);
                      },
                      label: Text(
                        "History",
                      ),
                      icon: Icon(
                        Icons.history,
                      ),
                    ),
                    TextButton(
                      onPressed: widget._showSpotifyBar
                          ? () => _setSpotifyBar(false)
                          : () => _setSpotifyBar(true),
                      child: SizedBox(
                        width: 50,
                        height: 30,
                        child: Row(
                          children: [
                            Image.asset(
                                'assets/images/spotify-logo-png-7078.png'),
                            widget._showSpotifyBar
                                ? Text("On",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.greenAccent[700]))
                                : Text("Off",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.redAccent[700])),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: widget._showSnapBar
                          ? () => _setSnapBar(false)
                          : () => _setSnapBar(true),
                      child: SizedBox(
                        width: 50,
                        height: 30,
                        child: Row(
                          children: [
                            Image.asset(
                                'assets/images/snap_logo_transparent.png'),
                            widget._showSnapBar
                                ? Text("On",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.greenAccent[700]))
                                : Text("Off",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.redAccent[700])),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
            ),
            widget._showStatusBar ? _statusBar() : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  void _selectExcersise(BuildContext context) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ExcersisesPage.select()));

    if (result != null) {
      setState(() {
        if (result is ExcersiseModel) {
          widget._currentWorkout.addExcersise(result);
        }
        if (result is ExcersisePackage) {
          widget._currentWorkout.addExcerisePackage(result);
        }

        widget._scrollToBottom = true;
      });
    }
  }

  Widget _spotifyBar() {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.greenAccent[700],
          image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage('assets/images/spotify-logo-png-7078.png'))),
      alignment: Alignment.center,
      height: 35,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: () async {
                await SystemSetting.goto(SettingTarget.BLUETOOTH);
              },
              child: Icon(
                Icons.bluetooth,
                color: ColorConstants.color1,
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.greenAccent[700]),
                  side: MaterialStateProperty.all(
                    BorderSide(color: ColorConstants.color1, width: 1.5),
                  )),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 2, bottom: 2),
            alignment: Alignment.center,
            width: 125,
            height: 29,
            decoration: BoxDecoration(
                border: Border.all(width: 1.5),
                color: Colors.greenAccent[700],
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(onTap: null, child: Icon(Icons.arrow_back_ios)),
                GestureDetector(
                  onTap: null,
                  child: Icon(
                    Icons.play_arrow,
                  ),
                ),
                GestureDetector(
                    onTap: null, child: Icon(Icons.arrow_forward_ios))
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () => _openApp("com.spotify.music"),
              child: Text(
                "Open",
                style: TextStyle(color: ColorConstants.color1),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.greenAccent[700]),
                  side: MaterialStateProperty.all(
                    BorderSide(color: ColorConstants.color1, width: 1.5),
                  )),
            ),
          )
        ],
      ),
    );
  }

  void _setSpotifyBar(bool trueFalse) {
    setState(() {
      widget._currentUser.setSpotifyBar(trueFalse);
      widget._showSpotifyBar = trueFalse;
    });
  }

  void _openApp(String url) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    AppAvailability.launchApp(url).then((_) {
      print("App $url");
    }).catchError((err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("App $url not found!")));
      print(err);
    });
  }

  Widget _snapBar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.greenAccent[700],
          image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(
                  'assets/images/5de4ecded41c9b591ed3bac8_Snapchat-logo.png'))),
      alignment: Alignment.center,
      height: 35,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: null,
              child: Text(
                "Share workout",
                style: TextStyle(color: ColorConstants.color1),
              ),
              style: ButtonStyle(
                  side: MaterialStateProperty.all(
                BorderSide(color: ColorConstants.color1, width: 1.5),
              )),
            ),
            OutlinedButton(
              onPressed: () => _openApp("com.snapchat.android"),
              child: Text(
                "Open",
                style: TextStyle(color: ColorConstants.color1),
              ),
              style: ButtonStyle(
                  side: MaterialStateProperty.all(
                BorderSide(color: ColorConstants.color1, width: 1.5),
              )),
            ),
          ],
        ),
      ),
    );
  }

  void _setSnapBar(bool trueFalse) {
    setState(() {
      widget._currentUser.setSnapBarOn(trueFalse);
      widget._showSnapBar = trueFalse;
    });
  }

  Widget _statusBar() {
    int _getPercentageCompleted() {
      int result = 0;

      if (Workout.getTotalNumberOfSets(widget._currentWorkout) != 0) {
        result = (Workout.getSetsFinished(widget._currentWorkout) /
                Workout.getTotalNumberOfSets(widget._currentWorkout) *
                100)
            .toInt();
      }

      return result;
    }

    return Container(
        height: 20,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sets: ${Workout.getSetsFinished(widget._currentWorkout)}/${Workout.getTotalNumberOfSets(widget._currentWorkout)}",
                style: TextStyle(color: ColorConstants.text3),
              ),
              Text("Progress: ${_getPercentageCompleted()}%",
                  style: TextStyle(color: ColorConstants.text3)),
              Text("Volume: ${widget._currentWorkout.getWorkoutVolume()} kg",
                  style: TextStyle(color: ColorConstants.text3))
            ],
          ),
        ));
  }

  void _endWorkout() {
    widget._currentWorkout.endWorkoutTimer();
    widget._currentWorkout.setDateFinished(DateTime.now());
    widget._currentUser.addWorkoutToHistory(widget._currentWorkout);

    Navigator.pop(context);
    MainPage.getCurrentUser().setCurrentWorkout(null);
  }

  void _cancelWorkout() {
    Navigator.pop(context);
    MainPage.getCurrentUser().setCurrentWorkout(null);
  }

  void _scrollToBottom() {
    widget._scrollController.animateTo(
        widget._scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
    widget._scrollToBottom = false;
  }
}

class CustomTimer {
  Timer _timer;
  int start = 0;
  StreamController streamController;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    streamController = new StreamController<int>();
    _timer = Timer.periodic(oneSec, (Timer timer) {
      start++;
      streamController.sink.add(start);
    });
  }

  void cancelTimer() {
    streamController.close();
    _timer.cancel();
  }
}
