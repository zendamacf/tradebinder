import 'package:hive/hive.dart';
import 'package:tradebinder/model/magiccard.dart';

class DB {
  static Future<Box<MagicCard>> get cardBox async {
    return await Hive.openBox('cardBox');
  }

  static Future<int> addCards(List<MagicCard> cards) async {
    final box = await cardBox;
    // Explicitly declare, otherwise Hive complains
    // ignore: omit_local_variable_types
    final Map<int?, MagicCard> inserts = {};
    var newCards = 0;

    // Convert to map of records to insert
    cards.forEach((card) {
      if (!box.containsKey(card.id)) newCards++;
      inserts[card.id] = card;
    });
    await box.putAll(inserts);

    return newCards;
  }

  static Future<List<MagicCard>> getAllCards() async {
    final box = await cardBox;
    final cards = box.values.toList();
    cards.sort((a, b) => a.name!.compareTo(b.name!));
    return cards;
  }

  static Future<void> deleteAllCards() async {
    final box = await cardBox;
    await box.clear();
  }
}
