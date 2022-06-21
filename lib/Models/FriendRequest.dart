class FriendRequest {
  String _sender;
  String _reciever;

  FriendRequest(this._reciever, this._sender);
  FriendRequest.fromJson(Map<String, dynamic> json) {
    _sender = json["sender"];
    _reciever = json["reciever"];
  }

  Map<String, dynamic> toJson() {
    return {"sender": _sender, "reciever": _reciever};
  }

  String getSender() {
    return _sender;
  }

  String getReciever() {
    return _sender;
  }
}
