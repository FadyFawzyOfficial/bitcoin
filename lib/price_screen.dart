//! Instead of incorporating the entire io library, I'm going to say only "SHOW"
//! me the Platform Class.
import 'dart:io' show Platform;

import 'package:bitcoin/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  PriceScreenState createState() => PriceScreenState();
}

class PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  String currencyEquivalent = '?';

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
      double lastPrice =
          await CoinData().getCoinData(currency: selectedCurrency);
      setState(() {
        currencyEquivalent = lastPrice.toStringAsFixed(0);
      });
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: Text(
                  '1 BTC = $currencyEquivalent $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
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
