import 'package:flutter/material.dart';
import 'package:lifting_app/Models/User.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/home/home_view.dart';

class LogIn extends StatefulWidget {
  static TextEditingController _email = TextEditingController();
  static TextEditingController _password = TextEditingController();

  @override
  _LogInState createState() => _LogInState();

  static Widget textField(TextEditingController controller, String hinttext,
      {bool obscureText}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorConstants.color3,
        ),
        padding: EdgeInsets.all(10),
        child: TextField(
          obscureText: obscureText != null ? true : false,
          style: TextStyle(color: ColorConstants.text1Dark, fontSize: 20),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hinttext,
              hintStyle: TextStyle(color: ColorConstants.text2)),
          controller: controller,
        ),
      ),
    );
  }

  static Widget button(IconData icon, Function onPressed, String text) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: OutlinedButton.icon(
        style: ButtonStyle(
            side: MaterialStateProperty.all(
                BorderSide(width: 1, color: ColorConstants.color3)),
            foregroundColor: MaterialStateProperty.all(ColorConstants.color3)),
        icon: Icon(icon),
        label: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}

class _LogInState extends State<LogIn> {
  List<String> _errors = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          LogIn.textField(LogIn._email, "Email..."),
          LogIn.textField(LogIn._password, "Password...", obscureText: true),
          LogIn.button(Icons.login, () => _logIn(), "Log in"),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._errors
                  .map((e) => Text(
                        "- $e",
                        style: TextStyle(color: ColorConstants.text3),
                      ))
                  .toList()
            ],
          )
        ],
      ),
    );
  }

  void _logIn() async {
    List<String> errors =
        await User.validateLogin(LogIn._email.text, LogIn._password.text);

    if (errors.isEmpty) {
      MainPage.save(MainPage.getCurrentUser(), false);
      MainPage.setCurrentUser(await MainPage.read(LogIn._email.text));
      MainPage.reBuild();
      MainPage.setCurrentPage(Home(), "Home");
    } else {
      setState(() {
        _errors = errors;
      });
    }
  }
}
