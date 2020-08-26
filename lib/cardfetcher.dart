import 'package:tradebinder/api.dart';
import 'package:tradebinder/db.dart';
import 'package:tradebinder/notification.dart';


class CardFetcher {
  int notificationId = 0;

  void run() async {
    final notification = Notification(
      notificationId,
      'Trade Binder',
      'Checking for card updates.'
    );

    var cards = await Api.getAllCards();
    // Store the cards in the database
    await DB.db.addCards(cards);
    print('Finished inserting cards');

    notification.cancel();
  }
}
