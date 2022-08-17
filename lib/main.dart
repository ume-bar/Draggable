import 'package:flutter/material.dart';

// カテゴリのクラスを定義
class Category {
  int index;
  String name;
  bool draggable = true;
// ゲッターでindexとnameを使用
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
  // List.generateとString.fromCharCodeで規則性のあるラテン文字を要素に持つリストを作成
  List<Category> list = List.generate(
      4,
      (index) =>
          Category(index, String.fromCharCode(index + 'A'.codeUnits[0])));

  int index = 0;
// indexの初期値を設定
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
            // 12個のwidgetを作成
            return DragTargetItem(i, list, updator);
          })),
    );
  }
}

// ignore: must_be_immutable
class DragTargetItem extends StatefulWidget {
  // indexウィジェットの内容
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
  // ドラッグ&ドロップを判定するbool値
  bool willAccept = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      // ドラッグターゲットのウィジェット
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
              // DragTargetItemでターゲットになったリスト内の最初の一致を返す
              final cat = widget.list
                  .firstWhere((category) => category.index == widget.index);
              // Draggableで掴んだリスト内の最初の一致を返す
              final cat2 = widget.list
                  .firstWhere((category) => category.index == data!.index);
              // swapで入れ替え
              final tmp = cat.index;
              cat.index = cat2.index;
              cat2.index = tmp;
              // indexを更新
              widget.updator();
            });
          }
          willAccept = false;
        },
        onWillAccept: (data) {
          // ignore: avoid_print
          print("ターゲット確認 $data");
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
          // feedbackをchildと同じにする
          ignoringFeedbackSemantics: false,
          // ターゲットに入れたい値を設定、ここでは照合した結果を入れる
          data: category(),
          // DragTargetで受け入られた時呼び出される
          onDragCompleted: () {
            setState(() {
              for (var d in widget.list) {
                d.draggable = true;
              }
              widget.updator();
            });
            print("ドロップ完了");
          },
          onDragUpdate: (detail) {
            setState(() {});
          },
          onDragStarted: () {
            print("ドラッグ開始");
            willAccept = true;
            setState(() {
              for (var d in widget.list) {
                d.draggable = false;
              }
              widget.updator();
            });
          },
          onDragEnd: (data) {
            print("ドラッグ終了: $data");
            willAccept = false;
          },
          // ドラッグ中、ターゲットに当てられるウィジェット
          feedback: draggableWidget('B'),
          // ドラッグアイテムの初期値のウィジェット
          childWhenDragging: draggableWidget('C'),
          // ドラッグアイテムの下に位置するウィジェットでレイアウト可能
          child: draggableWidget('A'),
        ),
      // draggableできる要素に装飾
      if (category() != null && category()!.draggable)
        // ignore: avoid_unnecessary_containers
        Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(right: 18),
            child: const Text("Draggable",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                )))
    ]);
  }

// 引数でUIを変更できるようにしたウィジェット関数
  Widget draggableWidget(String m) {
    return Container(
        width: 100,
        height: 100,
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
              child: Text(category()?.name ?? widget.index.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 60.0,
                      decoration: TextDecoration.none)))
        ]));
  }

// １２個あるウィジェットの中にあるインスタンスのindexを照合
  Category? category() {
    final i = widget.list.indexWhere(((item) => item.index == widget.index));
    return i >= 0 ? widget.list[i] : null;
  }
}
