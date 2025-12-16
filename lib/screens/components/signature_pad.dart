import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SignaturePad extends StatefulWidget {
  final Function(List<Offset>) onDrawEnd;
  final double strokeWidth;
  final Color strokeColor;

  const SignaturePad({
    Key? key,
    required this.onDrawEnd,
    this.strokeWidth = 3.0,
    this.strokeColor = Colors.black,
  }) : super(key: key);

  @override
  _SignaturePadState createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  List<Offset> _points = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          _points.add(renderBox.globalToLocal(details.globalPosition));
        });
      },
      onPanEnd: (details) {
        widget.onDrawEnd(_points);
      },
      child: Container(
        color: Colors.transparent, // Needed to capture touches
        child: CustomPaint(
          painter: _SignaturePainter(_points, widget.strokeColor, widget.strokeWidth),
          size: Size.infinite,
        ),
      ),
    );
  }

  void clear() {
      setState(() {
          _points = [];
      });
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  _SignaturePainter(this.points, this.color, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
