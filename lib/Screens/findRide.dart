import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:ride_share/UI/Widgets/custome_shape.dart';
import 'package:ride_share/UI/Widgets/responsive_ui.dart';
import 'package:ride_share/UI/Widgets/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/sideBarBloc.dart';
import 'dart:convert';
import 'pickUpMap.dart';
import 'package:ride_share/Apis.dart';


// ignore: camel_case_types
class findrides {
  String id;
  // ignore: non_constant_identifier_names
  String user_id;
  String startPoint;
  String endPoint;
  String date;
  String time;
  String price;
  String seats;
  String userName;
  String phone;
  String image;
  String sLat;
  String sLng;
  String eLat;
  String eLng;
  findrides(this.id,this.user_id,this.startPoint, this.endPoint, this.date, this.time,
      this.price, this.seats, this.userName, this.phone, this.image,this.sLat,this.sLng,this.eLat,this.eLng);
}
class FindRide extends StatefulWidget with NavigationStates {

  @override
  _FindRideState createState() => _FindRideState();
}

class _FindRideState extends State<FindRide> {
    List<findrides> findRide = new List();
    bool found;
    var message = '';


  findride(String from , String where) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getString('userID');
  if(from == '' && where == '')
    {
      setState(() {
        found = false;
        message = 'Nothing Found';

      });
    }
  else {
    Map d = {'from': from, 'where': where, 'user': id};
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    // ignore: avoid_init_to_null
    var jsonData = null;
    var response = await http.post(Apis.FIND_RIDES, body: d);
    print(id);
    print('from $from');
    print('where $where');
    print(response.body);
    if (response.body == 'no') {
      setState(() {
        found = false;
        message = 'Nothing Found';
      });
    } else {
      setState(() {
        found = true;
      });
      jsonData = json.decode(response.body);
      for (var a in jsonData['ride']) {
        setState(() {
          findRide.add(new findrides(
              a['id'].toString(),
              a['user_id'].toString(),
              a['start_name'],
              a['end_name'],
              a['date'],
              a['time'],
              a['price'],
              a['seats'],
              a['first_name'] + ' ' + a['last_name'],
              a['phone'],
              a['image'],
              a['start_lat'],
              a['start_lng'],
              a['end_lat'],
              a['end_lng']
          ));
        });
        print(a);
      }
    }
  }
  }

  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController fromController = TextEditingController();
  TextEditingController whereController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();

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
              clipShape(),
              form(),
              SizedBox(height: _height / 44),
              button(),
              found != true ? Text(message) :
              ListView.builder(
                  itemCount: findRide.length,
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

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 25.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            fromTextFormField(),
            SizedBox(height: _height / 40.0),
            whereTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget fromTextFormField() {
    return CustomTextField(
      textEditingController: fromController,
      icon: Icons.directions_car_outlined,
      hint: "From",

    );
  }

  Widget whereTextFormField() {
    return CustomTextField(
      textEditingController: whereController,
      icon: Icons.directions_car_outlined,
      hint: "Where to",
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        setState(() {
          findRide.clear();
        });
        findride(fromController.text,whereController.text);
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
          alignment: Alignment.center,
          width: _width/1.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.red[600],
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'FIND RIDE',
            style: TextStyle(fontSize: _large ? 16 : (_medium ? 14 : 12)),
          )),
    );
  }

  Widget card(BuildContext ctx, int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0,0.0),
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
                  title: Text(findRide[index].userName),
                  subtitle: Text(
                    findRide[index].phone,
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
                            Flexible(child:  Text(findRide[index].startPoint,
                                style: TextStyle(
                                    color: Colors.red[600], fontSize: 14.0)), ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 18.0, top: 0.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.place,
                              color: Colors.red[600],
                              size: 24.0,
                            ),
                            Flexible(
                              child: Text(findRide[index].endPoint,
                                  style: TextStyle(
                                      color: Colors.red[600], fontSize: 14.0),),
                            ),
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
                              'Date: ' + findRide[index].date,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Time: ' + findRide[index].time,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Fair: ' + findRide[index].price,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Seats: ' + findRide[index].seats,
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
        //  bookingRequest(findRide[index].id, findRide[index].user_id);
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PickupMap(rid: findRide[index].id,rideBy: findRide[index].user_id,
                          startLat: findRide[index].sLat,startLng: findRide[index].sLng,endLng: findRide[index].eLat,endLat: findRide[index].eLng,)));
                      },
                      child: Text(
                        'Send Request',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
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
}
