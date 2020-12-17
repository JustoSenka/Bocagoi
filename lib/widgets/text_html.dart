import 'package:flutter/cupertino.dart';

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
  const FontSize(this.units);

  final double units;

  static const FontSize xbig = FontSize(22);
  static const FontSize big = FontSize(20);
  static const FontSize medium = FontSize(18);
  static const FontSize small = FontSize(16);
  static const FontSize xsmall = FontSize(14);
}

class PaddingSize {
  const PaddingSize(this.units);

  final double units;

  static const PaddingSize xbig = PaddingSize(20);
  static const PaddingSize big = PaddingSize(15);
  static const PaddingSize medium = PaddingSize(10);
  static const PaddingSize small = PaddingSize(5);
  static const PaddingSize xsmall = PaddingSize(3);
  static const PaddingSize none = PaddingSize(0);
}

enum Class {
  center,
  multiline,
  bold,
  italic,
  monospace,
  xbig,
  big,
  medium,
  small,
  xsmall,
  paddingTopSmall,
  paddingBottomSmall,
  paddingTopMedium,
  paddingBottomMedium,
  paddingTopBig,
  paddingBottomBig
}

class TextHtml extends StatelessWidget {
  TextHtml(this.text, {List<Class> classes, Key key})
      : classes = classes?.toSet() ?? Set(),
        super(key: key);

  final String text;
  final Set<Class> classes;

  @override
  Widget build(BuildContext context) {
    final fontStyle =
        classes.contains(Class.italic) ? FontStyle.italic : FontStyle.normal;
    final fontWeight =
        classes.contains(Class.bold) ? FontWeight.bold : FontWeight.normal;
    final fontFamily = classes.contains(Class.monospace) ? "Monospace" : "";
    final fontSize = getFontSize().units;
    final lines = classes.contains(Class.multiline) ? 10 : 1;

    var textWidget = Text(
      text,
      maxLines: lines,
      style: TextStyle(
        fontStyle: fontStyle,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );

    Widget returnWidget = textWidget;

    if (classes.contains(Class.center)) {
      returnWidget = Center(child: returnWidget);
    }

    final padding = getPadding();
    if (padding != null) {
      returnWidget = Padding(
        padding: padding,
        child: returnWidget,
      );
    }

    return returnWidget;
  }

  EdgeInsetsGeometry getPadding() {
    final bottom = classes.contains(Class.paddingBottomSmall)
        ? PaddingSize.small
        : classes.contains(Class.paddingBottomMedium)
            ? PaddingSize.medium
            : classes.contains(Class.paddingBottomBig)
                ? PaddingSize.big
                : PaddingSize.none;

    final top = classes.contains(Class.paddingTopSmall)
        ? PaddingSize.small
        : classes.contains(Class.paddingTopMedium)
            ? PaddingSize.medium
            : classes.contains(Class.paddingTopBig)
                ? PaddingSize.big
                : PaddingSize.none;

    if (top.units == 0 && bottom.units == 0) {
      return null;
    }

    return EdgeInsets.fromLTRB(0, top.units, 0, bottom.units);
  }

  FontSize getFontSize() => classes.contains(Class.xbig)
      ? FontSize.xbig
      : classes.contains(Class.big)
          ? FontSize.big
          : classes.contains(Class.medium)
              ? FontSize.medium
              : classes.contains(Class.small)
                  ? FontSize.small
                  : classes.contains(Class.xsmall)
                      ? FontSize.xsmall
                      : FontSize.medium;
}
