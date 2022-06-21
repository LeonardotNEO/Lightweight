import 'package:flutter/material.dart';
import 'package:lifting_app/Models/User.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/home/home_view.dart';
import 'package:lifting_app/views/widgets/standard_toolbar.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _colorPicker(),
          _darkModeSwitch(),
          MainPage.getCurrentUser().getEmail() == "Guest@email.com"
              ? SizedBox.shrink()
              : _logOutButton(),
        ],
      ),
    );
  }

  Widget _logOutButton() {
    return OutlinedButton.icon(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(ColorConstants.color1),
          backgroundColor: MaterialStateProperty.all(ColorConstants.color3),
          side: MaterialStateProperty.all(
              BorderSide(color: ColorConstants.color1))),
      onPressed: _logOut,
      label: Text("Log out"),
      icon: Icon(Icons.logout),
    );
  }

  Widget _darkModeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Darkmode: ",
          style: TextStyle(color: ColorConstants.text3),
        ),
        Switch(
            activeColor: ColorConstants.color3,
            value: MainPage.getCurrentUser().getdarkMode(),
            onChanged: (bool newValue) {
              setState(() {
                _setDarkMode(newValue);
              });
            }),
      ],
    );
  }

  Widget _colorPicker() {
    List<Color> colors = ColorConstants.getColors();

    return Container(
      width: double.infinity,
      height: _index == 0 ? 445 : 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorConstants.color3,
      ),
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Themes",
                style: TextStyle(
                    color: ColorConstants.text1Dark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
                width: 30,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _index == 0 ? _index = 1 : _index = 0;
                      });
                    },
                    child: Icon(
                      _index == 0 ? Icons.arrow_downward : Icons.arrow_upward,
                      color: ColorConstants.text1Dark,
                    )),
              )
            ],
          ),
          _index == 0
              ? Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Darkmode will be adjusted automatically according to theme brightness. You can allways override this by changing darkmode manually.",
                        style: TextStyle(
                            color: ColorConstants.text1Dark,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 7,
                          children: List.generate(colors.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  colors[index].computeLuminance() > 0.3
                                      ? _setDarkMode(true)
                                      : _setDarkMode(false);
                                  MainPage.getCurrentUser().setTheme(index);
                                  ColorConstants.setTheme(colors[index]);
                                  MainPage.reBuild();
                                  MainPage.setTopBar(
                                      StandardToolbar(null, null));
                                });
                              },
                              child: Container(
                                color: colors[index],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }

  void _setDarkMode(bool trueFalse) {
    setState(() {
      MainPage.getCurrentUser().setDarkMode(trueFalse);

      trueFalse
          ? ColorConstants.setTheme(ColorConstants.color3, dark: true)
          : ColorConstants.setTheme(ColorConstants.color3, dark: false);

      MainPage.reBuild();
      MainPage.setTopBar(StandardToolbar(null, null));
    });
  }

  void _logOut() async {
    MainPage.save(MainPage.getCurrentUser(), false);
    MainPage.setCurrentUser(await MainPage.read("Guest@email.com"));
    MainPage.setCurrentPage(Home(), "Home");
  }
}
