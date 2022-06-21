import 'package:lifting_app/Models/bodypart_model.dart';
import 'package:lifting_app/Models/Weight.dart';

import 'Set.dart';
import 'User.dart';

class ExcersiseModel {
  String _name;
  Bodypart _primaryBodypart;
  List<Set> _sets = [];
  String _measurementType;

  ExcersiseModel.empty();
  ExcersiseModel(this._name, this._primaryBodypart, this._measurementType);

  ExcersiseModel.inWorkout(
      this._name, this._primaryBodypart, this._sets, this._measurementType);

  ExcersiseModel.fromJson(Map<String, dynamic> json) {
    _name = json["name"];
    _primaryBodypart = Bodypart.fromJson(json["bodypart"]);

    _measurementType = json["measurementType"];

    List<Set> sets = [];
    if (json["sets"] != null) {
      for (Map<String, dynamic> set in json["sets"]) {
        sets.add(Set.fromJson(set));
      }
    }
    _sets = sets;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> setsAsJson = [];
    for (Set set in _sets) {
      setsAsJson.add(set.toJson());
    }

    Map<String, dynamic> returnMap = {
      "name": _name,
      "bodypart": _primaryBodypart.toJson(),
      "measurementType": _measurementType,
      "sets": setsAsJson
    };
    return returnMap;
  }

  String getName() {
    return this._name;
  }

  Bodypart getBodypart() {
    return this._primaryBodypart;
  }

  List<Set> getSets() {
    return this._sets;
  }

  void addSet(Set set) {
    this._sets.add(set);
  }

  void removeSet(Set set) {
    this._sets.remove(set);
  }

  void setName(String name) {
    this._name = name;
  }

  void setBodypart(Bodypart bodypart) {
    this._primaryBodypart = bodypart;
  }

  double getExcersiseVolume() {
    double sum = 0;

    for (Set set in _sets) {
      if (set.getFinished() == true) {
        sum += set.getWeight().getLoad() * set.getRepetitions();
      }
    }

    return sum;
  }

  static getExcersisesWithName(String name, User user) {
    List<ExcersiseModel> excersises = [];
    for (ExcersiseModel excersiseModel in user.getExcersises()) {
      if (excersiseModel.getName().toLowerCase().contains(name.toLowerCase())) {
        excersises.add(excersiseModel);
      }
    }

    return excersises;
  }

  static getExcersisesWithBodypart(Bodypart bodypart, User user) {
    List<ExcersiseModel> excersises = [];
    for (ExcersiseModel excersiseModel in user.getExcersises()) {
      if (excersiseModel
          .getBodypart()
          .getName()
          .toLowerCase()
          .contains(bodypart.getName().toLowerCase())) {
        excersises.add(excersiseModel);
      }
    }

    return excersises;
  }

  String getMeasurementType() {
    return _measurementType;
  }

  void setMeasurementType(String measurementType) {
    _measurementType = measurementType;
  }
}
