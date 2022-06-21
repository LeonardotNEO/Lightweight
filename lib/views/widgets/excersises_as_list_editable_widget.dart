import 'package:flutter/material.dart';
import 'package:lifting_app/Models/Weight.dart';
import 'package:lifting_app/Models/excersise_model.dart';
import 'package:lifting_app/Models/Workout.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/Models/Set.dart';
import 'package:lifting_app/Models/User.dart';

class ExcersisesAsListEditable extends StatefulWidget {
  Workout _workout;
  User _currentUser;
  Function _rebuild;

  ExcersisesAsListEditable(this._workout, this._currentUser, this._rebuild);
  ExcersisesAsListEditable.editMode(
      this._workout, this._currentUser, this._rebuild);

  @override
  _ExcersisesAsListEditableState createState() =>
      _ExcersisesAsListEditableState();
}

class _ExcersisesAsListEditableState extends State<ExcersisesAsListEditable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [...getExcersisesAsWidgets(), ...getPackagesAsWidgets()],
    );
  }

  List<Widget> getPackagesAsWidgets() {
    List<Widget> widgets = [];

    widget._workout.getExcersisePackages().forEach((element) {
      List<Widget> rows = [];
      List<PopupMenuItem> popupItems = [];

      element.getExcersises().forEach((element) {
        // popup items
        popupItems.add(PopupMenuItem(
          child: Text(
            element.getName(),
          ),
          value: element,
        ));

        // add rows
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              element.getName(),
              style: TextStyle(color: ColorConstants.color1, fontSize: 15),
            ),
            Text(element.getBodypart().getName())
          ],
        ));
      });

      PopupMenuButtonState();

      widgets.add(GestureDetector(
        onTap: null,
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
          child: Container(
            padding: EdgeInsets.all(10),
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
                      element.getPackageName(),
                      style: TextStyle(
                          color: ColorConstants.color1,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: PopupMenuButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: ColorConstants.color1,
                        ),
                        itemBuilder: (context) => popupItems,
                        onSelected: (value) {
                          setState(() {
                            widget._workout.addExcersise(value);
                            widget._workout.removeExcerisePackage(element);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    children: [...rows],
                  ),
                )
              ],
            ),
          ),
        ),
      ));
    });

    return widgets;
  }

  List<Widget> getExcersisesAsWidgets() {
    List<Widget> list = [];
    List<ExcersiseModel> excersises = widget._workout.getExcersises();

    for (ExcersiseModel excersiseModel in excersises) {
      list.add(Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ColorConstants.color1),
          child: Column(
            children: [
              _excersiseHeader(excersiseModel),
              ...getRowsInExcersisesAsWidget(excersiseModel),
              _addSetButton(excersiseModel)
            ],
          ),
        ),
      ));
    }

    return list;
  }

  Widget _addSetButton(ExcersiseModel excersise) {
    return Container(
      height: 35,
      child: TextButton.icon(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(ColorConstants.color3)),
          onPressed: () => _addSetToExcersise(excersise,
              Set(0, Weight(0, excersise.getMeasurementType()), false)),
          icon: Icon(
            Icons.add,
            size: 18,
          ),
          label: Text("Set")),
    );
  }

  Widget _excersiseHeader(ExcersiseModel excersise) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 13),
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            excersise.getName(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorConstants.color3,
                fontSize: 16),
          ),
          GestureDetector(
              onTap: null,
              child: Icon(
                Icons.help,
                size: 22,
                color: ColorConstants.color3,
              ))
        ],
      ),
    );
  }

  List<Widget> getRowsInExcersisesAsWidget(ExcersiseModel excersiseModel) {
    List<Widget> list = [
      Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Previous",
                  style: TextStyle(fontSize: 15, color: ColorConstants.text3)),
              Padding(
                padding: const EdgeInsets.only(left: 110),
                child: Text(excersiseModel.getMeasurementType(),
                    style:
                        TextStyle(fontSize: 15, color: ColorConstants.text3)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Text("Reps",
                    style:
                        TextStyle(fontSize: 15, color: ColorConstants.text3)),
              ),
            ],
          ))
    ];
    int index = 0;

    for (Set set in excersiseModel.getSets()) {
      list.add(_rowWidget(set, excersiseModel, index));
      index++;
    }

    return list;
  }

  Widget _rowWidget(Set set, ExcersiseModel excersise, int index) {
    return Dismissible(
      key: Key(set.hashCode.toString() +
          excersise.hashCode.toString() +
          index.toString()),
      onDismissed: (direction) => _removeSetFromExcersise(excersise, set),
      child: Container(
          padding: EdgeInsets.only(top: 3, bottom: 3),
          color: ColorConstants.color1,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _previousSet(Workout.getPreviousExcersise(excersise.getName(),
                              widget._currentUser.getWorkoutHistory()) ==
                          null
                      ? null
                      : (index <
                              Workout.getPreviousExcersise(excersise.getName(),
                                      widget._currentUser.getWorkoutHistory())
                                  .getSets()
                                  .length
                          ? Workout.getPreviousExcersise(excersise.getName(),
                                  widget._currentUser.getWorkoutHistory())
                              .getSets()[index]
                          : null)),
                  _rowWeightRepBoxEditable(set),
                  _setCheckmark(set),
                ]),
          )),
    );
  }

  Widget _setCheckmark(Set set) {
    return GestureDetector(
      onTap: () =>
          _setSetFinished(set, set.getFinished() == true ? false : true),
      child: Container(
        child: Icon(Icons.check,
            size: 28,
            color: set.getFinished()
                ? ColorConstants.color2
                : ColorConstants.color3),
        decoration: BoxDecoration(
            color: set.getFinished()
                ? Colors.greenAccent[700]
                : ColorConstants.color1,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(
                width: 1,
                color: set.getFinished()
                    ? Colors.greenAccent[700]
                    : ColorConstants.color3)),
      ),
    );
  }

  Widget _rowWeightRepBoxEditable(Set set) {
    TextEditingController _weight = TextEditingController();
    TextEditingController _reps = TextEditingController();
    _weight.text = set.getWeight().getLoad().toString();
    _reps.text = set.getRepetitions().toString();

    _weight.addListener(() {
      set.setWeight(Weight(double.parse(_weight.text), "kg"));
    });

    _reps.addListener(() {
      set.setRepetitions(int.parse(_reps.text));
    });

    void _makeSelection(TextEditingController controller) {
      controller.selection =
          TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    }

    Widget _textEditingBox(TextEditingController controller, Set set) {
      return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: set.getFinished()
                  ? ColorConstants.color1
                  : ColorConstants.text3),
          height: 30,
          width: 70,
          child: TextField(
            enabled: set.getFinished() ? false : true,
            keyboardType: TextInputType.number,
            onTap: () => _makeSelection(controller),
            controller: controller,
            maxLength: 7,
            style: TextStyle(
                fontSize: 15,
                color: set.getFinished()
                    ? ColorConstants.text3
                    : ColorConstants.text1Dark),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 0, bottom: 13),
                counterText: "",
                hintText: "",
                border: InputBorder.none),
          ));
    }

    return Row(
      children: [
        _textEditingBox(_weight, set),
        Text(" x "),
        _textEditingBox(_reps, set)
      ],
    );
  }

  Widget _previousSet(Set set) {
    return Container(
        alignment: Alignment.centerLeft,
        width: 100,
        child: set == null
            ? Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  width: 15,
                  height: 1,
                  color: ColorConstants.text3,
                ),
              )
            : Text(
                "${set.getWeight().getLoad()} ${set.getWeight().getType()} x ${set.getRepetitions()}",
                style: TextStyle(fontSize: 15, color: ColorConstants.text3)));
  }

  void _addSetToExcersise(ExcersiseModel excersise, Set set) {
    setState(() {
      excersise.addSet(set);
    });
  }

  void _removeSetFromExcersise(ExcersiseModel excersise, Set set) {
    setState(() {
      excersise.removeSet(set);
    });
  }

  void _setSetFinished(Set set, bool finished) {
    setState(() {
      set.setFinished(finished);
      widget._rebuild();
    });
  }
}
