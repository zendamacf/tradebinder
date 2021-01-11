import 'package:flutter/material.dart';
import 'package:tradebinder/image.dart';
import 'package:tradebinder/model/magiccard.dart';
import 'package:tradebinder/utils.dart';

class CardTile extends StatelessWidget {
  CardTile(this.card);

  final MagicCard card;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(card.name),
      subtitle: Text('${card.quantity} x ${Utils.formatMoney(card.price)} [${card.setcode}]'),
      isThreeLine: true,
      leading: RemoteImage(card.imageurl),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
    );
  }
}