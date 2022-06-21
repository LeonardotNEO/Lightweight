import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifting_app/views/home/home_view.dart';
import 'package:http/http.dart' as http;

import 'package:lifting_app/views/widgets/bottom_navbar_widget.dart';

import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/views/widgets/standard_toolbar.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'Models/User.dart';

SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp();
  sharedPrefs.clear();

  if (MainPage.readCurrentUser() == null) {
    User guest = User.guest();
    MainPage.setCurrentUser(guest);
  } else {
    MainPage._currentUser = await MainPage.read(MainPage.readCurrentUser());
  }

  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  static User _currentUser;
  static Widget _currentPage;
  static ScrollController _scrollController = ScrollController();
  static String _headerText;
  static Widget _topBar;
  static _MainPageState _mainState = _MainPageState();

  static void setCurrentPage(
    Widget page,
    String headerText, {
    double positionToJumpTo,
    Widget topBar,
  }) {
    _mainState.setState(() {
      _currentPage = page;
      _headerText = headerText;

      if (positionToJumpTo != null) {
        _scrollController.jumpTo(positionToJumpTo);
      }

      topBar == null ? _topBar = StandardToolbar(null, null) : _topBar = topBar;
    });
  }

  static void reBuild() {
    _mainState.setState(() {});
  }

  static void setTopBar(Widget topbar) {
    _mainState.setState(() {
      _topBar = topbar;
    });
  }

  static User getCurrentUser() {
    return _currentUser;
  }

  static String getHeaderText() {
    return _headerText;
  }

  static Widget getCurrentPage() {
    return _currentPage;
  }

  static void setCurrentUser(User user) async {
    _currentUser = user;
    MainPage.save(user, false);
    sharedPrefs.setString("currentUser", user.getEmail());

    // set them and darkmode
    ColorConstants.setTheme(
        ColorConstants.getColors()[MainPage.getCurrentUser().getTheme()],
        dark: MainPage.getCurrentUser().getdarkMode());
  }

  static _MainPageState getMainState() {
    return _mainState;
  }

  static String readCurrentUser() {
    print(sharedPrefs.getString("currentUser"));
    return sharedPrefs.getString("currentUser");
  }

  static save(User user, bool register) async {
    if (user.getEmail() == "Guest@email.com") {
      sharedPrefs.setString(user.getEmail(), json.encode(user.toJson()));
    } else {
      var collection = FirebaseFirestore.instance.collection("users");

      register
          ? collection.doc(user.getEmail()).update(user.toJson())
          : collection.doc(user.getEmail()).set(user.toJson());
    }
  }

  static Future<User> read(String email) async {
    if (email == "Guest@email.com") {
      return User.fromJson(json.decode(sharedPrefs.getString(email)));
    } else {
      var result =
          await FirebaseFirestore.instance.collection("users").doc(email).get();
      return User.fromJson(result.data());
    }
  }

  @override
  _MainPageState createState() => _mainState;
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    // set standard toolbar at the top
    MainPage._topBar = StandardToolbar(null, null);

    // set them and darkmode
    ColorConstants.setTheme(
        ColorConstants.getColors()[MainPage.getCurrentUser().getTheme()],
        dark: MainPage.getCurrentUser().getdarkMode());

    // set startpage
    MainPage.setCurrentPage(
      Home(),
      "Home",
    );

    print(MainPage._currentUser);
    print(MainPage._currentUser.getEmail());
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      MainPage.save(MainPage._currentUser, false);
      MainPage.setCurrentUser(MainPage._currentUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(sharedPrefs.getKeys());

    return MaterialApp(
      theme: ThemeData(canvasColor: ColorConstants.color1),
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
              bottomSheet: BottomNavbar(),
              body: CustomScrollView(
                  controller: MainPage._scrollController,
                  slivers: [
                    MainPage._topBar,
                    SliverToBoxAdapter(child: MainPage._currentPage),
                  ]))),
    );
  }

  void _getfromDatabase() async {
    final repsonse = await http.post(
        Uri.parse(
            'https://flutter-lifting-app-default-rtdb.europe-west1.firebasedatabase.app/userprofile.json'),
        body: json.encode(MainPage.getCurrentUser().toJson()));

    final response2 = await http.get(Uri.parse(
        'https://flutter-lifting-app-default-rtdb.europe-west1.firebasedatabase.app/userprofile.json'));
    final extractedData = json.decode(response2.body) as Map<String, dynamic>;

    List<User> users = [];

    extractedData.forEach((key, value) {
      users.add(User.fromJson(value));
    });

    users.forEach((element) {
      if (element.getEmail() == "Guest@email.com") {}
    });
  }
}
