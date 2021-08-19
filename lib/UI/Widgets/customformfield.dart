import 'package:flutter/material.dart';
import 'package:ride_share/UI/widgets/responsive_ui.dart';

// ignore: must_be_immutable
class CustomInputField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;
  bool enable;

  CustomInputField(
      {this.hint,
      this.textEditingController,
      this.keyboardType,
      this.icon,
      this.obscureText = false,
      this.enable = false});

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
        enabled: enable,
        controller: textEditingController,
        keyboardType: keyboardType,
        cursorColor: Color(0xFF3366FF),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFF3366FF), size: 18),
          hintText: hint,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.blueGrey,
            ), onPressed: () {  },
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
