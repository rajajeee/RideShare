import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/io_client.dart';
import 'package:ride_share/Screens/settings.dart';
import 'package:ride_share/UI/Widgets/custome_shape.dart';
import 'package:ride_share/UI/Widgets/responsive_ui.dart';
import '../Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChangeNIC extends StatefulWidget {

  @override
  _ChangeNICState createState() => _ChangeNICState();
}

class _ChangeNICState extends State<ChangeNIC> {
  var nicController = new MaskedTextController(mask: '00000-0000000-0');
  String validateNIC;
  GlobalKey<FormState> _key = GlobalKey();

  var id;
  var email;
  var nicNum;

  getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('userID');
    email = prefs.getString('userEmail');
    fetchUserDetails(id);
  }

  // ignore: non_constant_identifier_names
  changeUserCNIC(String CNIC) async {
    Map d ={'userNic': CNIC,'userEmail':email};
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    var response = await http.post(Apis.UPDATE_NIC, body: d);
    if(response.body == 'success')
    {
      setState(() {
        Navigator.pop(context,true);
      });
    }
    else{
      print(response.body);
    }
  }

  fetchUserDetails(String uID) async{
    Map d ={
      'userID':uID
    };
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    // ignore: avoid_init_to_null
    var jsonData = null;
    var response = await http.post(Apis.FETCH_PROFILE_API,body: d);
    print(response.body);

    jsonData = json.decode(response.body);
    for(var a in jsonData['user']){
      setState(() {
        nicNum = a['user_cnic'];
      });
    }
  }

  _ChangeNICState(){
    getDetails();
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
      key: _key,
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              appbar(),
              clipShape(),
              SizedBox(height: _height / 44),
              nicTextField(),
              SizedBox(height: _height / 44.0),
              button(),
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[600], Colors.red[600]],
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
                  colors: [Colors.red[600], Colors.red[600]],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget appbar() {
    return Material(
      child: Container(
        height: _height / 9.5,
        width: _width,
        padding: EdgeInsets.only(left: 15, top: 25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red[600],
              Colors.red[600],
            ],
          ),
        ),
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 28,
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  Widget nicTextField() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child : Material(
        borderRadius: BorderRadius.circular(10.0),
        elevation: _large ? 12 : (_medium ? 10 : 8),
        child: new TextFormField(
          controller: nicController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.local_phone_rounded, color: Colors.red[600], size: 22.0),
            hintText: '$nicNum',
            errorText: validateNIC,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        if(nicController.text.length==15)
          {
          changeUserCNIC(nicController.text);
          }
        else {
          setState(() {
            validateNIC="Nic must be 15 digits long";
          });
        }
        },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 8 : (_medium ? _width / 1.65 : _width / 1.5),
        height:
        _large ? _height / 8 : (_medium ? _width / 9.2 : _height / 19.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.red[600],
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'SAVE',
          style: TextStyle(fontSize: _large ? 16 : (_medium ? 14 : 12)),
        ),
      ),
    );
  }
}
