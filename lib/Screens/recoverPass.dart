import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:ride_share/Screens/updatePassword.dart';
import 'package:ride_share/UI/Widgets/custome_shape.dart';
import 'package:ride_share/UI/Widgets/responsive_ui.dart';
import 'package:ride_share/UI/Widgets/textformfield.dart';
import 'package:ride_share/blocs/sideBarBloc.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../Apis.dart';
import 'LoginScreen.dart';

class RecoverPassword extends StatefulWidget {
  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword>
    with NavigationStates {
  String userEmail = '';
  TextEditingController phoneC = new TextEditingController();
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  checkPhone(String phone) async {
    Map d = {'userPhone': phone};
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    // ignore: avoid_init_to_null
    var jsonData = null;
    var response = await http.post(Apis.VALIDATE_PHONE, body: d);

    if (response.body == 'failed') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height: _height / 4.5,
                width: _width / 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Icon(
                        Icons.warning_amber_outlined,
                        size: 50.0,
                        color: Colors.yellow,
                      )),
                      Center(
                          child: Text(
                        "   " + "This Phone Number is Invalid",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      )),
                      Center(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            phoneC.clear();
                          },
                          child: Text(
                            "Find Again",
                            style: TextStyle(
                                color: Colors.red[600], fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    } else {
      jsonData = json.decode(response.body);
      for (var a in jsonData['recover']) {
        setState(() {
          userEmail = a['email'];
          // _onLoading();
        });

        showAnimatedDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return ClassicGeneralDialogWidget(
              titleText: 'Successfully Found',
              positiveText: 'Proceed',
              positiveTextStyle: TextStyle(color: Colors.red),
              onPositiveClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdatePassword(text: userEmail)));
              },
            );
          },
          alignment: Alignment.center,
          animationType: DialogTransitionType.slideFromLeft,
          curve: Curves.fastOutSlowIn,
          duration: Duration(seconds: 1),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                appbar(),
                clipShape(),
                phoneField(),
                SizedBox(
                  height: _height / 35,
                ),
                button(),
              ],
            ),
          ),
        ),
      ),
    );
  }

// void _onLoading() {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//             borderRadius:
//             BorderRadius.circular(20.0)),
//          backgroundColor: Colors.red[600],
//
//       child: Container(
//         height: _height/4.5,
//         width: _width/1.5,
//       child: Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//      Center(
//       child : Loading(indicator: BallPulseIndicator(), size : 50.0, color: Colors.white,),
//       ),]
//       ),
//       ),
//       ),
//        );
//     },
//   );
//   new Future.delayed(new Duration(seconds: 3), () {
//     Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => UpdatePassword(text: userEmail)));
//
//   });
// }

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

  Widget phoneField() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        child: Column(
          children: <Widget>[
            CustomTextField(
              textEditingController: phoneC,
              icon: Icons.phone,
              hint: 'Enter Your Phone Number',
            ),
          ],
        ),
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        if (phoneC.text.isEmpty) {
          print("no");
        } else {
          checkPhone(phoneC.text);
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _width / 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.red[600],
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'FIND ACCOUNT',
          style: TextStyle(fontSize: _large ? 16 : (_medium ? 14 : 12)),
        ),
      ),
    );
  }

  Widget appbar() {
    return Material(
      child: Container(
        height: _height / 9.5,
        width: _width,
        padding: EdgeInsets.only(left: 15, top: 25),
        color: Colors.red[600],
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 28,
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
    );
  }
}
