
import 'package:flutter/material.dart';

import 'package:ride_share/Screens/bookedRides.dart';
import 'package:ride_share/Screens/offeredRides.dart';
import '../blocs/sideBarBloc.dart';


class MyRidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyRidePage(),
    );
  }
}

class MyRides extends StatefulWidget with NavigationStates {
  @override
  _MyRidesState createState() => _MyRidesState();
}



class _MyRidesState extends State<MyRides> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red[500],
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.car_rental), text: "Offered"),
                    Tab(icon: Icon(Icons.book_online), text: "Booked")
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  OfferedRides(),
                  BookRides(),
                ],
              ),
            )
        )
    );

  }
}
