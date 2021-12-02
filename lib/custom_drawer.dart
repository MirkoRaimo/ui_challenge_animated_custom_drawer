import 'dart:developer';

import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDurationMill = Duration(milliseconds: 250);

  final Widget _myDrawer = Container(color: Colors.blue);
  final Widget _myChild = Container(color: Colors.yellow);

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDurationMill,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggle() => _animationController.isDismissed
      ? _animationController.forward()
      : _animationController.reverse();

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _maxSlide = _width * 0.6;

    return MaterialApp(
      home: GestureDetector(
        onTap: toggle,
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              double slide = _maxSlide * _animationController.value;
              double scale = 1 - (_animationController.value * 0.3);

              return Stack(
                children: [
                  _myDrawer,
                  Transform(
                    transform: Matrix4.identity()
                      ..translate(slide)
                      ..scale(scale),
                    alignment: Alignment.centerLeft,
                    child: _myChild,
                  )
                ],
              );
            }),
      ),
    );
  }
}
