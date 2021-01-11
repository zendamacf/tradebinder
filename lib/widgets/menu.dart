import 'package:flutter/material.dart';
import 'package:tradebinder/pages/trader.dart';
import 'package:tradebinder/pages/settings.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.swap_horiz),
            title: Text('Trade'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => TradePage()
              )
            ),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History')
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => SettingsPage()
              )
            ),
          )
        ],
      ),
    );
  }
}