import 'dart:convert';

import 'package:http/http.dart';

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

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinApiKey = 'D4265300-3534-4CCF-AFED-B89FF204C2AD';
const coinApiHost = 'rest.coinapi.io';
const coinApiPath = '/v1/exchangerate/BTC/';

class CoinData {
  Future<double> getCoinData({required String currency}) async {
    final response = await get(
      Uri.https(coinApiHost, '$coinApiPath' '$currency'),
      headers: {'X-CoinAPI-Key': coinApiKey},
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['rate'] as double;
    } else {
      print(response.statusCode);
      //Optional: throw an error if our request fails.
      throw 'Problem with the get request';
    }
  }
}
