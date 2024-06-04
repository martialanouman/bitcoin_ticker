import "dart:convert";

import "package:http/http.dart" as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = ['BTC', 'ETH', 'LTC'];

const apiKey = ''; // See -> https://coinapi.io
const exchangeRateBaseUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future<CoinExchangeRate> getExchangeRate(String from, String to) async {
    var response = await http.get(Uri.parse('$exchangeRateBaseUrl/$from/$to'),
        headers: {'Accept': 'application/json', 'X-CoinAPI-Key': apiKey});

    if (response.statusCode != 200) throw response.statusCode;

    final json = jsonDecode(response.body);
    return CoinExchangeRate.fromJson(json);
  }
}

class CoinExchangeRate {
  late final String from;
  late final String to;
  late final double rate;

  CoinExchangeRate({required this.from, required this.to, required this.rate});

  factory CoinExchangeRate.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'asset_id_base': String from,
        'asset_id_quote': String to,
        'rate': double rate
      } =>
        CoinExchangeRate(from: from, to: to, rate: rate),
      _ => throw const FormatException("Can not parse exchange data"),
    };
  }

  @override
  String toString() {
    return """
from: $from
to: $to
rate: $rate
""";
  }
}
