import 'package:bocagoi/models/abstractions.dart';
import 'package:bocagoi/widgets/text_html.dart';
import 'package:flutter/material.dart';
import 'package:bocagoi/utils/strings.dart';

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
              borderRadius: BorderRadius.circular((fontSize.units + 10) / 4)),
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
  PrimaryText(this.text, {this.center = false, Key key}) : super(key: key);

  final String text;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return center ? Center(child: buildText()) : buildText();
  }

  Text buildText() {
    return Text(
      text,
      style: TextStyle(
        fontSize: FontSize.medium.units,
      ),
    );
  }
}

class SecondaryText extends StatelessWidget {
  SecondaryText(this.text, {this.center = false, Key key}) : super(key: key);

  final String text;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return center ? Center(child: buildText()) : buildText();
  }

  Text buildText() {
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
      this.onSaved,
      Key key})
      : super(key: key);

  final String initialValue;
  final String labelText;
  final int maxLines;
  final void Function(String) onChanged;
  final void Function(String) onSaved;
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
        onSaved: (value) {
          if (onSaved != null) onSaved(value);
        },
      ),
    );
  }
}

class LoadingListPageWithProgressIndicator<T, K> extends StatelessWidget {
  LoadingListPageWithProgressIndicator(
      {this.body, this.future, this.isDataEmpty, this.textIfNoData, Key key})
      : super(key: key);

  final Future<Map<T, K>> future;
  final Widget Function(Map<T, K>) body;
  final String textIfNoData;
  final bool Function(AsyncSnapshot<Map<T, K>> snapshot) isDataEmpty;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<Map<T, K>> books) {
        if (!books.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (isDataEmpty != null && isDataEmpty(books)) {
          return Center(child: Text(textIfNoData));
        } else {
          return body(books.data);
        }
      },
    );
  }
}

class LoadingPageWithProgressIndicator<T> extends StatelessWidget {
  LoadingPageWithProgressIndicator(
      {this.body, this.future, this.isDataEmpty, this.textIfNoData, Key key})
      : super(key: key);

  final Future<T> future;
  final Widget Function(T) body;
  final String textIfNoData;
  final bool Function(AsyncSnapshot<T> snapshot) isDataEmpty;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> books) {
        if (!books.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (isDataEmpty != null && isDataEmpty(books)) {
          return Center(child: Text(textIfNoData));
        } else {
          return body(books.data);
        }
      },
    );
  }
}

/// Not complete
class EditableListTile extends StatefulWidget {
  EditableListTile({this.left, this.right, Key key}) : super(key: key);

  final String left;
  final String right;

  @override
  _EditableListTileState createState() => _EditableListTileState();
}

/// Not complete
class _EditableListTileState extends State<EditableListTile> {
  bool isBeingEdited = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: switchEditingState,
      title: isBeingEdited ? buildEditableText() : buildNonEditableRow(),
    );
  }

  void switchEditingState() {
    setState(() {
      isBeingEdited = !isBeingEdited;
    });
  }

  Row buildNonEditableRow() {
    return Row(
      children: [
        Text(
          widget.left ?? "<empty>".tr(),
          style: TextStyle(fontFamily: "Monospace"),
        ),
        Spacer(),
        Text(widget.right ?? "<empty>".tr()),
      ],
    );
  }

  Widget buildEditableText() {
    return RoundedTextFormField(
      labelText: widget.left,
      initialValue: widget.right ?? "",
      onSaved: (_) => switchEditingState(),
    );
  }
}

class ListTileDropdown extends StatelessWidget {
  ListTileDropdown(
      {Key key,
      this.title = "",
      this.titleStyle,
      this.value = 0,
      this.map,
      this.onChanged,
      this.dropdownTextGetter,
      this.addNoneSelection = false,
      this.dropdownFlex = 1})
      : super(key: key);

  final String title;
  final TextStyle titleStyle;
  final int value;
  final Map<int, IHaveID> map;
  final void Function(int) onChanged;
  final String Function(int) dropdownTextGetter;
  final bool addNoneSelection;
  final int dropdownFlex;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(
            title ?? "<empty>".tr(),
            style: titleStyle,
          ),
          Spacer(),
          Expanded(
            flex: dropdownFlex,
            child: DropdownButton<int>(
              value: value,
              onChanged: onChanged,
              items: buildItems(),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> buildItems() {
    final items = [
      // value == 0 safeguard if unset value is here, show none by default
      // if users select something else, none option will disappear forever
      if (addNoneSelection || value == 0)
        DropdownMenuItem<int>(value: 0, child: Text("None".tr())),
      ...buildDropdownItems(map, dropdownTextGetter),
    ];
    return items;
  }
}

List<DropdownMenuItem<int>> buildDropdownItems(
    Map<int, IHaveID> map, String Function(int) dropdownTextGetter) {
  return map.values
      .map(
        (e) => DropdownMenuItem<int>(
          value: e.id,
          child: PrimaryText(
            dropdownTextGetter(e.id),
          ),
        ),
      )
      .toList();
}

class DoubleListTile extends StatelessWidget {
  const DoubleListTile({Key key, this.left, this.right, this.titleStyle})
      : super(key: key);

  final String left;
  final String right;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(
            left ?? "<empty>".tr(),
            style: titleStyle,
          ),
          Spacer(),
          Text(right ?? "<empty>".tr()),
        ],
      ),
    );
  }
}

class SpacedOutRow extends StatelessWidget {
  const SpacedOutRow({
    Key key,
    this.style,
    this.list,
  }) : super(key: key);

  final List<Widget> list;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: buildList(),
    );
  }

  List<Widget> buildList() {
    var newList = <Widget>[];
    newList.add(list[0]);

    for (var i = 1; i < list.length; i++) {
      newList.add(Spacer());
      newList.add(list[i]);
    }

    return newList;
  }
/*
  Text buildText(int i) => Text(
        list[i] ?? "<empty>".tr(),
        style: style,
      );*/
}
