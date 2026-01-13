import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CurrencyApi {
  static const String _baseUrl = 'https://currencyapi.net/api/v1';
  static final String _apiKey = dotenv.env['CURRENCY_API_KEY'] ?? '';

  /// Fetch all supported currencies
  static Future<Map<String, String>?> getCurrencies() async {
    final url = Uri.parse('$_baseUrl/currencies?key=$_apiKey&output=json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['valid'] == true) {
        return Map<String, String>.from(data['currencies']);
      }
    }
    print('Failed to fetch currencies: ${response.body}');
    return null;
  }

  /// Fetch exchange rates relative to a base currency (default USD)
  static Future<Map<String, double>?> getRates({String base = 'USD'}) async {
    final url = Uri.parse('$_baseUrl/rates?key=$_apiKey&base=$base&output=json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['valid'] == true) {
        return Map<String, double>.from(
            data['rates'].map((k, v) => MapEntry(k, (v as num).toDouble())));
      }
    }
    print('Failed to fetch rates: ${response.body}');
    return null;
  }

  /// Convert manually using rates
  static double convertManual({
    required double amount,
    required double rateFrom,
    required double rateTo,
  }) {
    return amount * (rateTo / rateFrom);
  }
}
