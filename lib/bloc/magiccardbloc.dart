import 'dart:async';
import 'package:hashids2/hashids2.dart';
import 'package:tradebinder/api.dart';
import 'package:tradebinder/db.dart';
import 'package:tradebinder/model/magiccard.dart';
import 'package:tradebinder/notification.dart';


class MagicCardBloc {
  int notificationId = 0;

  MagicCardBloc() {
    getCards();
  }
  final cardController = StreamController<List<MagicCard>>.broadcast();
  Stream<List<MagicCard>> get cards => cardController.stream;

  void dispose() {
    cardController.close();
  }

  void getCards() async {
    cardController.sink.add(await DB.getAllCards());
  }

  void synchronize() async {
    final notification = Notification(
      notificationId,
      'Trade Binder',
      'Checking for card updates.',
      persist: true
    );

    var prevCards = await DB.getAllCards();
    String cursor;
    if (prevCards.isNotEmpty) {
      prevCards.sort((a, b) => a.id.compareTo(b.id));
      final lastid = prevCards[prevCards.length - 1].id;  // More efficient than .last property
      final hashids = HashIds();
      cursor = hashids.encode(lastid);
    }

    var cards = await Api.getNewCards(cursor);
    // Store the cards in the database
    final count = await DB.addCards(cards);
    print('Finished inserting $count new cards of ${cards.length}');

    notification.cancel();

    // Show any new cards added
    if (count > 0) {
      Notification(
        notificationId,
        'Trade Binder',
        'Added $count new cards.'
      );
    }

    await getCards();
  }
}
