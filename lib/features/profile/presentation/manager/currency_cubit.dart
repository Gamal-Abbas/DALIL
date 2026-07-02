import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../../core/constants/cash.dart';
import '../../data/repositories/currency_repo.dart';

class CurrencyCubit extends HydratedCubit<String> {
  final ICurrencyRepo _repo;
  double _exchangeRate = 1.0;

  CurrencyCubit(this._repo) : super('EGP');

  Future<void> changeCurrency(String currency) async {
    if (currency == 'EGP') {
      _exchangeRate = 1.0;
    } else {
      _exchangeRate = await _repo.getExchangeRate(currency);
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await cash.pref.setString('currency_$uid', currency);
    }

    emit(currency);
  }

  Future<void> loadCurrency() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final saved = cash.pref.getString('currency_$uid') ?? 'EGP';
    await changeCurrency(saved);
  }

  String convert(double priceInEGP) {
    final converted = priceInEGP * _exchangeRate;
    return '${converted.toStringAsFixed(2)} $state';
  }

  @override
  String? fromJson(Map<String, dynamic> json) => json['currency'] as String?;

  @override
  Map<String, dynamic>? toJson(String state) => {'currency': state};
}