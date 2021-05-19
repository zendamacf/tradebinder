import 'dart:async';
import 'package:dio/dio.dart';
import 'package:tradebinder/config.dart';
import 'package:tradebinder/model/magiccard.dart';

class Api {
  static Future<dynamic> _get(String endpoint, {Map<String, dynamic>? params}) async {
    final options = BaseOptions(
      baseUrl: 'https://cardscraper.kalopsia.dev/api/',
      headers: { 'X-API-KEY': await Config.apiKey }
    );

    final dio = Dio(options);
    final response = await dio.request(endpoint, queryParameters: params);
    if (response.statusCode == 200) {
      final data = response.data;
      return data;
    }
  }

  static Future<Map?> getCardPage(String? cursor) async {
    var res = await (Api._get('cards', params: {
      'cursor': cursor,
      'limit': 2500  // Maximum API will allow
    }) as FutureOr<Map<dynamic, dynamic>?>);
    return res;
  }

  static Future<List<MagicCard>> getNewCards(String? cursor) async {
    // Explicitly declare, as otherwise it assumes List<dynamic>
    // ignore: omit_local_variable_types
    List<MagicCard> cards = [];

    while (true) {
      final res = await (getCardPage(cursor) as FutureOr<Map<dynamic, dynamic>>);
      final newCards = res['data'].map<MagicCard>((r) => MagicCard.fromMap(r)).toList();
      cards += newCards;
      print('Fetched ${newCards.length} cards using cursor $cursor');
      cursor = res['cursor'];
      if (cursor == null) break;  // No more pages
      print('New cursor ${res['cursor']}');
    }
    return cards;
  }

  static Future<Map?> getPrice(cardid) async {
    var res = await (Api._get('pricing/$cardid') as FutureOr<Map<dynamic, dynamic>?>);
    return res;
  }
}