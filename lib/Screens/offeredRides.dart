import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:ride_share/Screens/myRide.dart';
import 'package:ride_share/UI/Widgets/custome_shape.dart';
import 'package:ride_share/UI/Widgets/responsive_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import '../Apis.dart';
import 'package:random_string/random_string.dart';
import '../Utils/BackgroundLocation.dart';


class OfferedRides extends StatefulWidget {
  @override
  _OfferedRidesState createState() => _OfferedRidesState();
}
// ignore: camel_case_types
class userRideDetails {
  String id;
  String startPoint;
  String endPoint;
  String date;
  String time;
  String price;
  String seats;
  String userName;
  String phone;
  String image;
  String status;

  userRideDetails(this.id, this.startPoint, this.endPoint, this.date, this.time,
      this.price, this.seats, this.userName, this.phone, this.image,this.status);
}
class _OfferedRidesState extends State<OfferedRides> {
  var email;
  List<userRideDetails> userRide = new List();
  bgServices _services = new bgServices();


  _OfferedRidesState() {
    fireBaseInit();
    getUserID();
  }
  void fireBaseInit() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

  }

  var userID;
  getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID');
      email = prefs.getString('userEmail');
      getRides(userID);
    });
  }
  getRides(String user) async {
    Map d = {'userID': user};
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    // ignore: avoid_init_to_null
    var jsonData = null;
    var response = await http.post(Apis.FETCH_USER_RIDES, body: d);
    if (response.body == 'no') {
    } else {
      jsonData = json.decode(response.body);
      for (var a in jsonData['userRide']) {
        setState(() {
          userRide.add(new userRideDetails(
              a['id'],
              a['start_name'],
              a['end_name'],
              a['date'],
              a['time'],
              a['price'],
              a['seats'],
              a['first_name'] + ' ' + a['last_name'],
              a['phone'],
              a['image'],
              a['status']));
        });
      }
    }
  }


  rideStatus(String rideID,String rideStatus) async {
    Map d ={

      'rideID':rideID,
      'userID':userID,
      'status':rideStatus
    };
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    // ignore: avoid_init_to_null
    var response = await http.post(Apis.CANCEL_RIDE, body: d);
    if (response.body == 'success') {
      setState(() {
        if(rideStatus == '3'){

        }
        else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MyRides()));
        }
        });


    } else {
      print(response.body);
    }


  }

  addNode(var rideId,var node) async {
    Map d ={
      'rideID':rideId,
      'nodeName':node
    };
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    // ignore: avoid_init_to_null
    var response = await http.post(Apis.ADD_TRACKING, body: d);
    print('Node Response '+response.body);
    if (response.body == 'success') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('node', node);
//      _services.addDbNode(node);
      setState(() {


        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MyRides()));
      });

    } else {
      print(response.body);
    }

  }


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
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // clipShape(),
              ListView.builder(
                  itemCount: userRide.length,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => card(context, index)),
            ],
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
                  ? _height / 19
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

  Widget card(BuildContext ctx, int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.red[600], width: 2.5),
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10.0,
            shadowColor: Colors.grey,
            color: Colors.grey[200],
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.perm_identity,
                      color: Colors.white,
                    ),
                    radius: 25,
                  ),
                  title: Text(userRide[index].userName),
                  subtitle: Text(
                    userRide[index].phone,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Divider(
                  thickness: 0.9,
                  color: Colors.red[600],
                ),
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 18.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.place,
                              color: Colors.red[600],
                              size: 24.0,
                            ),
                            Flexible(
                              child: Text(userRide[index].startPoint,
                                  maxLines: 3,
                                  style: TextStyle(color: Colors.red[600], fontSize: 14.0,)),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 18.0, top: 6.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.place,
                              color: Colors.red[600],
                              size: 24.0,
                            ),
                            Flexible(
                              child: Text(userRide[index].endPoint,
                                  maxLines: 30,
                                  style: TextStyle(color: Colors.red[600], fontSize: 14.0,)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Date: ' + userRide[index].date,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Time: ' + userRide[index].time,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Fair: ' + userRide[index].price,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Seats: ' + userRide[index].seats,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    )),
                Divider(
                  thickness: 0.9,
                  color: Colors.red[600],
                ),

                userRide[index].status == '2' ?
                SizedBox(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Ride Canceled',
                          style: TextStyle(fontSize: 16.0, color: Colors.red),
                        )
                    )
                )
                : userRide[index].status =='1' ?
                buttons(userRide[index].id)
                    : userRide[index].status =='3' ?
            completeRide(userRide[index].id,'4')
                    :
                SizedBox(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Ride Ended',
                          style: TextStyle(fontSize: 16.0, color: Colors.red),
                        )
                    )
                )


              ],
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

  Widget buttons(var value){
    return Column(
      children: [
        SizedBox(
          width: 200.0,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.red[600],
              textColor: Colors.red[600],
              onPressed: () {
                rideStatus(value,'3');
                _services.checkPermission();
                _services.startBackgroundService();
                var node = email.split('@');

          addNode(value, node[0]+randomAlpha(10).toString());



              },
              child: Text(
                'Start Ride',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 200.0,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.red[600],
              textColor: Colors.red[600],
              onPressed: () {
                rideStatus(value,'2');

              },
              child: Text(
                'Cancel Ride',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget completeRide(var dt,var s){
    return Column(
      children: [
        SizedBox(
            child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Ride Is Active',
                  style: TextStyle(fontSize: 16.0, color: Colors.green),
                )
            )
        )  ,
        SizedBox(
          width: 200.0,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.red[600],
              textColor: Colors.red[600],
              onPressed: () {
                rideStatus(dt,s);
               _services.stopService();
               removeNode();

              },
              child: Text(
                'End Ride',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
  void removeNode() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('node');
  }
}
