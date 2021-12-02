import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final _myDrawer = Container(color: Colors.blue);
  final _myChild = Container(color: Colors.yellow);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          _myDrawer,
          Transform(
            transform: Matrix4.identity()..scale(0.5),
            alignment: Alignment.centerLeft,
            child: _myChild,
          )
        ],
      ),
    );
  }
}
