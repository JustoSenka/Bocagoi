import 'package:flutter/material.dart';

class BootstrapColors {
  static const Color primary = Color(0xff007bff);
  static const Color info = Color(0xff17a2b8);
  static const Color warning = Color(0xffffc107);
  static const Color success = Color(0xff28a745);

  static const Color danger = Color(0xffdc3545);
  static const Color dark = Color(0xff343a40);
  static const Color secondary = Color(0xff6c757d);
  static const Color light = Color(0xfff8f9fa);
}

class FontSize {
  const FontSize(double this.units);

  final double units;

  static const FontSize xbig = FontSize(22);
  static const FontSize big = FontSize(20);
  static const FontSize medium = FontSize(18);
  static const FontSize small = FontSize(16);
  static const FontSize xsmall = FontSize(14);
}

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {this.color = Colors.blue,
      this.text = "Button",
      this.fontSize = FontSize.medium,
      this.onPressed,
      Key key})
      : super(key: key);

  final String text;
  final FontSize fontSize;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: SizedBox(
        height: fontSize.units * 1.7,
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
              borderRadius:
                  new BorderRadius.circular((fontSize.units + 10) / 4)),
          color: color,
          child: Text(text,
              style: TextStyle(fontSize: fontSize.units, color: Colors.white)),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
