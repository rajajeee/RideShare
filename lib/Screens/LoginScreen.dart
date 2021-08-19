import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:ride_share/Apis.dart';
import 'package:ride_share/Constants/constants.dart';
import 'package:ride_share/Screens/Dashboard.dart';
import 'package:ride_share/Screens/SignUp.dart';
import 'package:ride_share/Screens/recoverPass.dart';
import 'package:ride_share/UI/Widgets/custome_shape.dart';
import 'package:ride_share/UI/Widgets/responsive_ui.dart';
import 'package:ride_share/UI/Widgets/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(),
    );
  }
}
class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool visible = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();

  saveUserData(String userID, String userName, String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', userID);
    prefs.setString('userName', userName);
    prefs.setString('userEmail', userEmail);
    // ignore: deprecated_member_use
    prefs.commit();
  }

  Future userLogin(String userEmail, String userPassword) async {
    setState(() {
      visible = true;
    });
    Map data = {'userEmail': userEmail, 'userPassword': userPassword};
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    // ignore: avoid_init_to_null
    var jsonData = null;
    var response = await http.post(Apis.LOGIN_API, body: data);
    print(response.body);
    if (response.body == 'failed') {
      setState(() {
        visible = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: _height/4.5,
                width: _width/1.5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child : Icon(Icons.error_rounded,size: 50.0,color: Colors.red,)),
                      Center(child: Text("   "+"Invalid Email & Password",style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),)),
                    Center(
                      child :  FlatButton(
                          onPressed: () { Navigator.of(context).pop();},
                          child: Text(
                            "Retry",
                            style: TextStyle( color:  Colors.red[600],fontSize: 16.0),
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
      setState(() {
        visible = false;
      });
      jsonData = json.decode(response.body);
      for (var x in jsonData['user_details']) {
        print(x['id']);
        setState(() {
          saveUserData(
              x['id'], x['first_name'] + ' ' + x['last_name'], x['email']);
///          _onLoading();


          });

        showAnimatedDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return ClassicGeneralDialogWidget(
              titleText: 'Login Success',
              positiveText: 'Proceed',
              positiveTextStyle: TextStyle(color: Colors.red),
              onPositiveClick: () {
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Dashboard()));
              },
            );
          },
          alignment: Alignment.center,
          animationType: DialogTransitionType.slideFromLeft,
          curve: Curves.fastOutSlowIn,
          duration: Duration(seconds: 1),
        );


      }
//      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery
        .of(context)
        .size
        .height;
    _width = MediaQuery
        .of(context)
        .size
        .width;
    _pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
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
              welcomeTextRow(),
              signInTextRow(),
              form(),
              forgetPassTextRow(),
              SizedBox(height: _height / 24),
              button(),
              signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
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
                  ? _height / 4.5
                  : (_medium ? _height / 3.75 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red[600],
                    Colors.red[600],
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 30
                  : (_medium ? _height / 25 : _height / 20)),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Center(
      child : Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
    );
  }

  Widget signInTextRow() {
    return Center(
      child :   Text(
            "Sign in to your account",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height / 40.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget passwordTextFormField() {
    return Material(
        borderRadius: BorderRadius.circular(10.0),
    elevation: _large ? 12 : (_medium ? 10 : 8),
    child: TextFormField(
      controller: passwordController,
      cursorColor:   Colors.red[600],
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color:  Colors.red[600], size: 20),
        hintText: "Password",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none),
      ),
    ),
    );
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.0),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecoverPassword()),
              );
            },
            child: Text(
              "Recover",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color:  Colors.red[600],),
            ),
          )
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        userLogin(emailController.text, passwordController.text);
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
          alignment: Alignment.center,
          width: _width/1.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
           color:  Colors.red[600],
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'SIGN IN',
            style: TextStyle(fontSize: _large ? 16 : (_medium ? 14 : 12)),
          )),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 60.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.0),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => SignUpScreen()));
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                fontWeight: FontWeight.w600, color:  Colors.red[600],),
            ),
          )
        ],
      ),
    );

  }

}


