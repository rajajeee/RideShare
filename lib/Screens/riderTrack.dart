import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Apis.dart';
import 'package:firebase_database/firebase_database.dart';
// ignore: must_be_immutable
class TrackRider extends StatefulWidget {
  var ridei;
  TrackRider({this.ridei});
  @override
  _TrackRiderState createState() => _TrackRiderState();
}

class _TrackRiderState extends State<TrackRider> {
var riderNode;
static LatLng _initialPosition;
var riderLatitude,riderLongtitude;

  void getDriverLocation() async{
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

      Map d = {'rideID': widget.ridei};
      var jsonData;
      var response = await http.post(Apis.TRACKING_NODE, body: d);
      print('Ride : ' + widget.ridei);
      print(response.body);

      if (response.body == 'no') {

      }
      else {
        jsonData = json.decode(response.body);

        for (var a in jsonData['tracknode']) {
          setState(() {
            riderNode = a['node_name'];
            riderLocation(riderNode);
          });

      }
    }
  }

Completer<GoogleMapController> _controller = Completer();
void _onMapCreated(GoogleMapController controller) {
  _controller.complete(controller);
}
Set<Marker> _markers={};
Set<Marker> mapMarker={};

riderLocation(var n) async {
    FirebaseDatabase.instance
      .reference()
      .child(riderNode)
      .root()
      .once().then((DataSnapshot snapshot) async {
    Map<dynamic, dynamic> values = snapshot.value;
    values.forEach((key, values) {
      setState(()  {
        riderLatitude = values['lat'];
        riderLongtitude = values['lng'];
      _initialPosition= null;
        _initialPosition = LatLng(double.parse(riderLatitude), double.parse(riderLongtitude));

        print('Initial : ${riderLatitude} , ${riderLongtitude}');
        _markers.add(Marker(markerId: MarkerId('start'),
            position: LatLng(
                double.parse(riderLatitude), double.parse(riderLongtitude)),
            infoWindow: InfoWindow(
              title: 'Rider Location',
            )));

         FirebaseDatabase.instance.reference().child(riderNode).root().onChildChanged.listen((event)  {
           _markers.clear();
          riderLatitude = event.snapshot.value['lat'];
          riderLongtitude = event.snapshot.value['lng'];
          _initialPosition= null;
          _initialPosition = LatLng(double.parse(riderLatitude), double.parse(riderLongtitude));


          _markers.add(Marker(markerId: MarkerId('start'),
              position: LatLng(
                  double.parse(riderLatitude), double.parse(riderLongtitude)),
              infoWindow: InfoWindow(
                title: 'Rider Location',
              )));

          print('Updated : ${riderLatitude} , ${riderLongtitude}');

          updateMarker('start', riderLatitude, riderLongtitude);
        });
      });
    });



  });
  // .onChildChanged.listen((event) {
  //   Map<dynamic, dynamic> values = event.snapshot.value;
  //   values.forEach((key, values) {
  //     setState(() {
  //
  //       riderLatitude = values['lat'];
  //       riderLongtitude = values['lng'];
  //       _markers.clear();
  //       _markers.add(Marker(markerId: MarkerId('start'),
  //           position: LatLng(
  //               double.parse(riderLatitude), double.parse(riderLongtitude)),
  //           infoWindow: InfoWindow(
  //             title: 'Rider Location',
  //           )));
  //     googleMapRider();
  //
  //     });
  //   });
  // });
}

updateMarker(var id,var l,var t) async{
  mapMarker.add(Marker(markerId: MarkerId(id),onTap: (){},
  position: LatLng(double.parse(l),double.parse(t)),
  infoWindow: InfoWindow(title: 'Driver Location')));

  setState(() {
    _markers = mapMarker;
  });
}

@override
  void initState()  {
    // TODO: implement initState
    super.initState();
    getDriverLocation();
    riderLocation(riderNode);

  }
  @override
  Widget build(BuildContext context) {

   return gm();
  }

  Widget gm(){
   return GoogleMap(
      markers:  _markers,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(24.8607,67.0011),
        zoom: 9.0,

      ),
    );
  }


}



