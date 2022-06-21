import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../color_constants.dart';
import 'create_hang_out_view.dart';

class HangOutView extends StatefulWidget {
  @override
  _HangOutViewState createState() => _HangOutViewState();
}

class _HangOutViewState extends State<HangOutView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return Column(
          children: [
            Container(
              width: double.infinity,
              child: TextButton.icon(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(ColorConstants.text3)),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateHangOutView()));

                    setState(() {});
                  },
                  icon: Icon(Icons.add),
                  label: Text("create group")),
            ),
          ],
        );
      },
    );
  }
}
