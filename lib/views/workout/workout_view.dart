import 'package:flutter/material.dart';
import 'package:lifting_app/Models/ExcersisePackage.dart';
import 'package:lifting_app/Models/excersise_model.dart';
import 'package:lifting_app/Models/Workout.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/excersise/excersises_view.dart';
import 'package:lifting_app/views/widgets/back_button_as_logo.dart';
import 'package:lifting_app/views/widgets/excersises_as_list_editable_widget.dart';
import 'package:lifting_app/views/widgets/toolbar_with_buttons.dart';

class WorkoutView extends StatefulWidget {
  Workout _workout;
  TextEditingController _workoutName = TextEditingController();
  bool _create = false;

  WorkoutView.blank()
      : _create = true,
        _workout = Workout();

  WorkoutView.edit(this._workout) {
    _workoutName.text = _workout.getWorkoutName();
  }

  @override
  _WorkoutViewState createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _toolbar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _workoutNameField(),
            ExcersisesAsListEditable(
                widget._workout, MainPage.getCurrentUser(), _rebuild),
          ],
        ),
      ),
    );
  }

  void _rebuild() {
    setState(() {});
  }

  void _addExcersisesToWorkout() async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ExcersisesPage.select()));

    if (result != null) {
      setState(() {
        if (result is ExcersiseModel) {
          widget._workout.addExcersise(result);
        }
        if (result is ExcersisePackage) {
          widget._workout.addExcerisePackage(result);
        }

        //widget._scrollToBottom = true;
      });
    }
  }

  Widget _toolbar(context) {
    return ToolbarWithButtons.toolbar([
      BackButtonAsLogo(
        () => _goBack(context),
        size: 10,
      ),
      ToolbarWithButtons.button(
          () => _addExcersisesToWorkout(), "Add excersise", Icons.add),
      widget._create
          ? ToolbarWithButtons.button(
              () => _createWorkout(context), "OK", Icons.add)
          : ToolbarWithButtons.button(
              () => _editWorkout(context), "OK", Icons.edit),
    ]);
  }

  Widget _workoutNameField() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorConstants.color3),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
          child: TextField(
            style: TextStyle(color: ColorConstants.text1Dark, fontSize: 22),
            decoration: InputDecoration(
                hintText: "Workout name...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: ColorConstants.text2)),
            controller: widget._workoutName,
            onChanged: (value) {
              setState(() {
                widget._workout.setWorkoutName(value);
              });
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _getErrorAsWidgets() {
    List<Widget> widgets = [];

    for (String error in widget._workout.validateWorkoutModel()) {
      widgets.add(Text(error));
    }

    return widgets;
  }

  void _createWorkout(context1) {
    widget._workout.setWorkoutName(widget._workoutName.text);

    if (widget._workout.validateWorkoutModel().isEmpty) {
      MainPage.getCurrentUser().addWorkout(widget._workout);
      Navigator.pop(context1, true);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [..._getErrorAsWidgets()],
                ),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.pop(context, "OK"),
                  )
                ],
              ));
    }
  }

  void _editWorkout(context1) {
    if (widget._workout.validateWorkoutModel().isEmpty) {
      widget._workout.setWorkoutName(widget._workoutName.text);
      Navigator.pop(context1);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [..._getErrorAsWidgets()],
                ),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.pop(context, "OK"),
                  )
                ],
              ));
    }
  }

  void _goBack(context1) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Text("Changes wont be saved"),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context, "Cancel"),
                ),
                TextButton(
                  child: Text("OK"),
                  onPressed: () => {
                    Navigator.pop(context, "OK"),
                    Navigator.pop(context1, "OK"),
                  },
                )
              ],
            ));
  }
}
