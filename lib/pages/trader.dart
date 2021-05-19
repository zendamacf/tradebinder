import 'package:flutter/material.dart';
import 'package:tradebinder/bloc/magiccardbloc.dart';
import 'package:tradebinder/model/magiccard.dart';
import 'package:tradebinder/utils.dart';
import 'package:tradebinder/widgets/cardtile.dart';
import 'package:tradebinder/widgets/image.dart';
import 'package:tradebinder/widgets/menu.dart';


class TradePage extends StatefulWidget {
  @override
  TradePageState createState() => TradePageState();
}


class TradePageState extends State<TradePage> {
  final bloc = MagicCardBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.synchronize();

    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text('Trade Binder'),
        actions: <Widget>[
          StreamBuilder(
            stream: bloc.cards,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<MagicCard>? cardList = snapshot.data;
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
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: RemoteImage('https://tcgplayer-cdn.tcgplayer.com/product/212551_400w.jpg')
                ),
              ], 
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: TradeList()),
                  Expanded(child: TradeList()),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}


class CardSearchDelegate extends SearchDelegate<MagicCard?> {
  final List<MagicCard>? cardList;

  CardSearchDelegate(this.cardList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    // Pass through the app's theme
    final theme = Theme.of(context);
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
      ? cardList!
      : cardList!.where((card) => card.name!.toLowerCase().contains(query.toLowerCase())).toList();
    
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
      'imageurl': 'https://tcgplayer-cdn.tcgplayer.com/product/212551_400w.jpg',
      'setname': 'Ikoria: Lair of Behemoths',
      'setcode': 'IKO'
  });
  final List<MagicCard> cards = [];
  double? total;

  @override
  void initState() {
    super.initState();
    _recalulateTotal();
  }

  void _addCard() async {
    final existing = cards.where((card) => card.id == newCard.id).toList();
    if (existing.isNotEmpty) {
      final index = cards.indexOf(existing[0]);
      existing[0].quantity++;
      cards[index] = existing[0];
    } else {
      cards.add(newCard);
    }
    await newCard.refreshPrice();
    print('Added a card');
    _recalulateTotal();
  }

  void _recalulateTotal() {
    final sum = cards.fold(0.0, (dynamic previousValue, element) => previousValue + element.price! * element.quantity);
    setState(() { total = sum; });
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (BuildContext context, int index) {
        return CardTile(cards[index]);
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
            child: ElevatedButton(
              onPressed: _addCard,
              child: Text('Add Card'),
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