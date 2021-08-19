import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:http/io_client.dart';
import 'package:ride_share/Screens/ViewRide.dart';
import 'package:ride_share/UI/Widgets/custome_shape.dart';
import 'package:ride_share/UI/Widgets/responsive_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Apis.dart';
import '../Screens/riderTrack.dart';

class BookRides extends StatefulWidget {
  @override
  _BookRidesState createState() => _BookRidesState();
}

// ignore: camel_case_types
class bookingResult{
  String bookingID;
  String firstName;
  String lastName;
  String contactNumber;
  String rideID;
  String status;
  String startName;
  String startLat;
  String startLng;
  String endName;
  String endLat;
  String endLng;

  bookingResult(this.bookingID,this.firstName,this.lastName,this.contactNumber,this.rideID,this.status,this.startName,this.startLat,this.startLng,this.endName,this.endLat,this.endLng);
}

class _BookRidesState extends State<BookRides> {
  List<bookingResult> bookingList = new List();


  _BookRidesState(){
    getBookings();
  }
  getBookings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('userID');

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    Map d = {'userID': id};
    // ignore: avoid_init_to_null
    var jsonData = null;
    var response = await http.post(Apis.BOOKED_RIDES, body: d);
    print(response.body);
    if (response.body == 'no') {

    } else {
      jsonData = json.decode(response.body);
      for (var a in jsonData['booked']) {
        setState(() {
          bookingList.add(new bookingResult(
              a['booking_id'].toString(), a['first_name'], a['last_name'],
              a['phone'],
              a['ride_id'].toString(), a['status'] == '1' ? 'Accepted' : 'Denied',
              a['start_name'],
              a['start_lat'],a['start_lng'],
              a['end_name'],
              a['end_lat'],a['end_lng']));
        });
      }
    }
  }
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;


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
                color: Colors.red[600],
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
    color: Colors.red[600],
              ),
            ),
          ),
      ],
    );
  }

  bookedRideCard(BuildContext context, int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(15.0,15.0,15.0,0.0),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.red[600], width: 2.5),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              width: 400,
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 6.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 13.0, 8.0, 7.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                         ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Icon(
                            Icons.person,
                            size: 28.0,
                              color: Colors.red[600],
                          ),
                        ),
                            Flexible(
                              child: Text(
                                'Your Ride With '+
                                bookingList[index].firstName + " " +
                                    bookingList[index].lastName + " has been Booked",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  borderSide: BorderSide(
                    color: Colors.red[600],
                  ),
                  textColor: Colors.red[600],
                  onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewRide(
                    startPoint: bookingList[index].startName,
                    startLatitude: bookingList[index].startLat,
                    startLongtitude: bookingList[index].startLng,
                    endPoint: bookingList[index].endName,
                    endLatitude: bookingList[index].endLat,
                    endLongtitude: bookingList[index].endLng,
                  )));
                },child: Text('View Route'),),
                OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  borderSide: BorderSide(
                    color: Colors.red[600],
                  ),
                  textColor: Colors.red[600],
                  onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => TrackRider(ridei: bookingList[index].rideID)));
                  },
                  child: Text('Track Rider'),),
                OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  borderSide: BorderSide(
                    color: Colors.red[600],
                  ),
                  textColor: Colors.red[600],
                  onPressed: (){
                  FlutterOpenWhatsapp.sendSingleMessage(bookingList[index].contactNumber, "Hello "+bookingList[index].firstName+" "+bookingList[index].lastName);
                  print(bookingList[index].contactNumber);
                  },
                  child: Text('Contact'),)
              ],
            ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          thickness: 0.5,
          color: Colors.black,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                    itemCount: bookingList.length,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => bookedRideCard(context, index)),
              ],
            ),
          ),
        ));
  }
}
