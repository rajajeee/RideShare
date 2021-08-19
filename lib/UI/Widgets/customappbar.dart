import 'package:flutter/material.dart';
import 'package:ride_share/Constants/constants.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        height: height / 9.5,
        width: width,
        padding: EdgeInsets.only(left: 15, top: 25),
        color: Colors.red[600],
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 28,
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop(Sign_in);
                }),
            Text(
              'Sign up',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
