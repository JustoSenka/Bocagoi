import 'package:bocagoi/widgets/text_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchableDropdown extends StatelessWidget {
  final Widget text;
  final Widget Function(int index) listViewItemBuilder;
  final String Function(int index) itemTextContentGetter;
  final int itemCount;

  SearchableDropdown(
      {@required this.text,
      @required this.listViewItemBuilder,
      @required this.itemCount,
      @required this.itemTextContentGetter});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () async {
                  await showDialog<int>(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => DropdownDialog(
                      listViewItemBuilder: listViewItemBuilder,
                      itemCount: itemCount,
                      itemTextContentGetter: itemTextContentGetter,
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text,
                    IconTheme(
                      child: Icon(Icons.arrow_drop_down),
                      data: IconThemeData(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 8.0,
              child: Container(
                height: 1.0,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFBDBDBD), width: 0.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DropdownDialog extends StatefulWidget {
  final Widget Function(int index) listViewItemBuilder;
  final String Function(int index) itemTextContentGetter;
  final int itemCount;

  const DropdownDialog({
    Key key,
    @required this.listViewItemBuilder,
    @required int itemCount,
    @required this.itemTextContentGetter,
  })  : itemCount = itemCount + 1,
        // Increasing by one since list view cannot be empty
        super(key: key);

  @override
  State<StatefulWidget> createState() => DropdownDialogState(
      listViewItemBuilder, itemCount, itemTextContentGetter);
}

class DropdownDialogState extends State<DropdownDialog> {
  final Widget Function(int index) listViewItemBuilder;
  final String Function(int index) itemTextContentGetter;
  final int itemCount;

  String searchString;

  DropdownDialogState(
      this.listViewItemBuilder, this.itemCount, this.itemTextContentGetter);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 300),
      child: Card(
        margin: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: <Widget>[
              buildSearchBar(),
              buildWordList(),
              buildCloseButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      child: Stack(
        children: <Widget>[
          TextField(
            autofocus: true,
            decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
            onChanged: (value) => setState(() => searchString = value),
          ),
        ],
      ),
    );
  }

  Widget buildWordList() {
    return Expanded(
      child: Scrollbar(
        child: ListView.builder(
          itemBuilder: buildListItems,
          itemCount: itemCount,
        ),
      ),
    );
  }

  Widget buildListItems(BuildContext context, int index) {
    // for last item always returning sized box, since list views cannot be empty
    if (index == itemCount) {
      return SizedBox.shrink();
    }

    var content = itemTextContentGetter(index);
    if (isItemVisible(content, searchString)) {
      return listViewItemBuilder(index);
    }

    return SizedBox.shrink();
  }

  // TODO: test
  static bool isItemVisible(String itemContent, String searchString) {
    if (searchString == null || searchString.isEmpty) {
      return true;
    }

    final content = itemContent?.toLowerCase();
    final pattern = searchString.toLowerCase();

    return content.contains(pattern);
  }

  Widget buildCloseButton() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: TextHtml("Close")),
        ],
      ),
    );
  }
}
