import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class DrawingArea {
  Offset point;
  Paint areaPaint;
  DrawingArea({this.point, this.areaPaint});
}

class _HomePageState extends State<HomePage> {
  List<DrawingArea> point = [];
  Color selectedColor;
  double stokeWidth;

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    stokeWidth = 1.0;
  }

  void selectColor(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple[900],
                    Colors.pink,
                    Colors.pink[400],
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: size.width * .8,
                    height: size.height * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onPanDown: (details) {
                        this.setState(() {
                          point.add(
                            DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor
                                ..strokeWidth = stokeWidth,
                            ),
                          );
                        });
                      },
                      onPanUpdate: (details) {
                        this.setState(() {
                          point.add(
                            DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor
                                ..strokeWidth = stokeWidth,
                            ),
                          );
                        });
                      },
                      onPanEnd: (details) {
                        this.setState(() {
                          point.add(null);
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CustomPaint(
                          painter: MyPaint(
                              point: point,
                              color: selectedColor,
                              stokeWidth: stokeWidth),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 40,
                    height: size.width * .8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.color_lens, color: selectedColor),
                            onPressed: () {
                              selectColor(context);
                            }),
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Slider(
                              min: 1.0,
                              max: 7,
                              activeColor: selectedColor,
                              value: stokeWidth,
                              onChanged: (value) {
                                setState(() {
                                  stokeWidth = value;
                                });
                              },
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.layers_clear),
                            onPressed: () {
                              setState(() {
                                point.clear();
                              });
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPaint extends CustomPainter {
  List<DrawingArea> point;
  Color color;
  double stokeWidth;

  MyPaint({this.point, this.color, this.stokeWidth});
  @override
  void paint(Canvas canvas, Size size) {
    Paint bg = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, bg);

    for (int x = 0; x < point.length - 1; x++) {
      if (point[x] != null && point[x + 1] != null) {
        Paint paint = point[x].areaPaint;
        canvas.drawLine(point[x].point, point[x + 1].point, paint);
      } else if (point[x] != null && point[x + 1] == null) {
        Paint paint = point[x].areaPaint;
        canvas.drawPoints(PointMode.points, [point[x].point], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
