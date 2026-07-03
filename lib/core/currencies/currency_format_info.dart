class CurrencyFormatInfo {
  const CurrencyFormatInfo({
    required this.code,
    required this.name,
    required this.symbol,
    required this.decimalDigits,
    required this.number,
    required this.namePlural,
    required this.thousandsSeparator,
    required this.decimalSeparator,
    required this.spaceBetweenAmountAndSymbol,
    required this.symbolOnLeft,
    this.flag,
  });

  final String code;
  final String name;
  final String symbol;
  final String? flag;
  final int decimalDigits;
  final int number;
  final String namePlural;
  final String thousandsSeparator;
  final String decimalSeparator;
  final bool spaceBetweenAmountAndSymbol;
  final bool symbolOnLeft;
}
