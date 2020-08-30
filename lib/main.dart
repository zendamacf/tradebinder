import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tradebinder/model/magiccard.dart';
import 'package:tradebinder/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final docDirectory = await getApplicationDocumentsDirectory();
  Hive.init(docDirectory.path);
  Hive.registerAdapter(MagicCardAdapter());
  runApp(TradeBinder());
}

class TradeBinder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
