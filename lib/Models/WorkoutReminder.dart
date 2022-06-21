import 'package:lifting_app/Models/Workout.dart';

class WorkoutReminder {
  Workout _workout;
  String _title;
  String _descriptiton;
  int _time;

  WorkoutReminder(this._workout, this._title, this._descriptiton, this._time);
  WorkoutReminder.fromJson(Map<String, dynamic> json) {
    _workout = json["workout"] == null
        ? _workout = null
        : Workout.fromJson(json["workout"]);
    _title = json["title"];
    _descriptiton = json["description"];
    _time = json["time"];
  }

  Map<String, dynamic> toJson() {
    return {
      "workout": _workout == null ? null : _workout.toJson(),
      "title": _title,
      "description": _descriptiton,
      "time": _time
    };
  }

  Workout getAttachedWorkout() {
    return _workout;
  }

  String getTitle() {
    return _title;
  }

  void setTitle(String title) {
    _title = title;
  }

  void setDescription(String description) {
    _descriptiton = description;
  }

  void setWorkout(Workout workout) {
    _workout = workout;
  }

  int getTime() {
    return _time;
  }

  String getDescription() {
    return _descriptiton;
  }
}
