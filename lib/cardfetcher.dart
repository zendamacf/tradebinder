import 'package:tradebinder/api.dart';
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
    // TODO: Store the cards somewhere
    print(cards.length);

    notification.cancel();
  }
}
