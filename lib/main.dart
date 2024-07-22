import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_views/src/native_view_example.dart';
import 'package:native_views/src/native_view_ios.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native View Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget getTargetPlatformView() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const NativeViewExample();

      case TargetPlatform.iOS:
        return const NativeViewIos();

      default:
        throw UnsupportedError("Unsupported platform View");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getTargetPlatformView(),
    );
  }
}
