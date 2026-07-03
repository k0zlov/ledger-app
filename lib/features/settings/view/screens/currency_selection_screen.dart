import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/currencies/currencies.dart';
import 'package:ledger_app/core/currencies/currency_format_info.dart';
import 'package:ledger_app/core/localization/localization_build_context_x.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';

class CurrencySelectionScreen extends StatefulWidget {
  const CurrencySelectionScreen({
    this.selectedCurrency,
    super.key,
  });

  final String? selectedCurrency;

  @override
  State<CurrencySelectionScreen> createState() => _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  final TextEditingController _searchController = TextEditingController();

  late final List<CurrencyFormatInfo> _allCurrencies;
  List<CurrencyFormatInfo> _filteredCurrencies = [];

  @override
  void initState() {
    super.initState();
    _allCurrencies = currencies.values.toList();
    _filteredCurrencies = _allCurrencies;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toUpperCase();
    setState(() {
      _filteredCurrencies = _allCurrencies.where((c) {
        return c.code.contains(query) || c.name.toUpperCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar:  CupertinoNavigationBar(
        middle: Text(l10n.selectCurrency),
        previousPageTitle: l10n.backButton,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: l10n.searchCurrencies,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCurrencies.length,
                itemBuilder: (context, index) {
                  final currencyInfo = _filteredCurrencies[index];
                  final isSelected = currencyInfo.code == widget.selectedCurrency;

                  return CupertinoListTile(
                    title: Text('${currencyInfo.code} - ${currencyInfo.name}'),
                    subtitle: Text(currencyInfo.symbol),
                    trailing: isSelected
                        ? const Icon(CupertinoIcons.check_mark, color: CupertinoColors.activeBlue)
                        : null,
                    onTap: () => context.navigator.pop(currencyInfo.code),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
