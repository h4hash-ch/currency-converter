import 'package:flutter/material.dart';
import 'Services/currency_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  Map<String, String> _currencies = {};
  Map<String, double> _rates = {};
  String? _from;
  String? _to;
  String _result = '';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadCurrenciesAndRates();

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrenciesAndRates() async {
    final currencies = await CurrencyApi.getCurrencies();
    final rates = await CurrencyApi.getRates();

    if (currencies != null && rates != null) {
      setState(() {
        _currencies = currencies;
        _rates = rates;
        _from = _currencies.keys.first;
        _to = _currencies.keys.elementAt(1);
      });
    }
  }

  void _convertCurrency() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || _from == null || _to == null) return;

    final rateFrom = _rates[_from!]!;
    final rateTo = _rates[_to!]!;
    final converted = CurrencyApi.convertManual(
      amount: amount,
      rateFrom: rateFrom,
      rateTo: rateTo,
    );

    setState(() {
      _result = '${converted.toStringAsFixed(2)} $_to';
    });

    _fadeController.forward(from: 0.0);
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _from;
      _from = _to;
      _to = temp;
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = true; // Force dark mode

    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: Text('Currency Converter'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[900],
      ),
      body: _currencies.isEmpty || _rates.isEmpty
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount input card
            Card(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _amountController,
                  keyboardType:
                  TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter Amount',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.attach_money, color: Colors.blue[200]),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Currency selection row
            Row(
              children: [
                Expanded(
                  child: _currencyDropdown(
                    _from,
                        (val) => setState(() => _from = val),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz, size: 32, color: Colors.blue[200]),
                  onPressed: _swapCurrencies,
                ),
                Expanded(
                  child: _currencyDropdown(
                    _to,
                        (val) => setState(() => _to = val),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Convert button
            ElevatedButton(
              onPressed: _convertCurrency,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.blue[300],
                elevation: 4,
              ),
              child: Text(
                'Convert',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            SizedBox(height: 40),

            // Animated result display
            FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Text(
                  _result,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[200],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currencyDropdown(String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      isExpanded: true,
      dropdownColor: Colors.grey[850],
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      items: _currencies.keys
          .map(
            (key) => DropdownMenuItem(
          value: key,
          child: Text(
            '$key - ${_currencies[key]}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
          .toList(),
    );
  }
}
