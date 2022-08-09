import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

class DraggableScreen extends HookWidget {
  const DraggableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DraggablePage(),
    );
  }
}

// ignore: must_be_immutable
class DraggablePage extends HookWidget {
  List<CategoryData> itemList = [];

  DraggablePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag and Drop Test'),
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
class DragTargetItem extends HookWidget {
  int index = 0;
  List<CategoryData> itemList = [];
  DragTargetItem(int index, List<CategoryData> itemList, {Key? key})
      : super(key: key) {
    this.index = index;
    this.itemList = itemList;
  }
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
            data.index = index;
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
              onDragCompleted: () {},
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
      child: Text(index.toString(),
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
              ? Text(index.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 20.0))
              : Container(),
          Center(
              child: Text(getName(),
                  style: const TextStyle(color: Colors.white, fontSize: 40.0)))
        ]));
  }

  CategoryData? getItemData() {
    itemList.add(CategoryData(index: 1, name: "A"));
    itemList.add(CategoryData(index: 2, name: "B"));
    itemList.add(CategoryData(index: 3, name: "C"));
    final i = itemList.indexWhere(((item) => item.index == index));
    return i >= 0 ? itemList[i] : null;
  }

  String getName() {
    return getItemData() != null ? getItemData()!.name : "";
  }
}
