import 'package:flutter/material.dart';
import 'package:lifting_app/Models/User.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/home/home_view.dart';
import 'package:lifting_app/views/home/logIn_view.dart';

class Register extends StatefulWidget {
  Register();

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _userNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _repeatPasswordController = TextEditingController();

  List<String> _errors = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          LogIn.textField(_userNameController, "Username..."),
          LogIn.textField(_emailController, "Email..."),
          LogIn.textField(_passwordController, "Password...",
              obscureText: true),
          LogIn.textField(_repeatPasswordController, "Repeat password...",
              obscureText: true),
          LogIn.button(
              Icons.app_registration, () => _registerUser(), "Register"),
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

  void _registerUser() async {
    List<String> errors = await User.validateNewUser(
        _userNameController.text,
        _emailController.text,
        _passwordController.text,
        _repeatPasswordController.text);

    if (errors.isNotEmpty) {
      setState(() {
        _errors = errors;
      });
    } else {
      User newUser = User(_userNameController.text, _passwordController.text,
          _emailController.text);

      Future.delayed(Duration(seconds: 1), () {
        MainPage.save(newUser, true);
        MainPage.setCurrentUser(newUser);
        MainPage.reBuild();
        MainPage.setCurrentPage(Home(), "Home");
      });
    }
  }
}
