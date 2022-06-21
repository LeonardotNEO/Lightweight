import 'dart:math';

import 'package:lifting_app/Models/Message.dart';
import 'package:lifting_app/Models/User.dart';
import 'package:lifting_app/Models/Workout.dart';

class Group {
  String _groupName;
  String _groupId;
  List<String> _members;
  List<String> _admins;
  List<String> _moderators;
  List<Message> _messages;
  List<Workout> _workouts;
  bool _public;

  Group(this._groupName, this._members, this._admins, this._moderators,
      this._public) {
    _groupId = this._groupName +
        this.hashCode.toString() +
        Random().nextDouble().toString();
  }
}
