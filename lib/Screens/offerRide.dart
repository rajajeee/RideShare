import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ride_share/Apis.dart';
import 'package:ride_share/UI/Widgets/custome_shape.dart';
import 'package:ride_share/UI/Widgets/responsive_ui.dart';
import 'package:ride_share/UI/Widgets/textformfield.dart';
import '../blocs/sideBarBloc.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:ride_share/Screens/myRide.dart';

class OfferRide extends StatefulWidget with NavigationStates {
  @override
  _OfferRideState createState() => _OfferRideState();
}

class _OfferRideState extends State<OfferRide> {
  DateTime _selectedDate;
  TextEditingController fromControl = new TextEditingController();
  TextEditingController whereCOntrol = new TextEditingController();
  TextEditingController dateControl = new TextEditingController();
  TextEditingController timeControl = new TextEditingController();
  TextEditingController priceControl = new TextEditingController();
  TextEditingController seatsControl = new TextEditingController();
  String validateDate;
  String validateTime;
  String validateSeats;
  String validatePrice;
  var startName, endName;
  List<String> startLatLng = new List();
  List<String> endLatLng = new List();
  var userID;
  getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID');
    });
  }

  _OfferRideState() {
    getUserID();
  }

  addNewRide(String date, String time, String price, String seats) async {
    Map data = {
      'startName': startName,
      'startLat': startLatLng[1],
      'startLng': startLatLng[0],
      'endName': endName,
      'endLat': endLatLng[1],
      'endLng': endLatLng[0],
      'rideDate': date,
      'rideTime': time,
      'ridePrice': price,
      'noOfSeats': seats,
      'userID': userID,
    };

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    var response = await http.post(Apis.OFFER_RIDE_API, body: data);
    if (response.body == 'success') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0.2,
            title: new Text(
                'Successfully Offered. You can Check your rides in My rides Section.'),
            shape: RoundedRectangleBorder(
              //  side: BorderSide(color: const Color(0xFF3366FF), width: 1.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  timeControl.clear();
                  dateControl.clear();
                  priceControl.clear();
                  seatsControl.clear();
                },
              ),
            ],
          );
        },
      );
    } else {
      print(response.body);
    }
  }

  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                clipShape(),
                form(),
                SizedBox(
                  height: _height / 35,
                ),
                button(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.red[600],
                    Colors.red[600],
                  ],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.red[600],
                    Colors.red[600],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            MapBoxPlaceSearchWidget(
              country: "pk",
              apiKey:
                  "sk.eyJ1IjoicmFqYWZhcmVlZCIsImEiOiJja2t4djhrN3AwNG01MnVwOXRvdnA4NGJqIn0.bBLihnwWZ9PzsBPZU479QQ",
              searchHint: 'Start Point',
              onSelected: (place) {
                setState(() {
                  startName = place.placeName;
                  for (var i in place.geometry.coordinates) {
                    startLatLng.add(i.toString());
                    print(startLatLng);
                    print(place.placeName);
                  }
                });
              },
              context: context,
            ),
            SizedBox(height: _height / 60.0),
            MapBoxPlaceSearchWidget(
              country: "pk",
              apiKey:
                  "sk.eyJ1IjoicmFqYWZhcmVlZCIsImEiOiJja2t4djhrN3AwNG01MnVwOXRvdnA4NGJqIn0.bBLihnwWZ9PzsBPZU479QQ",
              searchHint: 'Start Point',
              onSelected: (place) {
                setState(() {
                  endName = place.placeName;
                  for (var i in place.geometry.coordinates) {
                    endLatLng.add(i.toString());
                    print(endLatLng);
                  }
                });
              },
              context: context,
            ),
            SizedBox(height: _height / 60.0),
            dateTextFormField(),
            SizedBox(height: _height / 60.0),
            timeTextFormField(),
            SizedBox(height: _height / 60.0),
            priceTextFormField(),
            SizedBox(height: _height / 60.0),
            seatsTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget dateTextFormField() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: _large ? 12 : (_medium ? 10 : 8),
      child: TextFormField(
        controller: dateControl,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.date_range, color: Colors.red[600], size: 20),
          hintText: "Select date",
          errorText: validateDate,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.red[600],
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.grey,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      dateControl
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateControl.text.length, affinity: TextAffinity.upstream));
    }
  }

  Widget timeTextFormField() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: _large ? 12 : (_medium ? 10 : 8),
      child: TextFormField(
        controller: timeControl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.timer, color: Colors.red[600], size: 20),
          hintText: "Select TIme",
          errorText: validateTime,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
        readOnly: true,
        onTap: () async {
          TimeOfDay time = TimeOfDay.now();
          FocusScope.of(context).requestFocus(new FocusNode());
          TimeOfDay picked = await showTimePicker(
            context: context,
            initialTime: time,
            builder: (context, child) {
              return Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: Colors.red[600],
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.grey,
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child,
              );
            },
          );
          if (picked != null && picked != time) {
            timeControl.text = picked.format(context); // add this line.
            setState(() {
              time = picked;
            });
          }
        },
      ),
    );
  }

  Widget priceTextFormField() {
    return Container(
      height: _height/13,
      child: CustomTextField(
        textEditingController: priceControl,
        keyboardType: TextInputType.number,
        icon: Icons.payment,
        hint: "Fare",
        error: validatePrice,
        txtLength: 3,
      ),
    );
  }

  Widget seatsTextFormField() {
    return Container(
      height: _height/13,
      child: CustomTextField(
        textEditingController: seatsControl,
        keyboardType: TextInputType.number,
        icon: Icons.event_seat_sharp,
        hint: "No of Seats",
        error: validateSeats,
        txtLength: 1,
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        if (dateControl.text.length != 0 &&
            timeControl.text.length != 0 &&
            seatsControl.text.length == 1 &&
            priceControl.text.length != 0) {
          addNewRide(dateControl.text, timeControl.text, priceControl.text,
              seatsControl.text);
        } else if (dateControl.text.length == 0 ||
            timeControl.text.length == 0 ||
            seatsControl.text.length == 0 ||
            priceControl.text.length != 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Require to fill all details"),
                actions: <Widget>[
                  FlatButton(
                    child: new Text(
                      "OK",
                      style: TextStyle(color: Colors.red[600]),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _width / 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.red[600],
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'OFFER RIDE',
          style: TextStyle(fontSize: _large ? 16 : (_medium ? 14 : 12)),
        ),
      ),
    );
  }
}
