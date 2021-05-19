import 'package:hive/hive.dart';
import 'package:tradebinder/api.dart';
import 'package:tradebinder/config.dart';
import 'package:tradebinder/utils.dart';

part 'magiccard.g.dart';

@HiveType(typeId: 1)
class MagicCard {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? collectornumber;
  @HiveField(2)
  final String? name;
  @HiveField(3)
  final String? rarity;
  @HiveField(4)
  final String? type;
  @HiveField(5)
  final String? power;
  @HiveField(6)
  final String? toughness;
  @HiveField(7)
  final String? oracletext;
  @HiveField(8)
  final String? flavortext;
  @HiveField(9)
  final String? url;
  @HiveField(10)
  final String? imageurl;
  @HiveField(11)
  final String? setname;
  @HiveField(12)
  final String? setcode;
  bool foil = false;
  int quantity = 1;
  double? price;
  DateTime? priceUpdated;

  Future refreshPrice() async {
    final resp = await Api.getPrice(id);
    final prices = (foil) ? resp!['foil'] : resp!['normal'];
    price = Utils.parseMoney(prices[Config.pricePoint]);
    priceUpdated = DateTime.parse(prices['updated']);
  }

  MagicCard({this.id, this.collectornumber, this.name, this.rarity, this.type, this.power, this.toughness, this.oracletext, this.flavortext, this.url, this.imageurl, this.setname, this.setcode});

  factory MagicCard.fromMap(Map<String, dynamic> m) => MagicCard(
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
    setcode: m['setcode'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'collectornumber': collectornumber,
      'name': name,
      'rarity': rarity,
      'type': type,
      'power': power,
      'toughness': toughness,
      'oracletext': oracletext,
      'flavortext': flavortext,
      'url': url,
      'imageurl': imageurl,
      'setname': setname,
      'setcode': setcode,
    };
  }
}