import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class Config {
  static String get pricePoint {
    return 'mid';
  }

  static Future<String> get apiKey async {
    return json.decode(await rootBundle.loadString('assets/secret.json'))['api_key'];
  }
}
