import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_curved_line/maps_curved_line.dart';


// ignore: must_be_immutable
class ViewRide extends StatefulWidget {
  String startPoint;
  String startLatitude;
  String startLongtitude;
  String endPoint;
  String endLatitude;
  String endLongtitude;

  ViewRide({this.startPoint,this.startLatitude,this.startLongtitude,this.endPoint,this.endLatitude,this.endLongtitude});
  @override
  _ViewRideState createState() => _ViewRideState();
}



class _ViewRideState extends State<ViewRide> {

  final Set<Polyline> _polylines = Set();

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers={};



  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
      setState(() {
        _markers.add(Marker(markerId: MarkerId('start'),position: LatLng(double.parse(widget.startLatitude), double.parse(widget.startLongtitude)),infoWindow: InfoWindow(
            title: 'Start Point',
            snippet: widget.startPoint
        )));
        _markers.add(Marker(markerId: MarkerId('end'),position: LatLng(double.parse(widget.endLatitude), double.parse(widget.endLongtitude)),infoWindow: InfoWindow(
          title: 'End Point',
              snippet: widget.endPoint
        )));


      });


  }

  @override
  Widget build(BuildContext context) {

    _polylines.add(
        Polyline(
          polylineId: PolylineId("line 1"),
          visible: true,
          width: 2,
          //latlng is List<LatLng>
          patterns: [PatternItem.dash(30), PatternItem.gap(10)],
          points: MapsCurvedLines.getPointsOnCurve(LatLng(double.parse(widget.startLatitude),double.parse(widget.startLongtitude)),
          LatLng(double.parse(widget.endLatitude),double.parse(widget.endLongtitude))), // Invoke lib to get curved line points
          color: Colors.red[600],
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('View Ride'),
        backgroundColor: Colors.red[600],
      ),
        body: GoogleMap(
          polylines: _polylines,
          markers: _markers,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
        target: LatLng(double.parse(widget.startLatitude), double.parse(widget.startLongtitude)),
        zoom: 14.0,
    ))
    );
  }
}
