import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String _sender;
  String _reciever;
  String _groupId;
  DateTime _dateTime;
  String _message;

  Message.writeUser(this._sender, this._reciever, this._message);
  Message.writeGroup(this._sender, this._groupId, this._message);

  Message.fromJson(Map<String, dynamic> json) {
    _sender = json["sender"];
    _reciever = json["reciever"];
    Timestamp timestamp =
        json["dateTime"] != null ? json["dateTime"] : Timestamp.now();
    _dateTime = DateTime.parse(timestamp.toDate().toIso8601String());
    _message = json["message"];
    _groupId = json["groupId"];
  }

  Map<String, dynamic> toJson() {
    return {
      "sender": _sender,
      "reciever": _reciever,
      "dateTime": FieldValue.serverTimestamp(),
      "message": _message,
      "groupId": _groupId,
    };
  }

  String getSender() {
    return _sender;
  }

  String getReciever() {
    return _reciever;
  }

  DateTime getDateTime() {
    return _dateTime;
  }

  String getMessage() {
    return _message;
  }
}
