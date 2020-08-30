import 'dart:async';
import 'package:tradebinder/cardfetcher.dart';
import 'package:tradebinder/db.dart';
import 'package:tradebinder/model/magiccard.dart';


class MagicCardBloc {
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
    await CardFetcher().run();
    await getCards();
  }
}
