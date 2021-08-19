import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Apis.dart';

class RideRequestResult extends StatefulWidget {
  @override
  _RideRequestResultState createState() => _RideRequestResultState();
}
// ignore: camel_case_types
class notificationResult{
  String bookingID;
  String firstName;
  String lastName;
  String rideID;
  String status;
  notificationResult(this.bookingID,this.firstName,this.lastName,this.rideID,this.status);
}
class _RideRequestResultState extends State<RideRequestResult> {
  List<notificationResult> notificationList = new List();

  _RideRequestResultState(){
    getNotifications();
  }

  getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('userID');

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    Map d = {'userID': id};
    // ignore: avoid_init_to_null
    var jsonData = null;
    var response = await http.post(Apis.RIDE_REQUEST_RESULT, body: d);
    print(response.body);
    if (response.body == 'no') {

    } else {

      jsonData = json.decode(response.body);
      for (var a in jsonData['notifications']) {
        setState(() {
          notificationList.add(new notificationResult(
              a['booking_id'].toString(), a['first_name'], a['last_name'],
              a['ride_id'].toString(), (a['status'] == '1' ) ? 'Accepted' : (a['status'] == '2' ) ? 'Denied' : 'Cancelled'));
        });
      }
    }
  }


  notficationCard(BuildContext context, int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
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
                  .height / 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 13.0, 8.0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Icon(
                              Icons.person,
                              size: 28.0,
                              color: Colors.red[600],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                            child:
                        Flexible(
                          child: Text(
                            notificationList[index].status == 'Cancelled' ?  notificationList[index].firstName + " " +
                            notificationList[index].lastName + " has Cancelled The Ride" :
                            notificationList[index].firstName + " " +
                                notificationList[index].lastName + " has " +notificationList[index].status +
                                " your ride Request",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                        ),
                      ],
                    ),
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
}
