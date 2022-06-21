import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lifting_app/Models/ExcersisePackage.dart';
import 'package:lifting_app/Models/FriendRequest.dart';
import 'package:lifting_app/Models/Group.dart';
import 'package:lifting_app/Models/Message.dart';
import 'package:lifting_app/Models/WorkoutReminder.dart';
import 'excersise_model.dart';
import 'package:lifting_app/Models/Workout.dart';
import 'bodypart_model.dart';
import 'package:week_of_year/week_of_year.dart';

class User {
  // USER SETTINGS
  String _id;
  String _username;
  String _password;
  String _email;
  Workout _currentWorkout;

  // PREFERANCES
  int _theme = 17;
  bool _darkMode = false;
  bool _spotifyBarOn = false;
  bool _snapBarOn = false;

  // GENERAL DATA
  List<WorkoutReminder> _workoutReminders = [];
  List<Bodypart> _bodyparts = [];
  List<String> _measurements = ["kg", "km"];
  List<Workout> _workoutHistory = [];
  List<ExcersisePackage> _excersisePackages = [];
  List<ExcersiseModel> _excersises = [];
  List<Workout> _workouts = [];

  // ONLINE DATA
  List<User> _followers = [];
  List<User> _following = [];
  List<String> _friends = [];
  List<Group> _groups = [];
  List<Message> _sentMessages = [];
  List<String> _friendRequests = [];

  User.guest()
      : this._username = "Guest",
        this._password = "",
        this._email = "Guest@email.com" {
    this._id =
        this.hashCode.toString() + Random().nextInt(4000000000).toString();
    _loadData();
  }

  /// Standard constructor
  User(this._username, this._password, this._email) {
    this._id =
        this.hashCode.toString() + Random().nextInt(4000000000).toString();
    _loadData();
  }

  void _loadData() async {
    // BODYPARTS
    await rootBundle.loadString('assets/json/bodyparts.json').then(
        (value) => (json.decode(value) as List<dynamic>).forEach((element) {
              _bodyparts.add(Bodypart.fromJson(element));
            }));

    // EXCERSISES
    await rootBundle.loadString('assets/json/excersises.json').then(
        (value) => (json.decode(value) as List<dynamic>).forEach((element) {
              _excersises.add(ExcersiseModel.fromJson(element));
            }));

    // WORKOUTS
    await rootBundle.loadString('assets/json/workouts.json').then(
        (value) => (json.decode(value) as List<dynamic>).forEach((element) {
              _workouts.add(Workout.fromJson(element));
            }));

    // REMINDERS
    await rootBundle.loadString('assets/json/workout_reminders.json').then(
        (value) => (json.decode(value) as List<dynamic>).forEach((element) {
              _workoutReminders.add(WorkoutReminder.fromJson(element));
            }));
  }

  /// Constructor for converting an User json to a User object
  User.fromJson(Map<String, dynamic> json)
      : _id = json["id"],
        _username = json["username"],
        _password = json["password"],
        _email = json["email"],
        _theme = json["theme"],
        _darkMode = json["darkMode"],
        _spotifyBarOn = json["spotifyBarOn"],
        _snapBarOn = json["snapBarOn"] {
    // CURRENT WORKOUT
    _currentWorkout = json["currentWorkout"] == null
        ? null
        : Workout.fromJson(json["currentWorkout"]);

    // ADD EXCERSISES
    if (json["excersises"] != null) {
      for (Map<String, dynamic> excersise in json["excersises"]) {
        _excersises.add(ExcersiseModel.fromJson(excersise));
      }
    } else {
      _excersises = [];
    }

    // WORKOUTS
    if (json["workouts"] != null) {
      for (Map<String, dynamic> workout in json["workouts"]) {
        _workouts.add(Workout.fromJson(workout));
      }
    } else {
      _workouts = [];
    }

    // WORKOUT HISTORY
    if (json["workoutHistory"] != null) {
      for (Map<String, dynamic> workout in json["workoutHistory"]) {
        _workoutHistory.add(Workout.fromJson(workout));
      }
    } else {
      _workoutHistory = [];
    }

    // BODYPARTS
    if (json["bodyparts"] != null) {
      (json["bodyparts"] as List<dynamic>).forEach((element) {
        _bodyparts.add(Bodypart.fromJson(element));
      });
    } else {
      _bodyparts = [];
    }

    // WORKOUT REMINDERS
    if (json["workoutReminders"] != null) {
      (json["workoutReminders"] as List<dynamic>).forEach((element) {
        _workoutReminders.add(WorkoutReminder.fromJson(element));
      });
    } else {
      _workoutReminders = [];
    }

    // FRIEND REQUESTS
    if (json["friendRequests"] != null) {
      (json["friendRequests"] as List<dynamic>).forEach((element) {
        _friendRequests.add(element);
      });
    } else {
      _friendRequests = [];
    }

    // FRIENDS
    if (json["friends"] != null) {
      (json["friends"] as List<dynamic>).forEach((element) {
        _friends.add(element);
      });
    } else {
      _friendRequests = [];
    }
  }

