import 'package:dio/dio.dart';
import 'package:tradebinder/config.dart';
import 'package:tradebinder/model/card.dart';

class Api {
  static Future<dynamic> _get(String endpoint, {Map<String, dynamic> params}) async {
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

  static Future<Map> getCardPage(int page) async {
    Map res = await Api._get('cards', params: {
      'page': page,
      'limit': 2500  // Maximum API will allow
    });
    return res;
  }

  static Future<List<MagicCard>> getAllCards() async {
    // Explicitly declare, as otherwise it assumes List<dynamic>
    // ignore: omit_local_variable_types
    List<MagicCard> cards = [];
    var page = 1;
    // Some arbitrary large number that should be bigger
    // than the number of pages
    var pageCount = 999999999999999;

    // Loop through pages until we hit the end
    while (page < pageCount){
      final res = await getCardPage(page);
      cards += res['cards'].map<MagicCard>((r) => MagicCard.fromMap(r)).toList();
      page++;
      pageCount = res['pagecount'];
      print('Fetched page $page of $pageCount');
    }
    return cards;
  }

  static Future<Map> getPrice(cardid) async {
    Map res = await Api._get('pricing/$cardid');
    return res;
  }
}