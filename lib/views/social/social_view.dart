import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/views/social/hang_out_view.dart';
import 'package:lifting_app/views/social/influencers_view.dart';

class SocialView extends StatefulWidget {
  @override
  _SocialViewState createState() => _SocialViewState();
}

class _SocialViewState extends State<SocialView> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _appbar(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IndexedStack(
            index: _pageIndex,
            children: [_workouts(), InfluencersView(), HangOutView()],
          ),
        ),
      ],
    );
  }

  Widget _workouts() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return Column(
          children: [],
        );
      },
    );
  }

  Widget _appbar() {
    Widget _button(String title, IconData icon, int setPageIndex) {
      return Expanded(
        child: TextButton.icon(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                    _pageIndex == setPageIndex
                        ? ColorConstants.color3
                        : ColorConstants.text3)),
            label: Text(title),
            onPressed: () {
              setState(() {
                _pageIndex = setPageIndex;
              });
            },
            icon: Icon(
              icon,
            )),
      );
    }

    Widget _buttonDivider() {
      return Container(
        width: 1,
        height: 35,
        color: ColorConstants.color3,
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: ColorConstants.color1,
      toolbarHeight: 25,
      elevation: 0,
      flexibleSpace: Row(children: [
        _button("Workouts", Icons.fitness_center, 0),
        _buttonDivider(),
        _button("Influencers", Icons.person, 1),
        _buttonDivider(),
        _button("Hang out", Icons.groups, 2),
      ]),
    );
  }
}