  /// Method for converting this user object to json
  Map<String, dynamic> toJson() {
    // EXCERSISES
    List<Map<String, dynamic>> excersisesJson = [];
    for (ExcersiseModel excersise in _excersises) {
      excersisesJson.add(excersise.toJson());
    }

    // WORKOUTS
    List<Map<String, dynamic>> workoutsJson = [];
    for (Workout workout in _workouts) {
      workoutsJson.add(workout.toJson());
    }

    // WORKOUT HISTORY
    List<Map<String, dynamic>> workoutHistoryJson = [];
    for (Workout workout in _workoutHistory) {
      workoutHistoryJson.add(workout.toJson());
    }

    // BODYPARTS
    List<Map<String, dynamic>> bodypartsJson = [];
    _bodyparts.forEach((element) {
      bodypartsJson.add(element.toJson());
    });

    // WORKOUT REMINDERS
    List<Map<String, dynamic>> remindersJson = [];
    _workoutReminders.forEach((element) {
      remindersJson.add(element.toJson());
    });

    return {
      "id": _id,
      "username": _username,
      "password": _password,
      "email": _email,
      "currentWorkout":
          _currentWorkout == null ? null : _currentWorkout.toJson(),
      "excersises": excersisesJson,
      "workouts": workoutsJson,
      "workoutHistory": workoutHistoryJson,
      "theme": _theme,
      "darkMode": _darkMode,
      "spotifyBarOn": _spotifyBarOn,
      "snapBarOn": _snapBarOn,
      "bodyparts": bodypartsJson,
      "workoutReminders": remindersJson,
      "friendRequests": _friendRequests,
      "friends": _friends
    };
  }

  void setPassword(String password) {
    this._password = password;
  }

  void setEmail(String email) {
    this._email = email;
  }

  void setCurrentWorkout(Workout workout) {
    this._currentWorkout = workout;
  }

  String getUsername() {
    return _username;
  }

  String getPassword() {
    return _password;
  }

  String getEmail() {
    return _email;
  }

  List<ExcersiseModel> getExcersises() {
    return _excersises;
  }

  List<Workout> getWorkouts() {
    return _workouts;
  }

  Workout getCurrentWorkout() {
    return _currentWorkout;
  }

  List<Workout> getWorkoutHistory() {
    return _workoutHistory;
  }

  void newExcersise(ExcersiseModel excersiseModel) {
    _excersises.add(excersiseModel);
  }

  void deleteExcersise(ExcersiseModel excersiseModel) {
    _excersises.remove(excersiseModel);
  }

  bool addWorkoutToHistory(Workout workoutModel) {
    if (!_workoutHistory.contains(workoutModel)) {
      _workoutHistory.add(workoutModel);
      return true;
    } else {
      return false;
    }
  }

  void addWorkout(Workout workoutModel) {
    this._workouts.add(workoutModel);
  }

  void deleteWorkout(Workout workoutModel) {
    this._workouts.remove(workoutModel);
  }

  ExcersiseModel getExcersiseByName(String name) {
    for (ExcersiseModel excersiseModel in _excersises) {
      if (excersiseModel.getName() == name) {
        return excersiseModel;
      }
    }
  }

  void setDarkMode(bool boolean) {
    _darkMode = boolean;
  }

  bool getdarkMode() {
    return _darkMode;
  }

  void setSpotifyBar(bool truefalse) {
    _spotifyBarOn = truefalse;
  }

  bool getSpotifyBarOn() {
    return _spotifyBarOn;
  }

  List<Bodypart> getBodyparts() {
    return _bodyparts;
  }

  List<Workout> getWorkoutsThisWeek() {
    List<Workout> workoutsCurrentWeek = [];

    _workoutHistory.forEach((element) {
      if (element.getDateFinished().weekOfYear == DateTime.now().weekOfYear) {
        workoutsCurrentWeek.add(element);
      }
    });

    workoutsCurrentWeek
        .sort((a, b) => a.getDateFinished().compareTo(b.getDateFinished()));

    return workoutsCurrentWeek;
  }

