
import 'package:bocagoi/services/logger.dart';
import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Logger.key = _scaffoldKey;
    final widget = buildScaffold(context, _scaffoldKey);
    return widget;
  }

  Widget buildScaffold(BuildContext context, GlobalKey<ScaffoldState> key);
}