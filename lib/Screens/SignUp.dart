import 'dart:convert';
import 'dart:io';
import 'package:bitmap/bitmap.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:ride_share/Apis.dart';
import 'package:ride_share/Constants/constants.dart';
import 'package:ride_share/UI/Widgets/customappbar.dart';
import 'package:ride_share/UI/Widgets/custome_shape.dart';
import 'package:ride_share/UI/Widgets/responsive_ui.dart';
import 'package:ride_share/UI/Widgets/textformfield.dart';
import 'package:image_picker/image_picker.dart';
import 'LoginScreen.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'dart:io' as Io;
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  Bitmap _bitmap;
  File _image;
  String error;
  String validateName;
  String validateLastName;
  String validateEmail;
  String validateCnic;
  String validatePhone;

  TextEditingController firstC = new TextEditingController();
  TextEditingController lastC = new TextEditingController();
  TextEditingController emailC = new TextEditingController();
  TextEditingController phoneC = new TextEditingController();
  TextEditingController passwordC = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController genderController = new TextEditingController();
  var nicController = new MaskedTextController(mask: '00000-0000000-0');
  var phoneController = new MaskedTextController(mask: '000000000000');

  registerUser(
      String firstName,
      String lastName,
      String userEmail,
      String userPhone,
      String userCNIC,
      String userPassword,
      String userCity,
      String userGender,
      File img) async {
  if(img == null){
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
                    Center(
                        child: Text(
                          "Please Select the Picture",
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
  else {
    final bytes = Io.File(img.path).readAsBytesSync();

    String img64 = base64Encode(bytes);

    Map data = {
      'userFirstName': firstName,
      'userLastName': lastName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'userCnic': userCNIC,
      'userPassword': userPassword,
      'userCity': userCity,
      'userGender': userGender,
      'userImage': img64
    };

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    var response = await http.post(Apis.REGISTER_API, body: data);
    print(response.body);
    print(img64);
    if (response.body == 'success') {
      showAnimatedDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ClassicGeneralDialogWidget(
            titleText: 'Signup Success',
            positiveText: 'Proceed',
            positiveTextStyle: TextStyle(color: Colors.red),
            onPositiveClick: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInPage()));
            },
          );
        },
        alignment: Alignment.center,
        animationType: DialogTransitionType.slideFromLeft,
        curve: Curves.fastOutSlowIn,
        duration: Duration(seconds: 1),
      );
    } else {
      print(response.body);
    }
  }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.68, child: CustomAppBar()),
                clipShape(),
                form(),
                acceptTermsTextRow(),
                SizedBox(
                  height: _height / 35,
                ),
                button(),
                signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _imgFromCamera() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print(_image.path);
    });
  }

  // ignore: non_constant_identifier_names
  String city_id;
  // ignore: non_constant_identifier_names
  String gender_id;
  List<String> city = ["Karachi", "Lahore", "Islamabad"];
  List<String> gender = ["Male", "Female"];

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
        Column(
          children: <Widget>[
            SizedBox(
              height: 32,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.red[600],
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.red[600],
                          ),
                        ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            lastNameTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            phoneTextField(),
            SizedBox(height: _height / 60.0),
            nicTextField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
            SizedBox(height: _height / 60.0),
            selectCity(),
            SizedBox(height: _height / 60.0),
            selectGender(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      textEditingController: firstC,
      keyboardType: TextInputType.text,
      icon: Icons.account_circle_sharp,
      hint: "First Name",
      error: validateName,
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      textEditingController: lastC,
      keyboardType: TextInputType.text,
      icon: Icons.account_circle_sharp,
      hint: "Last Name",
      error: validateLastName,
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      textEditingController: emailC,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Email ID",
      error: validateEmail,
    );
  }

  Widget passwordTextFormField() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: _large ? 12 : (_medium ? 10 : 8),
      child: TextFormField(
        controller: passwordC,
        cursorColor: Colors.red[600],
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.red[600], size: 22.0),
          hintText: "Password",
          errorText: error,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget nicTextField() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: _large ? 12 : (_medium ? 10 : 8),
      child: new TextFormField(
        controller: nicController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.perm_identity_sharp,
              color: Colors.red[600], size: 22.0),
          hintText: "CNIC",
          errorText: validateCnic,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.red[600],
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        if (checkBoxValue == true) {
          if (passwordC.text.length > 4 &&
              firstC.text.length > 3 &&
              lastC.text.length > 3 &&
              emailC.text.length > 8 &&
              nicController.text.length == 15 &&
              phoneController.text.length == 12) {
            registerUser(
                firstC.text,
                lastC.text,
                emailC.text,
                phoneController.text,
                nicController.text,
                passwordC.text,
                cityController.text,
                genderController.text,
                _image);
            setState(() {
              error = null;
              validateName = null;
              validateLastName = null;
              validateEmail = null;
              validatePhone = null;
              validateCnic = null;
            });
          } else {
            if (passwordC.text.length < 4) {
              setState(() {
                error = "Password must be 5 characters long or more";
              });
            } else {
              setState(() {
                error = null;
              });
            }
            if (firstC.text.length < 3) {
              setState(() {
                validateName = "First Name must be 4 characters long or more";
              });
            } else {
              setState(() {
                validateName = null;
              });
            }
            if (lastC.text.length < 3) {
              setState(() {
                validateLastName =
                    "Last Name must be 4 characters long or more";
              });
            } else {
              setState(() {
                validateLastName = null;
              });
            }

            if (emailC.text.length < 9) {
              setState(() {
                validateEmail = "Email must be 9 characters long or more";
              });
            } else {
              setState(() {
                validateEmail = null;
              });
            }
            if (emailC.text.length < 12) {
              setState(() {
                validatePhone = "Phone no must be 12 digits starts with 92";
              });
            } else {
              setState(() {
                validatePhone = null;
              });
            }
            if (emailC.text.length < 16) {
              setState(() {
                validateCnic = "CNIC must be 14 digits";
              });
            } else {
              setState(() {
                validateCnic = null;
              });
            }
          }
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
          'SIGN UP',
          style: TextStyle(fontSize: _large ? 16 : (_medium ? 14 : 12)),
        ),
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(Sign_in);
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.red[600],
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }

  Widget selectCity() {
    return Container(
      child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          elevation: _large ? 12 : (_medium ? 10 : 8),
          child: Column(
            children: <Widget>[
              DropDownField(

                onValueChanged: (dynamic value) {
                  city_id = value;
                  print(cityController);
                },
                controller: cityController,
                value: city_id,
                required: true,
                hintText: "Choose a City",
                labelText: "City",
                items: city,
              )
            ],
          )),
    );
  }

  Widget selectGender() {
    return Container(
      child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          elevation: _large ? 12 : (_medium ? 10 : 8),
          child: Column(
            children: <Widget>[
              DropDownField(
                onValueChanged: (dynamic val) {
                  gender_id = val;
                  print(genderController);
                },
                controller: genderController,
                value: gender_id,
                required: true,
                hintText: "Select Gender",
                labelText: "Gender",
                items: gender,
              )
            ],
          )),
    );
  }

  Widget phoneTextField() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: _large ? 12 : (_medium ? 10 : 8),
      child: new TextFormField(
        controller: phoneController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.local_phone_rounded,
              color: Colors.red[600], size: 22.0),
          hintText: "Phone no",
          errorText: validatePhone,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Bitmap>('_bitmap', _bitmap));
  }
}