  List<Workout> getWorkoutsThisMonth() {
    List<Workout> workoutsCurrentMonth = [];

    _workoutHistory.forEach((element) {
      if (element.getDateFinished().month == DateTime.now().month &&
          element.getDateFinished().year == DateTime.now().year) {
        workoutsCurrentMonth.add(element);
      }
    });

    workoutsCurrentMonth
        .sort((a, b) => a.getDateFinished().compareTo(b.getDateFinished()));

    return workoutsCurrentMonth;
  }

  List<Workout> getWorkoutsThisYear() {
    List<Workout> workoutsCurrentYear = [];

    _workoutHistory.forEach((element) {
      if (element.getDateFinished().year == DateTime.now().year) {
        workoutsCurrentYear.add(element);
      }
    });

    workoutsCurrentYear
        .sort((a, b) => a.getDateFinished().compareTo(b.getDateFinished()));

    return workoutsCurrentYear;
  }

  List<ExcersisePackage> getExcersisesPackages() {
    return _excersisePackages;
  }

  void addExcersisePackage(ExcersisePackage package) {
    _excersisePackages.add(package);
  }

  void removeExcersisePackage(ExcersisePackage package) {
    _excersisePackages.remove(package);
  }

  List<WorkoutReminder> getWorkoutReminders() {
    return _workoutReminders;
  }

  List<WorkoutReminder> getTodaysWorkoutReminder() {
    List<WorkoutReminder> reminders = [];

    _workoutReminders.forEach((element) {
      if (element.getTime() == DateTime.now().weekday) {
        reminders.add(element);
      }
    });

    return reminders;
  }

  List<WorkoutReminder> getWorkoutReminderGivenDay(int day) {
    List<WorkoutReminder> reminders = [];

    _workoutReminders.forEach((element) {
      if (element.getTime() == day) {
        reminders.add(element);
      }
    });

    return reminders;
  }

  void addWorkoutReminder(WorkoutReminder reminder) {
    _workoutReminders.add(reminder);
  }

  void removeWorkoutReminder(WorkoutReminder reminder) {
    _workoutReminders.remove(reminder);
  }

  List<String> getMeasurements() {
    return _measurements;
  }

  void setTheme(int index) {
    _theme = index;
  }

  int getTheme() {
    return _theme;
  }

  void setSnapBarOn(bool trueFalse) {
    _snapBarOn = trueFalse;
  }

  bool getSnapBarOn() {
    return _snapBarOn;
  }

  static Future<List<String>> validateNewUser(String username, String email,
      String password, String repeatPassword) async {
    List<String> errors = [];

    var findEmail = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    var findUser = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();

    if (findEmail.docs.isNotEmpty) {
      errors.add("Theres already a user with that email");
    }
    if (findUser.docs.isNotEmpty) {
      errors.add("Theres already a user with that username");
    }
    if (username.length == 0) {
      errors.add("Username cant be empty");
    }
    if (!EmailValidator.validate(email)) {
      errors.add("Input for email is not a valid email");
    }
    if (email.length == 0) {
      errors.add("Email cant be empty");
    }
    if (password != repeatPassword) {
      errors.add("Password and repeat password do not match");
    }
    if (password.length < 6) {
      errors.add("Password needs a length of at least 6 characters");
    }

    return errors;
  }

  static Future<List<String>> validateLogin(
      String email, String password) async {
    List<String> errors = [];

    var ref = FirebaseFirestore.instance.collection("users");
    var doc = await ref.doc(email).get();

    await ref
        .where("password", isEqualTo: password)
        .where("email", isEqualTo: email)
        .get();

    if (!doc.exists) {
      errors.add("No user with that email registered");
    }
    if (doc.exists) {
      if (doc.get("password") != password) {
        errors.add("Password is incorrect");
      }
    }

    return errors;
  }

  void sendFriendRequest(String email) async {
    //_friendRequests.add(username);
    await FirebaseFirestore.instance.collection("users").doc(email).update({
      "friendRequests": FieldValue.arrayUnion([this._id])
    });
  }

  void acceptFriendRequest(String id) {
    //_friends.add(username);
    //_friendRequests.remove(username);
  }

  List<String> getFriendRequests() {
    return _friendRequests;
  }

  bool isFriends(User user) {
    bool result = false;

    _friends.forEach((element) {
      if (element == user.getUsername()) {
        result = true;
        return;
      }
    });

    return result;
  }

  String getId() {
    return _id;
  }
}
