import 'package:flutter/material.dart';
import 'package:lifting_app/Models/excersise_model.dart';
import 'package:lifting_app/Models/User.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/Models/bodypart_model.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/excersise/excersises_view.dart';
import 'package:lifting_app/views/widgets/back_button_as_logo.dart';

class ExcersisePage extends StatefulWidget {
  User _currentUser = MainPage.getCurrentUser();
  ExcersiseModel _excersise;
  bool _new = false;

  ExcersisePage.editExcersise(this._excersise);
  ExcersisePage.newExcersise()
      : _new = true,
        _excersise = ExcersiseModel.empty();

  @override
  _ExcersisePageState createState() => _ExcersisePageState();
}

class _ExcersisePageState extends State<ExcersisePage> {
  TextEditingController _excersiseName = TextEditingController();
  String _dropdownValueBodypart;
  String _dropdownValueMeasurement;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _excersiseName.text = widget._new ? "" : widget._excersise.getName();

    _dropdownValueBodypart = widget._new
        ? widget._currentUser.getBodyparts()[0].getName()
        : widget._excersise.getBodypart().getName();

    _dropdownValueMeasurement = widget._new
        ? widget._currentUser.getMeasurements()[0]
        : widget._excersise.getMeasurementType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.color1,
        leading: BackButtonAsLogo(() => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              children: [
                _excersiseNameField(),
                _dropDownMenuBodypart(),
                _dropDownMenuMeasurement(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget._new
                        ? _button(() => _newExcersise(widget._excersise),
                            "Create excersise", Icons.add)
                        : _button(() => _editExcersise(), "Edit excersise",
                            Icons.edit),
                    widget._new
                        ? SizedBox.shrink()
                        : _button(() => _deleteExcersiseAlert(),
                            "Delete excersise", Icons.delete)
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget _dropDownMenuBodypart() {
    return DropdownButton(
      style: TextStyle(color: ColorConstants.text4Lighest),
      onChanged: (value) {
        setState(() {
          widget._excersise.setBodypart(Bodypart(value));
          _dropdownValueBodypart = value;
        });
      },
      hint: Text(
        "Bodypart",
        style: TextStyle(color: ColorConstants.text4Lighest),
      ),
      value: _dropdownValueBodypart,
      items: [
        ..._dropdownMenuItemBodyparts(widget._currentUser.getBodyparts()),
      ],
    );
  }

  List<DropdownMenuItem> _dropdownMenuItemBodyparts(List<Bodypart> bodyparts) {
    List<DropdownMenuItem> widgets = [];
    for (Bodypart bodypart in bodyparts) {
      widgets.add(DropdownMenuItem(
        child: Text(bodypart.getName(),
            style: TextStyle(color: ColorConstants.text4Lighest)),
        value: bodypart.getName(),
      ));
    }

    return widgets;
  }

  Widget _dropDownMenuMeasurement() {
    return DropdownButton(
      style: TextStyle(color: ColorConstants.text4Lighest),
      onChanged: (value) {
        setState(() {
          widget._excersise.setMeasurementType(value);
          _dropdownValueMeasurement = value;
        });
      },
      hint: Text(
        "Measurement",
        style: TextStyle(color: ColorConstants.text4Lighest),
      ),
      value: _dropdownValueMeasurement,
      items: [
        ..._dropdownMenuItemMeasurements(widget._currentUser.getMeasurements()),
      ],
    );
  }

  List<DropdownMenuItem> _dropdownMenuItemMeasurements(
      List<String> measurements) {
    List<DropdownMenuItem> widgets = [];
    for (String measurements in measurements) {
      widgets.add(DropdownMenuItem(
        child: Text(
          measurements,
          style: TextStyle(color: ColorConstants.text4Lighest),
        ),
        value: measurements,
      ));
    }

    return widgets;
  }

  Widget _excersiseNameField() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorConstants.color3,
      ),
      child: TextField(
        onSubmitted: (value) => {widget._excersise.setName(value)},
        controller: _excersiseName,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 25, color: ColorConstants.text1Dark),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: ColorConstants.text2),
          hintText: "Excersise name...",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _button(_onPressed, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton.icon(
          icon: Icon(
            icon,
            size: 20,
            color: ColorConstants.color3,
          ),
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: ColorConstants.text1Dark)),
          onPressed: _onPressed,
          label: Text(
            text,
            style: TextStyle(color: ColorConstants.color3),
          )),
    );
  }

  void _deleteExcersiseAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete excersise'),
        content: const Text(
            'Are you sure you want to delete this excersise permanently?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteExcersise(widget._excersise);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _newExcersiseAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Excersise name cant be empty'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _editExcersise() {
    widget._excersise.setName(_excersiseName.text);
    widget._excersise.setBodypart(Bodypart(_dropdownValueBodypart));
    Navigator.pop(context);
  }

  void _newExcersise(ExcersiseModel excersise) {
    if (_excersiseName.text.isEmpty) {
      _newExcersiseAlert();
    } else {
      widget._excersise.setName(_excersiseName.text);
      widget._excersise.setBodypart(Bodypart(_dropdownValueBodypart));
      widget._excersise.setMeasurementType(_dropdownValueMeasurement);
      widget._currentUser.newExcersise(excersise);
      Navigator.pop(context);
    }
  }

  void _deleteExcersise(ExcersiseModel excersise) {
    widget._currentUser.deleteExcersise(excersise);
    Navigator.pop(context, true);
  }
}
