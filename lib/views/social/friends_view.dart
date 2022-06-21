import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifting_app/Models/FriendRequest.dart';
import 'package:lifting_app/Models/User.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/widgets/back_button_as_logo.dart';
import 'package:lifting_app/views/widgets/card_widget.dart';
import 'package:lifting_app/views/widgets/searchfield_widget.dart';

class FriendsView extends StatefulWidget {
  FriendsView();
  FriendsView.select();
  List<User> _users = [];

  @override
  _FriendsViewState createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.text1Dark,
        leading: BackButtonAsLogo(() => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SearchfieldWidget(
                (value) => _search(value), "Search for friends...", []),
            ...widget._users
                .map((user) => CardWidget(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user.getUsername(),
                          style: TextStyle(color: ColorConstants.text1Dark),
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("friendRequests")
                              .doc(MainPage.getCurrentUser().getEmail() +
                                  ":" +
                                  user.getEmail())
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return SizedBox.shrink();

                            if (!snapshot.data.exists) {
                              return GestureDetector(
                                  onTap: () => _sendFriendRequest(user),
                                  child: Icon(
                                    Icons.person_add,
                                    color: ColorConstants.text1Dark,
                                  ));
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        )
                      ],
                    ),
                    () => Navigator.pop(context, user)))
                .toList()
          ],
        ),
      ),
    );
  }

  void _sendFriendRequest(User user) {
    FirebaseFirestore.instance
        .collection("friendRequests")
        .doc(MainPage.getCurrentUser().getEmail() + ":" + user.getEmail())
        .set(
            FriendRequest(user.getEmail(), MainPage.getCurrentUser().getEmail())
                .toJson());
  }

  void _search(String value) async {
    List<User> userSearch = [];

    if (value.length != 0) {
      var result = await FirebaseFirestore.instance.collection("users").get();
      result.docs.forEach((element) {
        User user = User.fromJson(element.data());
        if (user.getUsername().contains(value) &&
            user.getUsername() != MainPage.getCurrentUser().getUsername()) {
          userSearch.add(user);
        }
      });
    } else {
      widget._users = [];
    }

    setState(() {
      widget._users = userSearch;
    });
  }
}
