import 'package:hive/hive.dart';
import 'package:tradebinder/model/magiccard.dart';

class DB {
  static Future<Box<MagicCard>> get cardBox async {
    return await Hive.openBox('cardBox');
  }

  static void addCards(List<MagicCard> cards) async {
    final box = await cardBox;
    // TODO: Prevent duplicate inserts
    await box.addAll(cards);
  }

  static Future<List<MagicCard>> getAllCards() async {
    final box = await cardBox;
    final cards = box.values.toList();
    cards.sort((a, b) => a.name.compareTo(b.name));
    return cards;
  }
}
