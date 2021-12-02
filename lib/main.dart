import 'package:flutter/material.dart';
import 'package:ui_challenge_animated_custom_drawer/counter_widget.dart';
import 'package:ui_challenge_animated_custom_drawer/custom_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomDrawer(
        child: CounterWidget(appBar: _counterWidgetAppBar()),
      ),
    );
  }

  AppBar _counterWidgetAppBar() {
    return AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => CustomDrawer.of(context).open(),
          );
        },
      ),
      title: const Text("Custom Animated Drawer!"),
    );
  }
}
