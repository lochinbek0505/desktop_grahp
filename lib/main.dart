import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Math Function Graph'),
        ),
        body: MathFunctionGraph(),
      ),
    );
  }
}

class MathFunctionGraph extends StatefulWidget {
  @override
  _MathFunctionGraphState createState() => _MathFunctionGraphState();
}

class _MathFunctionGraphState extends State<MathFunctionGraph> {
  final TextEditingController functionController = TextEditingController();
  String mathFunction = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: functionController,
            decoration: InputDecoration(labelText: 'Enter a mathematical function (e.g., x*x + 3)'),
            onChanged: (value) {
              setState(() {
                mathFunction = value;
              });
            },
          ),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     setState(() {});
        //   },
        //   child: Text('Update Graph'),
        // ),
        Expanded(
          child: Center(
            child: CustomPaint(
              painter: GraphPainter(mathFunction),
              size: Size(850, 540), // Set the desired size of the graph
            ),
          ),
        ),

      ],
    );
  }
}

class GraphPainter extends CustomPainter {
  final String mathFunction;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  GraphPainter(this.mathFunction, {this.minX = -20, this.maxX = 20, this.minY = -13, this.maxY = 13});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final Paint functionPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    final double originX = size.width / 2;
    final double originY = size.height / 2;

    // Draw X-axis
    canvas.drawLine(Offset(0, originY), Offset(size.width, originY), axisPaint);
    // Draw numbers and "x" on X-axis
    for (double x = minX; x <= maxX; x++) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: x.toInt().toString(),
          style: TextStyle(color: Colors.black, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(originX + x * 20 - textPainter.width / 2, originY + 5));

      if (x == maxX || x == minX) {
        final TextPainter xPainter = TextPainter(
          text: TextSpan(
            text: 'x',
            style: TextStyle(color: Colors.red, fontSize: 15),
          ),
          textDirection: TextDirection.ltr,
        );
        xPainter.layout();
        xPainter.paint(canvas, Offset(originX + x * 20 - xPainter.width / 2, originY + 15));
      }
    }

    // Draw Y-axis
    canvas.drawLine(Offset(originX, 0), Offset(originX, size.height), axisPaint);
    // Draw numbers and "x" on Y-axis
    for (double y = minY; y <= maxY; y++) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: y.toInt().toString(),
          style: TextStyle(color: Colors.black, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(originX - 15, originY - y * 20 - textPainter.height / 2));

      if (y == maxY || y == minY) {
        final TextPainter xPainter = TextPainter(
          text: TextSpan(
            text: 'x',
            style: TextStyle(color: Colors.red, fontSize: 15),
          ),
          textDirection: TextDirection.ltr,
        );
        xPainter.layout();
        xPainter.paint(canvas, Offset(originX - 25, originY - y * 20 - xPainter.height / 2));
      }
    }
    // Define your mathematical function
    double evaluateFunction(double x) {
      String expression = mathFunction.replaceAll('x', x.toString());
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      return exp.evaluate(EvaluationType.REAL, cm);
    }

    // Draw the graph by connecting points
    for (double x = minX; x <= maxX; x += 0.01) {
      final double y = evaluateFunction(x);
      if (y >= minY && y <= maxY) {
        final Offset point = Offset(originX + x * 20, originY - y * 20); // Scale for display
        canvas.drawPoints(PointMode.points, [point], functionPaint); // Draw points
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
