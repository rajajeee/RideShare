import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'dropOffPoint.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: must_be_immutable
class PickupMap extends StatefulWidget {
  var rid;
  var rideBy;
  var startLat;
  var startLng;
  var endLat;
  var endLng;
  PickupMap({this.rid,this.rideBy,this.startLat,this.startLng,this.endLat,this.endLng});
  @override
  _PickupMapState createState() => _PickupMapState();
}


class _PickupMapState extends State<PickupMap> {
// ignore: non_constant_identifier_names
var pick_latitude,pick_longitude,pick_name;
Set<Marker> _markers={};
Set<Marker> start= {};
Completer<GoogleMapController> _controller = Completer();
  void _onMapCreated(GoogleMapController controller) {
  _controller.complete(controller);
}
  void addMarker(LatLng points) async{
    _markers.clear();
    final coordinates = new Coordinates(points.latitude, points.longitude);
  var  addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    setState(() {
      _markers.add(Marker(markerId: MarkerId('pickup'),position: LatLng(double.parse(widget.startLat),double.parse(widget.startLng)),infoWindow: InfoWindow(
        title: 'Pickup Point',
      )));
      pick_name = first.addressLine;
      pick_latitude = points.latitude;
      pick_longitude = points.longitude;
      _markers.add(Marker(markerId: MarkerId('start'),position: LatLng(points.latitude, points.longitude),infoWindow: InfoWindow(
          title: 'Start Point',
          snippet: first.addressLine.toString()
      )));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Up Point'),
          backgroundColor: Colors.red[600],
          centerTitle: true,
      ),
        body:Column(
          children: [
            Container(
                height: 550,
                child:GoogleMap(
                onMapCreated: _onMapCreated,
                markers:_markers,
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


                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DropOffPoint(
                    id: widget.rid,ride_by: widget.rideBy,start: pick_name,startLat: pick_latitude,
                    startLng: pick_longitude,drLat: widget.endLat,drLng: widget.endLng)));
              },
              child: Text('Next'),
            )

          ],
        )
    );
  }
}
