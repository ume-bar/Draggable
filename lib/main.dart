import 'package:flutter/material.dart';

class CategoryData {
  int index = -1;
  String name = "";
  CategoryData({int? index, String? name}) {
    if (index != null) this.index = index;
    if (name != null) this.name = name;
  }
}

void main() {
  runApp(const DraggableScreen());
}

class DraggableScreen extends StatelessWidget {
  const DraggableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Drag and Drop Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _DraggableState();
}

class _DraggableState extends State<MyHomePage> {
  List<CategoryData> itemList = [];
  _DraggableState() {
    itemList.add(CategoryData(index: 1, name: "A"));
    itemList.add(CategoryData(index: 2, name: "B"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.extent(
          maxCrossAxisExtent: 150,
          children: List.generate(12, (index) {
            return DragTargetItem(index + 1, itemList);
          })),
    );
  }
}

// ignore: must_be_immutable
class DragTargetItem extends StatefulWidget {
  int index = 0;
  List<CategoryData> itemList = [];
  DragTargetItem(int index, List<CategoryData> itemList, {Key? key})
      : super(key: key) {
    this.index = index;
    this.itemList = itemList;
  }
  @override
  // ignore: library_private_types_in_public_api
  _DragTargetState createState() => _DragTargetState();
}

class _DragTargetState extends State<DragTargetItem> {
  bool willAccept = false;
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      DragTarget(
        builder: (context, candidateData, rejectedData) {
          return dropWedget();
        },
        onAccept: (CategoryData? data) {
          if (data != null && getItemData() == null) {
            setState(() {
              data.index = widget.index;
            });
          }
          willAccept = false;
        },
        onWillAccept: (data) {
          willAccept = true;
          return true;
        },
        onLeave: (data) {
          willAccept = false;
        },
      ),
      getItemData() == null
          ? Container()
          : Draggable(
              data: getItemData(),
              onDragStarted: () {},
              onDraggableCanceled: (velocity, offset) {},
              onDragCompleted: () {
                setState(() {});
              },
              onDragEnd: (details) {},
              child: itemWedget(0),
              feedback: itemWedget(1),
              childWhenDragging: itemWedget(2),
            ),
    ]);
  }

  Widget dropWedget() {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          color: willAccept ? Colors.orangeAccent : Colors.white70,
          border: Border.all(color: Colors.deepOrange),
          borderRadius: BorderRadius.circular(5)),
      child: Text(widget.index.toString(),
          style: const TextStyle(color: Colors.black38, fontSize: 20.0)),
    );
  }

  Widget itemWedget(int m) {
    return Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
            color: (m == 2) ? Colors.orangeAccent : Colors.orange,
            border: Border.all(color: Colors.deepOrange),
            borderRadius: BorderRadius.circular(5)),
        child: Stack(children: <Widget>[
          (m == 0)
              ? Text(widget.index.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 20.0))
              : Container(),
          Center(
              child: Text(getName(),
                  style: const TextStyle(color: Colors.white, fontSize: 40.0)))
        ]));
  }

  CategoryData? getItemData() {
    final i =
        widget.itemList.indexWhere(((item) => item.index == widget.index));
    return i >= 0 ? widget.itemList[i] : null;
  }

  String getName() {
    return getItemData() != null ? getItemData()!.name : "";
  }
}
