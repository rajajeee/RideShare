import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'package:bitmap/bitmap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:ride_share/Apis.dart';
import 'package:ride_share/Screens/changeName.dart';
import 'package:ride_share/Screens/changeNic.dart';
import 'package:ride_share/Screens/changePass.dart';
import 'package:ride_share/Screens/changeCity.dart';
import 'package:ride_share/Screens/changeGender.dart';
import '../blocs/sideBarBloc.dart';
import 'package:ride_share/UI/Widgets/custome_shape.dart';
import 'package:ride_share/UI/Widgets/responsive_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'changePhone.dart';

class Settings extends StatefulWidget with NavigationStates {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  Bitmap _bitmap;
  bool update = false;
  File _image;
  // GlobalKey<FormState> _key = GlobalKey();

  var id;
  var email;
  var first = '';
  var last = '';
  var phone = '';
  // ignore: non_constant_identifier_names
  var user_city = '';
  // ignore: non_constant_identifier_names
  var user_gender = '';
  // ignore: non_constant_identifier_names
  var user_cnic = '';
  // ignore: non_constant_identifier_names
  var user_image = '';

  getDetails() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('userID');
      email = prefs.getString('userEmail');
      fetchUserDetails(id);
    });
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  fetchUserDetails(String uID) async {
    Map d = {'userID': uID};
    final ioc = new HttpClient();

    bool _certificateCheck(X509Certificate cert, String host, int port) =>
        host == 'local.domain.ext'; // <- change

    HttpClient client = new HttpClient()
      ..badCertificateCallback = (_certificateCheck);

    // ioc.badCertificateCallback =
    //     (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(client);
    var jsonData;
    jsonData = null;
    var response = await http.post(Apis.FETCH_PROFILE_API, body: d);
    print(response.body);

    jsonData = json.decode(response.body);
    for (var a in jsonData['user']) {
      setState(() {
        first = a['first_name'];
        last = a['last_name'];
        phone = a['phone'];
        user_city = a['user_city'];
        user_gender = a['user_gender'];
        user_cnic = a['user_cnic'];
        user_image = Apis.BASE_URL+a['image'];
        print(user_image);
      });
    }
  }


  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    rebuildAllChildren(context);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                clipShape(),
                form(),
              ],
            ),
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
        Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: Container(
            height: _height / 7.5,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    spreadRadius: 0.0,
                    color: Colors.black26,
                    offset: Offset(1.0, 10.0),
                    blurRadius: 20.0),
              ],
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
                onTap: () {
                  _imgFromGallery();
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
                    : user_image!=null ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    user_image,
                  // 'https://miro.medium.com/max/1000/1*ilC2Aqp5sZd1wi0CopD1Hw.pngs',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                ): Container(
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
              ),            ),
          ),
        ),
        update == true ? Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
            child: FlatButton(
              onPressed: (){
      changeImage(_image, email);
              },
              child:Text('Save', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),)
            ),
          ),
        )
  : Container()
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
            username(),
            SizedBox(height: _height / 62),
            userphone(),
            SizedBox(height: _height / 62),
            userEmail(),
            SizedBox(height: _height / 62),
            userCNIC(),
            SizedBox(height: _height / 62),
            userCity(),
            SizedBox(height: _height / 62),
            userGender(),
            SizedBox(height: _height / 22),
            userPassword(),
          ],
        ),
      ),
    );
  }

  Widget username() {
    return Container(
      height: _height / 14,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 8,
        ),
      ),
      child: Row(children: [
        Icon(
          Icons.person,
          size: _large ? 30 : (_medium ? 23 : 21),
          color: Colors.red[600],
        ),
        Text(
          "   " + first + "  " + last,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        IconButton(
          iconSize: 20.0,
          color: Colors.red[600],
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ChangeName())).then((value) => getDetails());
          },
        )
      ]),
    );
  }

  Widget userphone() {
    return Container(
      height: _height / 14,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 8,
        ),
      ),
      child: Row(children: [
        Icon(
          Icons.phone,
          size: _large ? 30 : (_medium ? 23 : 21),
          color: Colors.red[600],
        ),
        Text(
          '   ' + phone,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        IconButton(
          iconSize: 20.0,
          color: Colors.red[600],
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChangePhone())).then((value) => getDetails());
          },
        ),
      ]),
    );
  }

  Widget userCNIC() {
    return Container(
      height: _height / 14,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 8,
        ),
      ),
      child: Row(children: [
        Icon(
          Icons.contact_phone,
          size: _large ? 30 : (_medium ? 23 : 21),
          color: Colors.red[600],
        ),
        Text(
          '   ' + user_cnic,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        IconButton(
          iconSize: 20.0,
          color: Colors.red[600],
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ChangeNIC())).then((value) => getDetails());
          },
        )
      ]),
    );
  }

  Widget userEmail() {
    return Container(
      height: _height / 14,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 8,
        ),
      ),
      child: Row(children: [
        Icon(
          Icons.email,
          size: _large ? 30 : (_medium ? 23 : 21),
          color: Colors.red[600],
        ),
        Text(
          email == null ? " " : "   " + email,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }

  Widget userCity() {
    return Container(
      height: _height / 14,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 8,
        ),
      ),
      child: Row(children: [
        Icon(
          Icons.location_city_sharp,
          size: _large ? 30 : (_medium ? 23 : 21),
          color: Colors.red[600],
        ),
        Text(
          "   " + user_city,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        IconButton(
          iconSize: 20.0,
          color: Colors.red[600],
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ChangeCity())).then((value) => getDetails());
          },
        )
      ]),
    );
  }

  Widget userGender() {
    return Container(
      height: _height / 14,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 8,
        ),
      ),
      child: Row(children: [
        Icon(
          Icons.person_rounded,
          size: _large ? 30 : (_medium ? 23 : 21),
          color: Colors.red[600],
        ),
        Text(
          "   " + user_gender,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        IconButton(
          iconSize: 20.0,
          color: Colors.red[600],
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChangeGender())).then((value) => getDetails());
          },
        )
      ]),
    );
  }

  Widget userPassword() {
    return Container(
      height: _height / 14,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 8,
        ),
      ),
      child: Center(
        child: InkWell(
          child: Text(
            "Change Password",
            style: TextStyle(
                color: Colors.red[600],
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChangePass())).then((value) => getDetails());
          },
        ),
      ),
    );
  }

  _imgFromGallery() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      update = true;
      print(_image.path);
    });
  }
  // ignore: non_constant_identifier_names
  changeImage(File img,String userEmail) async {
    final bytes = Io.File(img.path).readAsBytesSync();

    String img64 = base64Encode(bytes);

    Map d ={'userEmail': userEmail,'userImage':img64};
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    var response = await http.post(Apis.UPDATE_IMAGE, body: d);
    if(response.body == 'success')
    {
      setState(() {
        update = false;
      });
    }
    else{
      print(response.body);
    }
  }

}
