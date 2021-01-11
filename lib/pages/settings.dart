import 'package:flutter/material.dart';
import 'package:tradebinder/db.dart';
import 'package:tradebinder/pages/trader.dart';
import 'package:tradebinder/widgets/menu.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  void clearDatabase() {
    // Remove all cards, then redirect to trigger a resync
    DB.deleteAllCards().then((value) => {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => TradePage()
        ),
        (route) => false
      )
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      body: ListView(
        children: [
          ListTile(
            title: Text('Clear Card Database'),
            onTap: () => clearDatabase(),
          )
        ],
      ),
    );
  }
}