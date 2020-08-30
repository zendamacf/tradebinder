import 'package:flutter/material.dart';
import 'package:tradebinder/db.dart';
import 'package:tradebinder/image.dart';
import 'package:tradebinder/model/magiccard.dart';
import 'package:tradebinder/utils.dart';


class TradePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trade Binder'),
        actions: <Widget>[
          FutureBuilder(
            future: DB.getAllCards(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<MagicCard> cardList = snapshot.data;
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CardSearchDelegate(cardList),
                    );
                  },
                );
              } else {
                return Container(
                  width: 60.0,
                  height: 20.0,
                  color: Colors.lightGreen,
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
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


class CardSearchDelegate extends SearchDelegate<MagicCard> {
  final List<MagicCard> cardList;

  CardSearchDelegate(this.cardList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    // Pass through the app's theme
    assert(context != null);
    final theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget buildCardList() {
    final suggestionList = query.isEmpty
      ? cardList
      : cardList.where((card) => card.name.toLowerCase().contains(query.toLowerCase())).toList();
    
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final card = suggestionList[index];
        return ListTile(
          title: Text('${card.id} ${card.name} ${card.setname} [${card.setcode}]'),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildCardList();

  @override
  Widget buildSuggestions(BuildContext context) => buildCardList();
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

  void _addCard() async {
    cards.add(newCard);
    await newCard.refreshPrice();
    print('Added a card');
    _recalulateTotal();
  }

  void _recalulateTotal() {
    final sum = cards.fold(0.0, (previousValue, element) => previousValue + element.price * element.quantity);
    setState(() { total = sum; });
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (BuildContext context, int index) {
        var card = cards[index];
        return ListTile(
          title: Text(card.name),
          subtitle: Text('${card.quantity} x ${Utils.formatMoney(card.price)}'),
          leading: RemoteImage(card.imageurl),
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
            child: Text('Total: ${Utils.formatMoney(total)}')
          ),
          Expanded(
            child: _buildList(context)
          )
        ],
      )
    );
  }
}