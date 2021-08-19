import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_share/UI/Widgets/custome_shape.dart';
import 'package:ride_share/UI/Widgets/responsive_ui.dart';
import '../blocs/sideBarBloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget with NavigationStates {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        child: Column(
          children: <Widget>[
            clipShape(),
            slider(),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: buttons(),
              ),
            ),
            SizedBox(height: _height/32,),
          ],
        ),
      ),);
  }

  Widget slider() {
    return Stack(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: _height/1.5,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
          items: [
            'assets/Images/LoginBg.png',
            'assets/Images/LoginBg.png',
          ].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Image.asset(
                      i,
                    ));
              },
            );
          }).toList(),
        ),
      ],
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


  Widget buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: () {
            BlocProvider.of<NavigationBloc>(context)
                .add(NavigationEvents.FindRidesClickEvent);
          },
          textColor: Colors.white,
          padding: EdgeInsets.all(0.0),
          child: Container(
            width: _width/2.5,
            height: _height/12,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.red[600],
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'FIND RIDE',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        SizedBox(
          width: 6.0,
        ),
        RaisedButton(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: () {
            BlocProvider.of<NavigationBloc>(context)
                .add(NavigationEvents.OfferRideClickEvent);
          },
          textColor: Colors.white,
          padding: EdgeInsets.all(0.0),
          child: Container(
            width: _width/2.5,
            height: _height/12,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.red[600],
            ),
            padding: const EdgeInsets.all(12.0),
            child : Text(
                  'OFFER RIDE',
                  style: TextStyle(fontSize: 16.0),
                ),
          ),
        ),
      ],
    );
  }
}
