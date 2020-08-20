import 'package:flutter/material.dart';
import 'package:tradebinder/cardfetcher.dart';
import 'package:tradebinder/pages/splash.dart';

void main() {
  runApp(TradeBinder());
}

class TradeBinder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check for any new cards from API
    CardFetcher().run();

    return MaterialApp(
      title: 'Trade Binder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
