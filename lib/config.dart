import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class Config {
  static const DBFILE = 'tradebinder.db';
  static const SCHEMAVERSION = 1;

  static String get pricePoint {
    return 'mid';
  }

  static Future<String> get apiKey async {
    return json.decode(await rootBundle.loadString('assets/secret.json'))['api_key'];
  }
}
