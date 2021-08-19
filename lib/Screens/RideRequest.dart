import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Apis.dart';
import 'notifications.dart';
import '../UI/Widgets/custome_shape.dart';
import '../UI/Widgets/responsive_ui.dart';

class RideRequest extends StatefulWidget {
  @override
  _RideRequestState createState() => _RideRequestState();
}
// ignore: camel_case_types
class notifications{
  String bookingID;
  String firstName;
  String lastName;
  String rideID;
  String startPoint;
  String startLat;
  String startLng;
  String endPoint;
  String endLat;
  String endLng;
  notifications(this.bookingID,this.firstName,this.lastName,this.rideID,this.startPoint,this.startLat,this.startLng,this.endPoint,this.endLat,this.endLng);
}
class _RideRequestState extends State<RideRequest> {
  List<notifications> notificationList = new List();


  _RideRequestState(){
    getNotifications();
  }

  getNotifications() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('userID');

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    Map d ={'userID':id};
    // ignore: avoid_init_to_null
    var jsonData = null;
    var response = await http.post(Apis.NOTIFICATIONS, body: d);
    print(response.body);
    if (response.body == 'no') {
    } else {
      jsonData = json.decode(response.body);
      for(var a in jsonData['notifications'])
      {
        setState(() {
          notificationList.add(new notifications(
              a['booking_id'].toString(),
              a['first_name'],
              a['last_name'],
              a['ride_id'].toString(),
              a['pickup_name'],
              a['pickup_lat'],
              a['pickup_lng'],
            a['drop_name'],
            a['drop_lat'],
            a['drop_lng'],
          ));
        });
      }
    }


  }

  notificationStatus(String bookingID,String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('userID');

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    Map d ={'bookingID':bookingID,'rideBy':id,'status':status};
    var response = await http.post(Apis.NOTIFICATION_STATUS, body: d);
print(response.body);

    if(response.body == 'success')
    {
      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>Notifications()));
      });
      print('success');
    }
    else{
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                    itemCount: notificationList.length,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => notficationCard(context, index)),
              ],
            ),
          ),
        ));
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

  notficationCard(BuildContext context, int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.red[600], width: 2.5),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              width: _width,
              height: MediaQuery.of(context).size.height / 3.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 13.0, 8.0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Icon(
                              Icons.person,
                              size: 24.0,
                              color: Colors.red[600],
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'Ride Request From '+notificationList[index].firstName + " "+notificationList[index].lastName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10.0),
                  child:
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
              Flexible(child:
                        Text(
                          'Pick Up Point :  '+notificationList[index].startPoint,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              )
                      ],
                    ),
                    ),
                      Padding(padding: EdgeInsets.all(10.0),
                child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                Flexible(child:
                      Text(
                        'Drop Off Point :  '+notificationList[index].endPoint,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                )

                    ],
                  ),
                        ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlineButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        borderSide: BorderSide(
                          color: Colors.red[600],
                        ),
                        textColor: Colors.red[600],
                        onPressed: () {
                          notificationStatus(notificationList[index].bookingID.toString(), '1');
                        },
                        child: Text(
                          'Accept',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      OutlineButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        borderSide: BorderSide(
                          color: Colors.red[600],
                        ),
                        textColor: Colors.red[600],
                        onPressed: () {
                          notificationStatus(notificationList[index].bookingID, '2');
                        },
                        child: Text(
                          'Deny',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
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
}
