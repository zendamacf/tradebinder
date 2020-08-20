import 'package:tradebinder/api.dart';
import 'package:tradebinder/config.dart';
import 'package:tradebinder/utils.dart';

class MagicCard {
  final int id;
  final String collectornumber;
  final String name;
  final String rarity;
  final String type;
  final String power;
  final String toughness;
  final String oracletext;
  final String flavortext;
  final String url;
  final String imageurl;
  final String setname;
  bool foil = false;
  int quantity = 1;
  double price;
  DateTime priceUpdated;

  Future refreshPrice() async {
    final resp = await Api.getPrice(this.id);
    final prices = (this.foil) ? resp['foil'] : resp['normal'];
    this.price = Utils.parseMoney(prices[Config.pricePoint]);
    this.priceUpdated = DateTime.parse(prices['updated']);
  }

  MagicCard({this.id, this.collectornumber, this.name, this.rarity, this.type, this.power, this.toughness, this.oracletext, this.flavortext, this.url, this.imageurl, this.setname});

  factory MagicCard.fromMap(Map<String, dynamic> m) => new MagicCard(
    id: m['id'],
    collectornumber: m['collectornumber'],
    name: m['name'],
    rarity: m['rarity'],
    type: m['type'],
    power: m['power'],
    toughness: m['toughness'],
    oracletext: m['oracletext'],
    flavortext: m['flavourtext'],
    url: m['url'],
    imageurl: m['imageurl'],
    setname: m['setname'],
  );

}