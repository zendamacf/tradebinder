import 'package:dio/dio.dart';
import 'package:tradebinder/config.dart';
import 'package:tradebinder/model/card.dart';

class Api {
  static Future<dynamic> _get(String endpoint, {Map<String, dynamic> params}) async {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://cardscraper.kalopsia.dev/api/',
      headers: { 'X-API-KEY': await Config.apiKey }
    );

    Dio dio = Dio(options);
    final Response response = await dio.request(endpoint, queryParameters: params);
    if (response.statusCode == 200) {
      final data = response.data;
      return data;
    }
  }

  static getCardPage(int page) async {
    Map res = await Api._get('cards', params: {
      'page': page,
      'limit': 2500  // Maximum API will allow
    });
    return res;
  }

  static Future<List<MagicCard>> getAllCards() async {
    List<MagicCard> cards = [];
    int page = 1;
    // Some arbitrary large number that should be bigger
    // than the number of pages
    int pageCount = 999999999999999;

    // Loop through pages until we hit the end
    while (page < pageCount){
      Map res = await getCardPage(page);
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