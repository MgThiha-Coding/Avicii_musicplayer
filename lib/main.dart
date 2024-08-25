import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:avicii_/screen/home.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}


class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MusicPlayerWidget(),
    );
  }
}
