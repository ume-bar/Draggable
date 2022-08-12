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

// ignore: must_be_immutable
class DraggablePage extends HookWidget {
  const DraggablePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("list");
    final list = useState<List<CategoryData>>([]);

    useEffect(() {
      list.value = [
        CategoryData(index: 1, name: "A"),
        CategoryData(index: 2, name: "B"),
        CategoryData(index: 3, name: "C"),
      ];
      print("useEffect");
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag and Drop Test'),
      ),
      body: GridView.extent(
          maxCrossAxisExtent: 150,
          children: List.generate(12, (index) {
            return DragTargetItem(index + 1, list.value);
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
    print("YYYYYYYYYYY");
    print(index);
    // ignore: prefer_initializing_formals
    this.index = index;
    print(this.index);
    print(itemList);
    // ignore: prefer_initializing_formals
    this.itemList = itemList;
    print(this.itemList);
  }

  @override
  Widget build(BuildContext context) {
    final willAccept = useState(false);
    return Stack(children: <Widget>[
      DragTarget(
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
                color: willAccept.value ? Colors.orangeAccent : Colors.white70,
                border: Border.all(color: Colors.deepOrange),
                borderRadius: BorderRadius.circular(5)),
            child: Text(index.toString(),
                style: const TextStyle(color: Colors.black38, fontSize: 20.0)),
          );
        },
        onAccept: (CategoryData? data) {
          print("DragTargetがドロップされた: カテゴリ: $data");
          if (data != null && getData() == null) {
            data.index = index;
            print("XXXXXXXXXX");
            print(data.index);
          }
          print(index);

          willAccept.value = false;
        },
        onWillAccept: (data) {
          willAccept.value = true;
          return true;
        },
        onAcceptWithDetails: (data) {
          print("DragTargetがドロップされた位置: data: $data");
        },
        onMove: (data) {
          print("DragTarget内移動中: data: $data");
        },
        onLeave: (data) {
          print("重なっていない状態: data: $data");
          willAccept.value = false;
        },
      ),
      getData() == null
          ? Container()
          : LongPressDraggable(
              data: getData(),
              delay: Duration(milliseconds: 1000),
              key: key,
              onDragStarted: () {
                print("ドラッグ開始");
              },
              onDraggableCanceled: (velocity, offset) {
                print(
                    "ターゲットの範囲外のウィジェットでドロップ: velocity: $velocity, offset: $offset");
              },
              onDragCompleted: () {
                print("ターゲットの範囲内でドロップ");
              },
              onDragEnd: (data) {
                print("ドロップ成功: data: $data");
              },
              feedback: itemWedget('B'),
              childWhenDragging: itemWedget('C'),
              child: itemWedget('A'),
            ),
    ]);
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
              ? Text(index.toString(),
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

  CategoryData? getData() {
    print("getData");
    final i = itemList.indexWhere(((item) => item.index == index));
    return i >= 0 ? itemList[i] : null;
  }

  String getName() {
    print("getName");
    return getData() != null ? getData()!.name : "";
  }
}


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _DraggableState();
// }

// class _DraggableState extends State<MyHomePage> {
//   List<CategoryData> list = [];
//   _DraggableState() {
//     list.add(CategoryData(index: 1, name: "A"));
//     list.add(CategoryData(index: 2, name: "B"));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: GridView.extent(
//           maxCrossAxisExtent: 150,
//           children: List.generate(12, (index) {
//             return DragTargetItem(index + 1, list);
//           })),
//     );
//   }
// }

// // ignore: must_be_immutable
// class DragTargetItem extends StatefulWidget {
//   int index = 0;
//   List<CategoryData> list = [];
//   DragTargetItem(int index, List<CategoryData> list, {Key? key})
//       : super(key: key) {
//     this.index = index;
//     this.list = list;
//   }
//   @override
//   // ignore: library_private_types_in_public_api
//   _DragTargetState createState() => _DragTargetState();
// }

// class _DragTargetState extends State<DragTargetItem> {
//   bool willAccept = false;
//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: <Widget>[
//       DragTarget(
//         builder: (context, candidateData, rejectedData) {
//           return dropWedget();
//         },
//         onAccept: (CategoryData? data) {
//           if (data != null && getData() == null) {
//             setState(() {
//               data.index = widget.index;
//             });
//           }
//           willAccept = false;
//         }