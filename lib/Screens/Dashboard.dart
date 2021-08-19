import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_share/SideBar/sideBarLayout.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[100],
          primaryColor: Colors.grey[100]),
      home: SideBarLayout(),
    );
  }
}
