import 'package:dio/dio.dart';

abstract class ICurrencyRepo {
  Future<double> getExchangeRate(String targetCurrency);
}

class ExchangeRateRepo implements ICurrencyRepo {
  final _dio = Dio();

  @override
  Future<double> getExchangeRate(String targetCurrency) async {
    try {
      final response = await _dio.get(
        'https://open.er-api.com/v6/latest/EGP',
      );
      return (response.data['rates'][targetCurrency] as num).toDouble();
    } catch (e) {
      throw e.toString();
    }
  }
}