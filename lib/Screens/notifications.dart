import 'package:flutter/material.dart';
import 'package:ride_share/Screens/RideRequest.dart';
import 'package:ride_share/Screens/RideRequestResult.dart';
import '../blocs/sideBarBloc.dart';


// ignore: camel_case_types

class Notifications extends StatefulWidget with NavigationStates {
  @override
  _OfferRideState createState() => _OfferRideState();
}

class _OfferRideState extends State<Notifications> {



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: DefaultTabController(
    length: 2,
    child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[600],
    bottom: TabBar(
    tabs: [
    Tab(icon: Icon(Icons.car_rental), text: "Your Rides"),
    Tab(icon: Icon(Icons.book_online), text: "Your Requests")
    ],
    ),
    ),
    body: TabBarView(
    children: [
    RideRequest(),
    RideRequestResult(),
    ],
    ),
    )
    )
    );
  }
}
