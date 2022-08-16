import 'package:flutter/material.dart';

class CategoryData {
  CategoryData(
      {required this.index, required this.name, required this.draggable});
  int index = -1;
  String name = "";
  bool draggable = false;
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
  List<CategoryData> list = [];
  _DraggableState() {
    list.add(CategoryData(index: 1, name: "A", draggable: false));
    list.add(CategoryData(index: 2, name: "B", draggable: false));
    list.add(CategoryData(index: 3, name: "C", draggable: false));
    list.add(CategoryData(index: 4, name: "D", draggable: false));
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
            return DragTargetItem(index + 1, list);
          })),
    );
  }
}

// ignore: must_be_immutable
class DragTargetItem extends StatefulWidget {
  int index = 0;
  List<CategoryData> list = [];
  DragTargetItem(int index, List<CategoryData> list, {Key? key})
      : super(key: key) {
    this.index = index;
    this.list = list;
  }
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
      willReject
          ? Container()
          : DragTarget(
              // ドラッグターゲットのウィジェット
              builder: (context, candidateData, rejectedData) {
                return dropWedget();
              },
              onAccept: (CategoryData? data) {
                if (data != null && getData() == null) {
                  print(data.index);
                  print(widget.list);

                  setState(() {
                    // int a = data.index;
                    data.index = widget.index;
                    // widget.index = a;
                  });
                  print(data.index);
                }
                willAccept = false;
                // willReject = false;
              },
              onWillAccept: (data) {
                print("ターゲット確認 $data");
                willAccept = true;
                // willReject = true;
                return true;
              },
              // onLeave: (data) {
              //   willAccept = false;
              //   // willReject = false;
              // },
            ),
      getData() == null
          ? Container()
          : Draggable(
              // feedbackをchildと同じにする
              ignoringFeedbackSemantics: false,
              data: getData(),
              // DragTargetで受け入られた時呼び出される
              onDragCompleted: () {
                print("ドロップ完了");
                setState(() {});
              },
              onDragStarted: () {
                print(getData);
                print("ドラッグ開始");
                willAccept = true;
                // willReject = true;
                setState(() {});
              },
              onDragEnd: (data) {
                print("ドラッグ終了: $data");
                willAccept = false;
                // willReject = false;
              },
              // ドラッグ中、ターゲットに当てられるウィジェット
              feedback: itemWedget('B'),
              // ドラッグアイテムの初期値のウィジェット
              childWhenDragging: itemWedget('C'),
              // ドラッグアイテムの下に位置するウィジェットでレイアウト可能
              child: itemWedget('A'),
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

  Widget itemWedget(String m) {
    return Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
            color: (m == 'C') ? Colors.orangeAccent : Colors.orange,
            border: Border.all(color: Colors.deepOrange),
            borderRadius: BorderRadius.circular(5)),
        child: Stack(children: <Widget>[
          (m == 'A')
              ? Text(widget.index.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      decoration: TextDecoration.none))
              : Container(),
          Center(
              child: Text(getName(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 60.0,
                      decoration: TextDecoration.none)))
        ]));
  }

// １２個あるウィジェットの中にあるインスタンスのindexを照合
  CategoryData? getData() {
    final i = widget.list.indexWhere(((item) => item.index == widget.index));
    return i >= 0 ? widget.list[i] : null;
  }

  String getName() {
    return getData() != null ? getData()!.name : "";
  }
}
