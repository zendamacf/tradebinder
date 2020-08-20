import 'package:tradebinder/api.dart';
import 'package:tradebinder/notification.dart';


class CardFetcher {
  int notificationId = 0;

  run() async {
    final notification = new Notification(
      notificationId,
      'Trade Binder',
      'Checking for card updates.'
    );

    var cards = await Api.getAllCards();
    // TODO: Store the cards somewhere
    print(cards.length);

    notification.cancel();
  }
}
