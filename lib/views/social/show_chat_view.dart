import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifting_app/Models/Message.dart';
import 'package:lifting_app/Models/User.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/views/social/profile_view.dart';
import 'package:lifting_app/views/widgets/back_button_as_logo.dart';

class ShowChatView extends StatefulWidget {
  User _sender;
  User _reciever;

  Stream<QuerySnapshot<Object>> stream1;
  Stream<QuerySnapshot<Object>> stream2;

  ShowChatView(this._sender, this._reciever) {
    stream1 = FirebaseFirestore.instance
        .collection("messages")
        .where("sender", isEqualTo: _sender.getEmail())
        .where("reciever", isEqualTo: _reciever.getEmail())
        .snapshots();

    stream2 = FirebaseFirestore.instance
        .collection("messages")
        .where("reciever", isEqualTo: _sender.getEmail())
        .where("sender", isEqualTo: _reciever.getEmail())
        .snapshots();
  }

  @override
  _ShowChatViewState createState() => _ShowChatViewState();
}

class _ShowChatViewState extends State<ShowChatView> {
  TextEditingController _sendMessageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: widget.stream1,
            builder: (context, snapshot1) {
              return StreamBuilder<QuerySnapshot>(
                stream: widget.stream2,
                builder: (context, snapshot2) {
                  // loading widgets when that is not fully loaded
                  if (!snapshot1.hasData) return LinearProgressIndicator();
                  if (!snapshot2.hasData) return LinearProgressIndicator();

                  List<Message> messages = [];

                  // add message object to messages
                  snapshot1.data.docs.forEach((element) {
                    messages.add(Message.fromJson(element.data()));
                  });

                  // add message object to messages
                  snapshot2.data.docs.forEach((element) {
                    messages.add(Message.fromJson(element.data()));
                  });

                  // sort messages by date
                  messages.sort(
                      (a, b) => a.getDateTime().compareTo(b.getDateTime()));

                  // do something when chat has been updated
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _afterBuild());

                  return _chat(messages);
                },
              );
            },
          ),
        ),
      ),
      bottomSheet: _sendMessageBottomBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      title: Text(
        widget._reciever.getUsername(),
        style: TextStyle(color: ColorConstants.text3),
      ),
      leading: BackButtonAsLogo(() => Navigator.pop(context)),
      backgroundColor: ColorConstants.text1Dark,
      actions: [
        IconButton(
            color: ColorConstants.text3,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileView()));
            },
            icon: Icon(
              Icons.person,
            ))
      ],
      bottom: PreferredSize(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget._reciever.getUsername(),
                    style: TextStyle(
                        color: ColorConstants.text3,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget._sender.getUsername(),
                    style: TextStyle(
                        color: ColorConstants.text3,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ]),
          ),
          preferredSize: Size.fromHeight(25)),
    );
  }

  void _afterBuild() {
    _scrollController.position
        .moveTo(_scrollController.position.maxScrollExtent);
  }

  Widget _chat(List<Message> messages) {
    bool _showDate = false;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...messages
            .map((message) => Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Column(
                    children: [
                      _showDate
                          ? Container(
                              padding: EdgeInsets.all(1),
                              alignment: widget._sender.getEmail() ==
                                      message.getSender()
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Text(
                                message.getDateTime().toString().split(".")[0],
                                style: TextStyle(fontSize: 10),
                              ),
                            )
                          : SizedBox.shrink(),
                      Container(
                        alignment:
                            widget._sender.getEmail() == message.getSender()
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: ColorConstants.color3,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            message.getMessage(),
                            style: TextStyle(color: ColorConstants.text1Dark),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
        Container(
          height: 60,
        )
      ],
    );
  }

  Widget _sendMessageBottomBar() {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(color: ColorConstants.color3),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 18, color: ColorConstants.text1Dark),
              controller: _sendMessageController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Message...",
                  hintStyle: TextStyle(color: ColorConstants.text2)),
            ),
          ),
          IconButton(
              onPressed: () {
                FirebaseFirestore.instance.collection("messages").add(
                    Message.writeUser(
                            widget._sender.getEmail(),
                            widget._reciever.getEmail(),
                            _sendMessageController.text)
                        .toJson());

                FocusManager.instance.primaryFocus?.unfocus();
                _sendMessageController.text = "";
              },
              icon: Icon(
                Icons.send,
                color: ColorConstants.text1Dark,
              ))
        ],
      ),
    );
  }
}
