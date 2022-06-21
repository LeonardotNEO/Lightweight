import 'package:lifting_app/Models/User.dart';
import 'package:lifting_app/Models/excersise_model.dart';

class ExcersisePackage {
  String _packageName;
  List<ExcersiseModel> _excersises = [];

  ExcersisePackage(this._packageName);
  ExcersisePackage.withExcersies(this._packageName, this._excersises);
  ExcersisePackage.fromJson(Map<String, dynamic> json) {
    _packageName = json["packageName"];

    List<ExcersiseModel> excersises = [];
    for (Map<String, dynamic> excersise in json["excersises"]) {
      excersises.add(ExcersiseModel.fromJson(excersise));
    }
    _excersises = excersises;
  }

  Map<String, dynamic> toJson() {
    // Excersises
    List<Map<String, dynamic>> excersises = [];
    _excersises.forEach((excersise) {
      excersises.add(excersise.toJson());
    });

    Map<String, dynamic> map = {
      "packageName": _packageName,
      "excersises": excersises
    };

    return map;
  }

  void setPackageName(String name) {
    _packageName = name;
  }

  String getPackageName() {
    return _packageName;
  }

  void setExcersises(List<ExcersiseModel> excersises) {
    _excersises = excersises;
  }

  List<ExcersiseModel> getExcersises() {
    return _excersises;
  }

  void addExcersise(ExcersiseModel excersise) {
    _excersises.add(excersise);
  }

  void removeExcersise(ExcersiseModel excersise) {
    _excersises.remove(excersise);
  }

  static List<ExcersisePackage> getExcersisePackageWithName(
      String name, User user) {
    List<ExcersisePackage> excersisePackages = [];

    user.getExcersisesPackages().forEach((excersisePackage) {
      if (excersisePackage
          .getPackageName()
          .toLowerCase()
          .contains(name.toLowerCase())) {
        excersisePackages.add(excersisePackage);
      }
    });

    return excersisePackages;
  }
}
