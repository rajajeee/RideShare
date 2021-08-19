import 'package:flutter/material.dart';
import 'package:ride_share/UI/widgets/responsive_ui.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  final String error;
  final int txtLength;
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;

  CustomTextField({
    this.hint,
    this.textEditingController,
    this.keyboardType,
    this.icon,
    this.obscureText = false,
    this.error,
    this.txtLength,
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
      child: TextFormField(
        maxLength: txtLength,
        controller: textEditingController,
        keyboardType: keyboardType,
        cursorColor: Colors.red[600],
        decoration: InputDecoration(
          prefixIcon: Icon(icon,  color:  Colors.red[600], size: 22.0),
          hintText: hint,
          errorText: error,
          // errorText: error,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
