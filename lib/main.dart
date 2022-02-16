// ignore_for_file: unnecessary_null_comparison

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_signature_draw/canvas_painting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Offset> _points = <Offset>[];
  final GlobalKey _key = GlobalKey();
  double strokeWidth = 3.0;
  Color selectedColor = Colors.black;
  Paint paint = Paint();

  double initial = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signature Demo'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => const [
              PopupMenuItem(
                child: Text('Red Color'),
                value: 'Red',
              ),
              PopupMenuItem(
                child: Text('Yellow Color'),
                value: 'Yellow',
              ),
              PopupMenuItem(
                child: Text('Orange Color'),
                value: 'Orange',
              ),
              PopupMenuItem(
                child: Text('Blue Color'),
                value: 'Blue',
              ),
              PopupMenuItem(
                child: Text('Green Color'),
                value: 'Green',
              ),
            ],
            onSelected: (item) => SelectedColor(context, item),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CanvasPainting()));
              },
              icon: const Icon(Icons.next_plan)),
        ],
      ),
      body: Container(
        child: GestureDetector(
            child: CustomPaint(
              painter: Signature(points: _points, paintColor: paint),
              size: Size.infinite,
              isComplex: true,
            ),
            onPanStart: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset localPosition = renderBox.globalToLocal(Offset(
                    details.globalPosition.dx,
                    details.globalPosition.dy - 100));

                _points = List.from(_points)..add(localPosition);
                paint = Paint()
                  ..color = selectedColor
                  ..strokeCap = StrokeCap.round
                  ..strokeWidth = 5;
              });
            },
            onPanUpdate: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset localPosition = renderBox.globalToLocal(Offset(
                    details.globalPosition.dx,
                    details.globalPosition.dy - 100));
                // print(localPosition);

                _points = List.from(_points)..add(localPosition);
              });
            },
            onPanEnd: (DragEndDetails details) {
              _points.add(null as Offset);
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _points.clear();
        },
        child: const Icon(Icons.clear_rounded),
      ),
    );
  }

  void SelectedColor(BuildContext context, item) {
    switch (item) {
      case 'Red':
        setState(() {
          selectedColor = Colors.red;
        });
        break;
      case 'Yellow':
        setState(() {
          selectedColor = Colors.yellow;
        });
        break;
      case 'Orange':
        setState(() {
          selectedColor = Colors.orange;
        });
        break;
      case 'Blue':
        setState(() {
          selectedColor = Colors.blue;
        });
        break;
      case 'Green':
        setState(() {
          selectedColor = Colors.green;
        });
        break;
    }
  }
}

class Signature extends CustomPainter {
  List<Offset> points = [];
  Paint paintColor = Paint();
  Signature({required this.points, required this.paintColor});
  @override
  void paint(Canvas canvas, Size size) {
    // Paint paint = paintColor;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paintColor);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) {
    return oldDelegate.points != points;
  }
}
