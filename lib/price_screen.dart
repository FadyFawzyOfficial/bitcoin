//! Instead of incorporating the entire io library, I'm going to say only "SHOW"
//! me the Platform Class.
import 'dart:io' show Platform;

import 'package:bitcoin/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'crypto_card.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  PriceScreenState createState() => PriceScreenState();
}

class PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  bool isWaiting = false;
  Map<String, String> cryptoPrices = {};

  DropdownButton<String> get currencyAndroidDropDown {
    List<DropdownMenuItem<String>> currencyItems = [];
    for (String currency in currenciesList) {
      currencyItems.add(
        DropdownMenuItem(
          value: currency,
          child: Text(currency),
        ),
      );
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencyItems,
      onChanged: (value) => setState(() {
        if (value != null) selectedCurrency = value;
        getCurrencyEquivalent();
      }),
    );
  }

  CupertinoPicker get currencyIosPicker {
    List<Text> currencyItems = [];
    for (String currency in currenciesList) {
      currencyItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (int index) => setState(() {
        selectedCurrency = currenciesList[index];
        getCurrencyEquivalent();
      }),
      children: currencyItems,
    );
  }

  void getCurrencyEquivalent() async {
    try {
      isWaiting = true;
      Map<String, String> data =
          await CoinData().getCoinData(currency: selectedCurrency);

      isWaiting = false;
      setState(() => cryptoPrices = data);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrencyEquivalent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CryptoCard(
            cryptoCurrency: cryptoList[0],
            currencyEquivalent: isWaiting ? '?' : cryptoPrices[cryptoList[0]]!,
            selectedCurrency: selectedCurrency,
          ),
          CryptoCard(
            cryptoCurrency: cryptoList[1],
            currencyEquivalent: isWaiting ? '?' : cryptoPrices[cryptoList[1]]!,
            selectedCurrency: selectedCurrency,
          ),
          CryptoCard(
            cryptoCurrency: cryptoList[2],
            currencyEquivalent: isWaiting ? '?' : cryptoPrices[cryptoList[2]]!,
            selectedCurrency: selectedCurrency,
          ),
          const Spacer(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? currencyIosPicker : currencyAndroidDropDown,
          ),
        ],
      ),
    );
  }
}
