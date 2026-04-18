class CurrencyRatesModel {
  final String name;
  final String symbol;
  final String position;
  final String decimals;
  final String thousandsSep;
  final String decimalsSep;
  final double rate;
  final String currency;


  CurrencyRatesModel({
    required this.name,
    required this.symbol,
    required this.position,
    required this.decimals,
    required this.thousandsSep,
    required this.decimalsSep,
    required this.rate,
    required this.currency,
  });

  @override
bool operator ==(Object other) {
  if (identical(this, other)) return true;
  
  return other is CurrencyRatesModel &&
      other.thousandsSep == thousandsSep &&
      other.decimalsSep == decimalsSep &&
      other.decimals == decimals &&
      other.position == position &&
      other.rate == rate &&
      other.currency == currency &&
      other.symbol == symbol &&
      other.name == name;
}

@override
int get hashCode => 
    symbol.hashCode ^ 
    name.hashCode ^
    position.hashCode ^
    decimals.hashCode ^
    thousandsSep.hashCode ^
    decimalsSep.hashCode ^
    currency.hashCode ^
    rate.hashCode;

@override
String toString() {
  return 'CurrencyRatesModel(name: $name, symbol: $symbol)';
}

  factory CurrencyRatesModel.fromMap(Map<String, dynamic> map) {
    return CurrencyRatesModel(
      name: map['name'] ?? '',
      symbol: map['symbol'] ?? '',
      position: map['position'] ?? '',
      decimals: map['decimals'].toString(),
      thousandsSep: map['thousands_sep'] ?? '',
      decimalsSep: map['decimals_sep'] ?? '',
      currency: map['currency'] ?? '',
      rate: (map['rate'] is int)
          ? (map['rate'] as int).toDouble()
          : (map['rate'] ?? 0.0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol': symbol,
      'position': position,
      'decimals': decimals,
      'thousands_sep': thousandsSep,
      'decimals_sep': decimalsSep,
      'rate': rate,
      'currency': currency,
    };
  }
}
