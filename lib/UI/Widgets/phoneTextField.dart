import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ride_share/UI/widgets/responsive_ui.dart';

// ignore: must_be_immutable
class PhoneTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;
  bool enable;

  PhoneTextField({
    this.hint,
    this.textEditingController,
    this.enable = false,
  });

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child : IntlPhoneField(
        controller: textEditingController,
        decoration: InputDecoration(
    labelText: 'Phone Number',
    ),
    initialCountryCode: 'PK',

      ),
    );
  }
}
