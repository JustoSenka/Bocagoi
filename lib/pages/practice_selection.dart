import 'package:bocagoi/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PracticeSelectionPage extends StatefulWidget {
  PracticeSelectionPage({Key key}) : super(key: key);

  @override
  _PracticeSelectionPageState createState() => _PracticeSelectionPageState();
}

class _PracticeSelectionPageState extends State<PracticeSelectionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedBox = "Box1";
  String _fromText = "";
  String _toText = "";

  int _from = 0;
  int _to = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practice".tr()),
      ),
      body: Container(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  buildBoxSelection(),
                  buildLabelForMinMaxSelection(),
                  buildWordMinMaxSelection(),
                  buildContinueButton(),
                ],
              ),
            )),
      ),
    );
  }

  Widget buildBoxSelection() {
    return Container(
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Select word box: ".tr()),
            DropdownButton<String>(
              value: _selectedBox,
              items: BuildBoxSelectionDropdownItems(),
              onChanged: (t) {
                setState(() {
                  //_selectedBoxText = t;
                  _selectedBox = t;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabelForMinMaxSelection() {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
        child: Text("Select words which to practice: ".tr()),
      ),
    );
  }

  Widget buildWordMinMaxSelection() {
    return Container(
      child: SizedBox(
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                initialValue: _fromText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                  labelText: "From: ",
                ),
                validator: (val) {
                  return int.tryParse(val) == null ? "Invalid input" : null;
                },
                onChanged: (val) {
                  setState(() {
                    _to = int.tryParse(val);
                    ValidateForm();
                  });
                },
              ),
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                initialValue: _toText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                  labelText: "To: ",
                ),
                validator: (val) {
                  return int.tryParse(val) == null ? "Invalid input" : null;
                },
                onChanged: (val) {
                  setState(() {
                    _to = int.tryParse(val);
                    ValidateForm();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContinueButton() {
    return Container();
  }

  List<DropdownMenuItem<String>> BuildBoxSelectionDropdownItems() {
    return [
      DropdownMenuItem<String>(value: "Box1", child: Text("Box1")),
      DropdownMenuItem<String>(value: "Box2", child: Text("Box2")),
      DropdownMenuItem<String>(value: "Box3", child: Text("Box3")),
      DropdownMenuItem<String>(value: "Box4", child: Text("Box4")),
    ];
  }

  void ValidateForm() {
    var res = _formKey.currentState.validate();
    print("Is form input valid: $res");
  }
}
