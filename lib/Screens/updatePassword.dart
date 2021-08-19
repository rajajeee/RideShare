import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:ride_share/Screens/recoverPass.dart';
import 'package:ride_share/UI/Widgets/custome_shape.dart';
import 'package:ride_share/UI/Widgets/responsive_ui.dart';
import 'package:ride_share/UI/Widgets/textformfield.dart';
import 'package:ride_share/blocs/sideBarBloc.dart';

import '../Apis.dart';
import 'LoginScreen.dart';

class UpdatePassword extends StatefulWidget {
  final String text;
  UpdatePassword({Key key, @required this.text}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> with NavigationStates {
  String error;
  TextEditingController emailC = new TextEditingController();
  TextEditingController passC = new TextEditingController();


  checkEmailToChangePassword(String uEmail) async {
    if (uEmail == widget.text) {
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = new IOClient(ioc);
      Map d = {'userEmail': uEmail, 'userPassword': passC.text};
      var response = await http.post(Apis.UPDATE_PASSWORD, body: d);
      if (response.body == 'success') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                  height: _height / 4.5,
                  width: _width / 1.2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Icon(
                          Icons.verified_user,
                          size: 50.0,
                          color: Colors.green,
                        )),
                        Center(
                            child: Text(
                          "Password Recovered Successfully",
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w600),
                        )),
                       Row(
                            children: [
                              Spacer(),
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SignInPage()));
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.red[600], fontSize: 16.0),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  emailC.clear();
                                  passC.clear();
                                },
                                child: Text(
                                  "Stay",
                                  style: TextStyle(
                                      color: Colors.red[600], fontSize: 16.0),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            });
      } else {
        print(response.body);
      }
    } else {
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
                        Icons.error_rounded,
                        size: 50.0,
                        color: Colors.red,
                      )),
                      SizedBox(height: 5.0,),
                      Center(
                          child: Text(
                        "Email not match",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      )),
                      Center(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Retry",
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
    }
  }

  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  var r = '';

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
                form(),
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

  bunch() {}
  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 80.0),
      child: Form(
        child: Column(children: <Widget>[
          Text(
            widget.text.replaceRange(2, 9, "*******"),
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: _height / 100.0),
          Text("Confirm your email to recover your Account"),
          SizedBox(height: _height / 50.0),
          emailTextFormField(),
          SizedBox(height: _height / 60.0),
          newPassTextFormField(),
          SizedBox(height: _height / 60.0),
        ]),
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

  Widget emailTextFormField() {
    return CustomTextField(
      textEditingController: emailC,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Enter Your Registered Email",
    );
  }

  Widget newPassTextFormField() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: _large ? 12 : (_medium ? 10 : 8),
      child: TextFormField(
        controller: passC,
        cursorColor: Colors.red[600],
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.red[600], size: 20),
          hintText: "Password",
          errorText: error,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {

        if(passC.text.length>3)
        {
          checkEmailToChangePassword(emailC.text);

        }
        else{
          setState(() {
            error = 'Password Must Be 4 Characters or Long';
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
          gradient: LinearGradient(
            colors: <Color>[Colors.red[600], Colors.red[600]],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'RECOVER PASSWORD',
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
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
    );
  }
}
