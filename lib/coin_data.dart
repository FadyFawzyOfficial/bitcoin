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
const coinApiPath = '/v1/exchangerate/';
const coinApiHeaders = {'X-CoinAPI-Key': coinApiKey};
const rateKey = 'rate';

class CoinData {
  Future<Map<String, String>> getCoinData({required String currency}) async {
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      final response = await get(
        Uri.https(coinApiHost, '$coinApiPath' '$crypto/' '$currency'),
        headers: coinApiHeaders,
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        double cryptoPrice = decodedData[rateKey];
        cryptoPrices[crypto] = cryptoPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        //Optional: throw an error if our request fails.
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
