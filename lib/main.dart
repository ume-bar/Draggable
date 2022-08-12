import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';

String _initRoute = "/home";
Future<void> main() async {
  runApp(const DraggableApp());
}

class DraggableApp extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const DraggableApp() : super();

  @override
  // ignore: library_private_types_in_public_api
  _DraggableApp createState() => _DraggableApp();
}

class _DraggableApp extends State<DraggableApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draggaable',
      theme: ThemeData(),
      initialRoute: _initRoute,
      routes: {
        '/home': (context) => const DraggablePage(),
      },
    );
  }
}
