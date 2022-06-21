import 'package:lifting_app/Models/ExcersisePackage.dart';
import 'package:lifting_app/Models/Weight.dart';
import 'package:lifting_app/Models/excersise_model.dart';
import 'package:clock/clock.dart';
import 'package:lifting_app/Models/Set.dart';
import 'package:lifting_app/Models/bodypart_model.dart';

class Workout {
  List<ExcersiseModel> _excersises = [];
  List<ExcersisePackage> _packages = [];
  String _workoutName;
  Duration _duration = Duration();
  var _timer = clock.stopwatch();
  DateTime _dateFinished;

  Workout();
  Workout.withName(this._workoutName);
  Workout.withDateFinished(
      this._workoutName, this._excersises, this._dateFinished);
  Workout.withWorkouts(this._workoutName, this._excersises);

  Workout.fromJson(Map<String, dynamic> json) {
    _workoutName = json["workoutName"];
    _dateFinished = json["dateFinished"] == ""
        ? null
        : DateTime.parse(json["dateFinished"]);
    _duration = parseDuration(json["duration"]);

    // excersises
    List<ExcersiseModel> excersiseModels = [];
    if (json["excersises"] != null) {
      for (Map<String, dynamic> excersise in json["excersises"]) {
        excersiseModels.add(ExcersiseModel.fromJson(excersise));
      }
    }
    _excersises = excersiseModels;

    // packages
    List<ExcersisePackage> packages = [];
    if (json["packages"] != null) {
      for (Map<String, dynamic> package in json["packages"]) {
        packages.add(ExcersisePackage.fromJson(package));
      }
    }
  }

  Map<String, dynamic> toJson() {
    // excersises
    List<Map<String, dynamic>> excersisesAsJson = [];
    for (ExcersiseModel excersise in _excersises) {
      excersisesAsJson.add(excersise.toJson());
    }

    // packages
    List<Map<String, dynamic>> packagesAsJson = [];
    for (ExcersisePackage package in _packages) {
      excersisesAsJson.add(package.toJson());
    }

    String dateFinished = "";
    if (_dateFinished != null) {
      dateFinished = _dateFinished.toIso8601String();
    }

    Map<String, dynamic> returnMap = {
      "workoutName": _workoutName,
      "excersises": excersisesAsJson,
      "dateFinished": dateFinished,
      "duration": _duration.toString(),
      "packages": packagesAsJson
    };

    return returnMap;
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  void startWorkoutTimer() {
    _timer.start();
  }

  void endWorkoutTimer() {
    _timer.stop();
    _duration = _timer.elapsed;
  }

  void setDateFinished(DateTime date) {
    _dateFinished = date;
  }

  String getDuration() {
    List<String> split = _duration.toString().split(".");
    return split[0];
  }

  DateTime getDateFinished() {
    return _dateFinished;
  }

  String getTimerElapsed() {
    List<String> split = _timer.elapsed.toString().split(".");
    return split[0];
  }

  void setExcersises(List<ExcersiseModel> excersises) {
    _excersises = excersises;
  }

  String getWorkoutName() {
    return _workoutName;
  }

  void setWorkoutName(String name) {
    _workoutName = name;
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

  Workout copyOf() {
    Workout newWorkout = Workout();
    newWorkout.setWorkoutName(this._workoutName);

    List<ExcersiseModel> excersises =
        new List<ExcersiseModel>.from(this._excersises);
    newWorkout.setExcersises(excersises);

    return newWorkout;
  }

  double getWorkoutVolume() {
    double sum = 0;

    for (ExcersiseModel excersise in _excersises) {
      sum += excersise.getExcersiseVolume();
    }

    return sum;
  }

  List<String> validateWorkoutModel() {
    List<String> errors = [];

    if (this.getWorkoutName().length == 0) {
      errors.add("Workoutname cant be empty");
    }

    return errors;
  }

  static ExcersiseModel getPreviousExcersise(
      String excersiseName, List<Workout> workouts) {
    ExcersiseModel excersise;

    for (Workout workout in getWorkoutsSortedByDate(workouts)) {
      for (ExcersiseModel excersiseFor in workout.getExcersises()) {
        if (excersiseName == excersiseFor.getName()) {
          excersise = excersiseFor;
        }
      }
    }

    return excersise;
  }

  static List<Workout> getWorkoutsSortedByDate(List<Workout> workouts) {
    List<Workout> workoutCopied = [];
    for (Workout workout in workouts) {
      workoutCopied.add(Workout.fromJson(workout.toJson()));
    }

    workoutCopied.sort((a, b) {
      return b.getDateFinished().compareTo(a.getDateFinished());
    });

    return workoutCopied;
  }

  static int getTotalNumberOfSets(Workout workout) {
    int sets = 0;
    if (workout != null) {
      for (ExcersiseModel excersise in workout.getExcersises()) {
        sets += excersise.getSets().length;
      }
    }

    return sets;
  }

  static int getSetsFinished(Workout workout) {
    int setsFinished = 0;
    if (workout != null) {
      for (ExcersiseModel excersise in workout.getExcersises()) {
        for (Set set in excersise.getSets()) {
          if (set.getFinished()) {
            setsFinished++;
          }
        }
      }
    }

    return setsFinished;
  }

  void addExcerisePackage(ExcersisePackage excersisePackage) {
    _packages.add(excersisePackage);
  }

  void removeExcerisePackage(ExcersisePackage excersisePackage) {
    _packages.remove(excersisePackage);
  }

  List<ExcersisePackage> getExcersisePackages() {
    return _packages;
  }
}
