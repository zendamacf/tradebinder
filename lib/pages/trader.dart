import 'package:flutter/material.dart';
import 'package:tradebinder/image.dart';
import 'package:tradebinder/model/card.dart';
import 'package:tradebinder/utils.dart';


class TradePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trade Binder'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            Expanded(child: TradeList()),
            Expanded(child: TradeList()),
          ],
        )
      )
    );
  }
}


class TradeList extends StatefulWidget {
  @override
  _TradeListState createState() => _TradeListState();
}

class _TradeListState extends State<TradeList> {
  final newCard = MagicCard.fromMap({
      'id': 1563,
      'collectornumber': '184',
      'name': 'Eerie Ultimatum',
      'rarity': 'R',
      'type': 'Sorcery',
      'power': null,
      'toughness': null,
      'oracletext': 'Return any number of permanent cards with different names from your graveyard to the battlefield.',
      'flavortext': '<em>"The ground under our feet is a record of every slight against the world, to be avenged at a time of its choosing." -Gavi, nest warden</em>',
      'url': 'https://store.tcgplayer.com/magic/ikoria-lair-of-behemoths/eerie-ultimatum',
      'imageurl': 'https://6d4be195623157e28848-7697ece4918e0a73861de0eb37d08968.ssl.cf1.rackcdn.com/212551_200w.jpg',
      'setname': 'Ikoria: Lair of Behemoths',
  });
  final List<MagicCard> cards = [];
  double total;

  @override
  void initState() {
    super.initState();
    _recalulateTotal();
  }

  _addCard() async {
    this.cards.add(newCard);
    await newCard.refreshPrice();
    print('Added a card');
    _recalulateTotal();
  }

  _recalulateTotal() {
    final double sum = this.cards.fold(0, (previousValue, element) => previousValue + element.price * element.quantity);
    setState(() { this.total = sum; });
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: this.cards.length,
      itemBuilder: (BuildContext context, int index) {
        var card = cards[index];
        return ListTile(
          title: Text(card.name),
          subtitle: Text('${card.quantity} x ${Utils.formatMoney(card.price)}'),
          leading: new RemoteImage(card.imageurl),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.25)
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: RaisedButton(
              onPressed: _addCard,
              child: Text('Add Card'),
              color: Colors.indigoAccent,
            )
          ),
          Container(
            child: Text('Total: ${Utils.formatMoney(this.total)}')
          ),
          Expanded(
            child: _buildList(context)
          )
        ],
      )
    );
  }
}