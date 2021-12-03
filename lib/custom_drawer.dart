import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomDrawer extends StatefulWidget {
  final Widget child;

  const CustomDrawer({Key? key, required this.child}) : super(key: key);

  static CustomDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<CustomDrawerState>()!;

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDurationMill = Duration(milliseconds: 250);
  static const double maxSlide = 300.0;
  static const double minDragStartEdge = 60;
  static const double maxDragStartEdge = maxSlide - 16;

  final Widget _myDrawer = _MyDrawer();

  late AnimationController _animationController;
  bool _canBeDragged = false;

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
    return MaterialApp(
      home: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: AnimatedBuilder(
            animation: _animationController,
            child: widget.child,
            builder: (context, child) {
              double dx = (maxSlide * _animationController.value) -
                  MediaQuery.of(context).size.width;

              log(dx.toString());
              return Material(
                color: Colors.blueGrey,
                child: Stack(
                  children: [
                    Transform.translate(
                      offset: Offset(
                          (maxSlide * _animationController.value) -
                              MediaQuery.of(context).size.width,
                          0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(
                              math.pi / 2 * (1 - _animationController.value)),
                        alignment: Alignment.centerRight,
                        child: _myDrawer,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(maxSlide * _animationController.value, 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(-math.pi / 2 * _animationController.value),
                        alignment: Alignment.centerLeft,
                        child: child,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  //Here we evaluate if we can open or close the drawer
  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animationController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight = _animationController.isCompleted &&
        details.globalPosition.dx > maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  //Here we calculate how spread is the gesture
  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / maxSlide;
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  void close() => _animationController.reverse();

  void open() => _animationController.forward();

  void toggleDrawer() => _animationController.isCompleted ? close() : open();
}

class _MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueAccent,
      child: SafeArea(
        child: Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'My gorgeous\ndrawer',
                  style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.w200,
                      color: Colors.white),
                ),
              ),
              ListTileToRight(text: 'News', iconData: Icons.new_releases),
              ListTileToRight(text: 'Favourites', iconData: Icons.star),
              ListTileToRight(text: 'Map', iconData: Icons.map),
              ListTileToRight(text: 'Settings', iconData: Icons.settings),
              ListTileToRight(text: 'Profile', iconData: Icons.person),
            ],
          ),
        ),
      ),
    );
  }
}

class ListTileToRight extends StatelessWidget {
  ListTileToRight({Key? key, required this.text, this.iconData})
      : super(key: key);

  String text;
  IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Container(),
          ),
          Text(text),
        ],
      ),
      trailing: Icon(iconData),
    );
  }
}
