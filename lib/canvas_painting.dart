// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';

import 'package:flutter_signature_draw/touchpoints.dart';

class CanvasPainting extends StatefulWidget {
  const CanvasPainting({Key? key}) : super(key: key);

  @override
  CanvasPaintingState createState() => CanvasPaintingState();
}

class CanvasPaintingState extends State<CanvasPainting> {
  List<TouchPoints> points = [];
  double opacity = 1.0;
  StrokeCap strokeType = StrokeCap.round;
  double strokeWidth = 3.0;
  Color selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canvas Painting'),
      ),
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            points.add(TouchPoints(
                points: renderBox.globalToLocal(Offset(
                    details.globalPosition.dx,
                    details.globalPosition.dy - 100)),
                paint: Paint()
                  ..strokeCap = strokeType
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        },
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            points.add(TouchPoints(
                points: renderBox.globalToLocal(Offset(
                    details.globalPosition.dx,
                    details.globalPosition.dy - 100)),
                paint: Paint()
                  ..strokeCap = strokeType
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null as TouchPoints);
          });
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: Image.asset("assets/images/hut.png"),
            ),
            CustomPaint(
              size: Size.infinite,
              painter: MyPainter(
                pointList: points,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        colorStartAnimation: Colors.blue,
        colorEndAnimation: Colors.cyan,
        animatedIconData: AnimatedIcons.menu_close,
        fabButtons: fabOption(),
      ),
    );
  }

  // !list of fab buttons
  List<Widget> fabOption() {
    return <Widget>[
      FloatingActionButton(
        heroTag: "paint_stroke",
        child: const Icon(Icons.brush),
        tooltip: 'Stroke',
        onPressed: () {
          setState(() {
            _pickStroke();
          });
        },
      ),

      //FAB for choosing opacity
      FloatingActionButton(
        heroTag: "paint_opacity",
        child: const Icon(Icons.opacity),
        tooltip: 'Opacity',
        onPressed: () {
          //min:0, max:1
          setState(() {
            _opacity();
          });
        },
      ),

      //FAB for resetting screen
      FloatingActionButton(
          heroTag: "erase",
          child: const Icon(Icons.clear),
          tooltip: "Erase",
          onPressed: () {
            setState(() {
              points.clear();
            });
          }),

      //FAB for picking red color
      FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_red",
        child: colorMenuItem(Colors.red),
        tooltip: 'Color',
        onPressed: () {
          setState(() {
            selectedColor = Colors.red;
          });
        },
      ),

      //FAB for picking green color
      FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_green",
        child: colorMenuItem(Colors.green),
        tooltip: 'Color',
        onPressed: () {
          setState(() {
            selectedColor = Colors.green;
          });
        },
      ),

      //FAB for picking pink color
      FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_pink",
        child: colorMenuItem(Colors.pink),
        tooltip: 'Color',
        onPressed: () {
          setState(() {
            selectedColor = Colors.pink;
          });
        },
      ),

      //FAB for picking blue color
      FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_blue",
        child: colorMenuItem(Colors.blue),
        tooltip: 'Color',
        onPressed: () {
          setState(() {
            selectedColor = Colors.blue;
          });
        },
      ),
    ];
  }

  Future<void> _opacity() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ClipOval(
            child: AlertDialog(
              actions: [
                FlatButton(
                  onPressed: () {
                    opacity = 0.1;
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.opacity,
                    size: 24,
                  ),
                ),
                FlatButton(
                  child: const Icon(
                    Icons.opacity,
                    size: 40,
                  ),
                  onPressed: () {
                    opacity = 0.5;
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: const Icon(
                    Icons.opacity,
                    size: 60,
                  ),
                  onPressed: () {
                    //not transparent at all.
                    opacity = 1.0;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _pickStroke() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ClipOval(
            child: AlertDialog(
              actions: [
                FlatButton(
                  child: const Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    strokeWidth = 3.0;
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: const Icon(
                    Icons.brush,
                    size: 24,
                  ),
                  onPressed: () {
                    strokeWidth = 10.0;
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: const Icon(
                    Icons.brush,
                    size: 40,
                  ),
                  onPressed: () {
                    strokeWidth = 50.0;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget colorMenuItem(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  List<TouchPoints> pointList;
  List<Offset> offsetPoints = [];
  MyPainter({
    required this.pointList,
  });
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointList.length - 1; i++) {
      if (pointList[i] != null && pointList[i + 1] != null) {
        canvas.drawLine(
            pointList[i].points, pointList[i + 1].points, pointList[i].paint);
      } else if (pointList[i] != null && pointList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(
            Offset(pointList[i].points.dx + 0.1, pointList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return false;
  }
}
