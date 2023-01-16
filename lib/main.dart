import 'package:flutter/material.dart';
import 'package:state_management_triple/presenter_with_triple/pages/home_page_with_triple.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePageWithTriple(),
    );
  }
}
