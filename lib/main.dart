import 'package:flutter/material.dart';


class Category {
  int index;
  String name;
  bool draggable = true;

  Category(this.index, this.name);
}

void main() {
  runApp(const DraggableScreen());
}

class DraggableScreen extends StatelessWidget {
  const DraggableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DraggableTest(),
    );
  }
}

class DraggableTest extends StatefulWidget {
  const DraggableTest({Key? key}) : super(key: key);

  @override
  State<DraggableTest> createState() => DraggableTestState();
}

class DraggableTestState extends State<DraggableTest> {
  List<Category> list = List.generate(
      4,
      (index) =>
          Category(index, String.fromCharCode(index + 'A'.codeUnits[0])));

  int index = 0;

  void updator() {
    setState(() {
      index = index + 1;
    });
  }

  DraggableTestState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.extent(
          maxCrossAxisExtent: 120,
          children: List.generate(12, (i) {
            return DragTargetItem(i, list, updator);
          })),
    );
  }
}

// ignore: must_be_immutable
class DragTargetItem extends StatefulWidget {
  final int index;
  final List<Category> list;
  final Function() updator;

  const DragTargetItem(this.index, this.list, this.updator, {Key? key})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _DragTargetState createState() => _DragTargetState();
}

class _DragTargetState extends State<DragTargetItem> {
  bool willAccept = false;
  bool willReject = false;
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[

      DragTarget(
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: willAccept ? Colors.orangeAccent : Colors.white70,
                border: Border.all(color: Colors.deepOrange),
                borderRadius: BorderRadius.circular(5)),
            child: Text(widget.index.toString(),
                style: const TextStyle(color: Colors.black38, fontSize: 20.0)),
          );
        },
        onAccept: (Category? data) {
          if (category() == null) {
            setState(() {
              data?.index = widget.index;
            });
          } else {
            setState(() {
              final cat = widget.list
                  .firstWhere((category) => category.index == widget.index);
              final cat2 = widget.list
                  .firstWhere((category) => category.index == data!.index);
              final tmp = cat.index;
              cat.index = cat2.index;
              cat2.index = tmp;
              widget.updator();
            });
          }
          willAccept = false;
        },
        onWillAccept: (data) {
          willAccept = true;
          return true;
        },
        onMove: (data) {
          setState(() {});
        },
        onLeave: (data) {
          willAccept = false;
        },
      ),
      if (category() != null && category()!.draggable)
        Draggable(
          ignoringFeedbackSemantics: false,
          data: category(),
          onDragCompleted: () {
            setState(() {
              for (var d in widget.list) {
                d.draggable = true;
              }
              widget.updator();
            });
          },
          onDragUpdate: (detail) {
            setState(() {});
          },
          onDragStarted: () {
            willAccept = true;
            setState(() {
              for (var d in widget.list) {
                d.draggable = false;
              }
              widget.updator();
            });
          },
          onDragEnd: (data) {
            willAccept = false;
          },
          feedback: draggableWidget(),
          childWhenDragging: draggableWidget(),
          child: draggableWidget(),
        ),
      if (category() != null && category()!.draggable) const Text("Draggable")
    ]);
  }

  Widget draggableWidget() {
    return Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(color: Colors.orange),
        child: Stack(children: <Widget>[
          Center(
              child: Text(category()?.name ?? widget.index.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 60.0,
                      decoration: TextDecoration.none)))
        ]));
  }


  Category? category() {
    final i = widget.list.indexWhere(((item) => item.index == widget.index));
    return i >= 0 ? widget.list[i] : null;
  }
}
