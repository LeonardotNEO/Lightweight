import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifting_app/Models/User.dart';
import 'package:lifting_app/views/social/profile_view.dart';
import 'package:lifting_app/views/social/show_chat_view.dart';
import 'package:lifting_app/views/widgets/searchfield_widget.dart';

import '../../color_constants.dart';
import '../../main.dart';

class InfluencersView extends StatefulWidget {
  @override
  _InfluencersViewState createState() => _InfluencersViewState();
}

class _InfluencersViewState extends State<InfluencersView> {
  Stream<QuerySnapshot<Object>> users = FirebaseFirestore.instance
      .collection('users')
      .where("username", isNotEqualTo: MainPage.getCurrentUser().getUsername())
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: users,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return Column(
          children: [
            SearchfieldWidget(
                (value) => _updateUserList(value), "Influencer name...", []),
            /*FutureBuilder(
                future: _getUserFriendRequest(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                  return Column(
                    children: [..._friendRequests(snapshot.data)],
                  );
                }),*/
            ..._listOfInfluencers(context, snapshot.data.docs)
          ],
        );
      },
    );
  }

  void _updateUserList(String username) {
    setState(() {
      users = users = FirebaseFirestore.instance
          .collection('users')
          .where("username", isEqualTo: username)
          .where("username",
              isNotEqualTo: MainPage.getCurrentUser().getUsername())
          .snapshots();
    });
  }

  Future<List<User>> _getUserFriendRequest() async {
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    List<User> users = [];

    await ref.doc(MainPage.getCurrentUser().getId()).get().then((snapshot) {
      List<String> list = (snapshot.data as Map)["friendRequests"];
      list.forEach((id) {
        print(id);
      });
    });

    return users;
  }

  List<Widget> _friendRequests(List<User> users) {
    List<Widget> widgets = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Friend requests")],
      )
    ];

    MainPage.getCurrentUser().getFriendRequests().forEach((element) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: ColorConstants.color3,
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    element,
                    style: TextStyle(
                        color: ColorConstants.text1Dark, fontSize: 16),
                  ),
                  Container(
                    height: 35,
                    child: Row(
                      children: [
                        IconButton(
                            color: ColorConstants.text1Dark,
                            onPressed: null,
                            icon: Icon(Icons.message)),
                        IconButton(
                            color: ColorConstants.text1Dark,
                            onPressed: null,
                            icon: Icon(Icons.arrow_forward))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ));
    });

    return widgets;
  }

  List<Widget> _listOfInfluencers(
      BuildContext context, List<QueryDocumentSnapshot> data) {
    List<Widget> widgets = [];
    List<User> users = data.map((e) => User.fromJson(e.data())).toList();

    users.forEach((user) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: ColorConstants.color3,
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user.getUsername(),
                    style: TextStyle(
                        color: ColorConstants.text1Dark, fontSize: 16),
                  ),
                  Container(
                    height: 35,
                    child: Row(
                      children: [
                        MainPage.getCurrentUser().isFriends(user)
                            ? IconButton(
                                color: ColorConstants.text1Dark,
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowChatView(
                                            MainPage.getCurrentUser(), user))),
                                icon: Icon(Icons.message))
                            : IconButton(
                                color: ColorConstants.text1Dark,
                                onPressed: () => _sendFriendRequest(user),
                                icon: Icon(Icons.person_add)),
                        IconButton(
                            color: ColorConstants.text1Dark,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileView())),
                            icon: Icon(Icons.arrow_forward))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ));
    });

    return widgets;
  }

  void _sendFriendRequest(User user) {
    setState(() {
      MainPage.getCurrentUser().sendFriendRequest(user.getEmail());
    });
  }
}
