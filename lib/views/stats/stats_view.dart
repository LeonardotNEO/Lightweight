import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/stats/graphs_view.dart';
import 'package:lifting_app/views/stats/history_view.dart';
import 'package:lifting_app/views/stats/progression_view.dart';
import 'package:lifting_app/views/widgets/card_2_widget.dart';
import 'package:lifting_app/views/widgets/standard_toolbar.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Card2(
                  "History",
                  () => MainPage.setCurrentPage(HistoryPage(), "History",
                      topBar: StandardToolbar(
                          IconButton(
                              color: ColorConstants.color3,
                              onPressed: () =>
                                  MainPage.setCurrentPage(Stats(), "Stats"),
                              icon: Icon(Icons.arrow_back)),
                          null)),
                  Icons.history),
              Card2(
                  "Progression",
                  () =>
                      MainPage.setCurrentPage(ProgressionPage(), "Progression"),
                  Icons.analytics),
              Card2(
                  "Nutrition",
                  () => MainPage.setCurrentPage(Container(), "Nutrition"),
                  Icons.restaurant),
              Card2(
                  "Measurements",
                  () => MainPage.setCurrentPage(Container(), "Measurements"),
                  Icons.straighten),
              Card2(
                  "Calculators",
                  () => MainPage.setCurrentPage(GraphsPage(), "Calculators"),
                  Icons.calculate_outlined),
              Card2(
                  "Sleep",
                  () => MainPage.setCurrentPage(GraphsPage(), "Sleep"),
                  Icons.nightlight_outlined),
              Container(
                height: 140,
              )
            ],
          ),
        )
      ],
    );
  }
}
