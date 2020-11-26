import 'package:flutter/material.dart';
import 'package:bocagoi/utils/strings.dart';

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

class DeleteButton extends StatelessWidget {
  DeleteButton({this.onPressed, Key key}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: "Delete".tr(),
      color: BootstrapColors.danger,
      fontSize: FontSize.small,
      onPressed: () {
        if (onPressed != null) onPressed();
      },
    );
  }
}

class CancelButton extends StatelessWidget {
  CancelButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: "Cancel".tr(),
      color: BootstrapColors.dark,
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

class SaveButton extends StatelessWidget {
  SaveButton({this.onPressed, this.formKey, Key key}) : super(key: key);

  final VoidCallback onPressed;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: "Save".tr(),
      color: BootstrapColors.primary,
      fontSize: FontSize.big,
      onPressed: () {
        if (onPressed != null &&
            (formKey == null || formKey.currentState.validate())) {
          onPressed();
        }
      },
    );
  }
}

class PrimaryText extends StatelessWidget {
  PrimaryText(this.text, {Key key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: FontSize.medium.units,
      ),
    );
  }
}

class SecondaryText extends StatelessWidget {
  SecondaryText(this.text, {Key key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: FontSize.xsmall.units,
        color: BootstrapColors.secondary,
      ),
    );
  }
}

class RoundedTextFormField extends StatelessWidget {
  RoundedTextFormField(
      {this.initialValue,
      this.labelText,
      this.maxLines = 1,
      this.onChanged,
      this.validator,
      Key key})
      : super(key: key);

  final String initialValue;
  final String labelText;
  final int maxLines;
  final void Function(String) onChanged;
  final String Function(String) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          labelText: labelText,
        ),
        maxLines: maxLines,
        onChanged: (value) {
          if (onChanged != null) onChanged(value);
        },
        validator: (value) {
          return validator != null ? validator(value) : null;
        },
      ),
    );
  }
}
