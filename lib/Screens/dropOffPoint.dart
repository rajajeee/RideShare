import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:ride_share/Apis.dart';
import 'package:http/io_client.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ride_share/Screens/Dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class DropOffPoint extends StatefulWidget {
  var id;
  // ignore: non_constant_identifier_names
  var ride_by;
  var start;
  var startLat;
  var startLng;
  var drLat;
  var drLng;
  // ignore: non_constant_identifier_names
  DropOffPoint({this.id,this.ride_by,this.start,this.startLat,this.startLng,this.drLat,this.drLng});
  @override
  _DropOffPointState createState() => _DropOffPointState();
}

class _DropOffPointState extends State<DropOffPoint> {
  // ignore: non_constant_identifier_names
  var drop_latitude,drop_longitude,drop_name;
  Set<Marker> _markers={};
  Completer<GoogleMapController> _controller = Completer();
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);


  }
  void addMarker(LatLng points) async{
    print(widget.drLat);
    print(widget.drLng);
    _markers.clear();
    final coordinates = new Coordinates(points.latitude, points.longitude);
    var  addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    setState(() {
      drop_name = first.addressLine;
      drop_latitude = points.latitude;
      drop_longitude = points.longitude;
      _markers.add(Marker(markerId: MarkerId('drop'),position: LatLng(points.latitude, points.longitude),infoWindow: InfoWindow(
          title: 'Drop Point',
          snippet: first.addressLine.toString()
      )));

      _markers.add(Marker(markerId: MarkerId('end'),position: LatLng(double.parse(widget.drLng),double.parse(widget.drLat)),infoWindow: InfoWindow(
          title: 'End Point',
      )));


    });

  }
  bookingRequest() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('userID');

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    Map d = {
      'rideID': widget.id.toString(),
      'rideBy' : widget.ride_by.toString(),
      'userID' : id.toLowerCase(),
      'pickName':widget.start.toString(),
      'pickLat':widget.startLat.toString(),
      'pickLng':widget.startLng.toString(),
      'dropName':drop_name.toString(),
      'dropLat':drop_latitude.toString(),
      'dropLng':drop_longitude.toString()

    };

    var response = await http.post(Apis.RIDE_BOOKING, body: d);

    if(response.body == 'success'){
      print('done');
      setState(() {
        Fluttertoast.showToast(
            msg: "Ride Request Has Been Submitted",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        // ignore: invalid_use_of_protected_member
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()));

      });
    }
    else{
      print(response.body);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Drop Off Point'),
          backgroundColor: Colors.red[600],
          centerTitle: true,
        ),
        body:Column(
          children: [
            Container(
              height: 550,
            child:
            GoogleMap(

                onMapCreated: _onMapCreated,
                markers: _markers,
                onTap: (LatLng latLng){
                  var latitude = latLng.latitude;
                  var longitude = latLng.longitude;
                  addMarker(latLng);
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(24.8607, 67.0011),
                  zoom: 14.0,

                ))),
            RaisedButton(
              onPressed: (){
                bookingRequest();
              },
              child: Text('Done'),
            )

          ],
        )
    );

  }
}
