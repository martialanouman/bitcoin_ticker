import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _selectedCurrency = 'AUD';
  final CoinData _coinData = CoinData();
  List<CoinExchangeRate> exchangesRate = [];
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    getExchangesRate(_selectedCurrency);
  }

  void getExchangesRate(String to) async {
    setState(() {
      isFetching = true;
      _selectedCurrency = to;
    });

    final List<CoinExchangeRate> rates = [];

    for (String crypto in cryptoList) {
      try {
        final rate = await _coinData.getExchangeRate(crypto, _selectedCurrency);
        rates.add(rate);
      } catch (e) {
        print(e);
      }
    }

    setState(() {
      exchangesRate = rates;
      isFetching = false;
    });
  }

  void _onSelected(String? value) => getExchangesRate(value!);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: exchangesRate
                .map(
                  (exchRate) => ExchangeRateCard(
                    fromCurrency: exchRate.from,
                    rate: isFetching ? '?' : exchRate.rate.round().toString(),
                    targetCurrency: _selectedCurrency,
                  ),
                )
                .toList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: DropdownMenu(
              dropdownMenuEntries: currenciesList
                  .map<DropdownMenuEntry<String>>(
                    (currency) =>
                        DropdownMenuEntry(value: currency, label: currency),
                  )
                  .toList(),
              initialSelection: _selectedCurrency,
              onSelected: _onSelected,
              enabled: !isFetching,
              menuHeight: 200.0,
            ),
          ),
        ],
      ),
    );
  }
}

class ExchangeRateCard extends StatelessWidget {
  const ExchangeRateCard(
      {super.key,
      required this.rate,
      required this.targetCurrency,
      required this.fromCurrency});

  final String? rate;
  final String targetCurrency;
  final String fromCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $fromCurrency = $rate $targetCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
