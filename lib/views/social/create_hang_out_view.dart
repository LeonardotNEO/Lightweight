import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/views/home/logIn_view.dart';
import 'package:lifting_app/views/social/friends_view.dart';
import 'package:lifting_app/views/widgets/back_button_as_logo.dart';
import 'package:lifting_app/views/widgets/card_widget.dart';
import 'package:lifting_app/views/widgets/standard_toolbar_backButton.dart';

class CreateHangOutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _hangOutName = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.text1Dark,
        leading: BackButtonAsLogo(() => Navigator.pop(context)),
        elevation: 0,
        actions: [IconButton(onPressed: null, icon: Icon(Icons.check))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            LogIn.textField(_hangOutName, "Hang out name..."),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CardWidget.withHeader(
                  Column(),
                  null,
                  "Members",
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FriendsView.select())),
                    child: Icon(
                      Icons.person_add,
                      color: ColorConstants.text1Dark,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
