import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/core/view/widgets/account_filter_chips.dart';
import 'package:ledger_app/features/analytics/view/cubit/analytics_cubit.dart';
import 'package:ledger_app/features/analytics/view/widgets/analytics_pie_chart.dart';
import 'package:ledger_app/features/analytics/view/widgets/analytics_summary_cards.dart';
import 'package:ledger_app/features/analytics/view/widgets/category_list.dart';
import 'package:ledger_app/features/analytics/view/widgets/month_year_selector.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String? _selectedAccountId;
  DateTime _selectedDate = DateTime.now();
  bool _showPredictions = true;

  void _onAccountSelected(String? accountId) {
    setState(() {
      _selectedAccountId = accountId;
    });
    unawaited(context.read<AnalyticsCubit>().loadForecasts(accountId: accountId));
  }

  void _onPreviousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
    });
  }

  void _onNextMonth() {
    final now = DateTime.now();
    if (_selectedDate.year == now.year && _selectedDate.month == now.month) {
      return;
    }
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
    });
  }

  void _onTogglePredictions(bool value) {
    setState(() {
      _showPredictions = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final isCurrentMonth = _selectedDate.year == now.year && _selectedDate.month == now.month;
    final displayPredictions = isCurrentMonth && _showPredictions;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.analyticsAndForecast),
      ),
      child: SafeArea(
        child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
          builder: (context, state) {
            final isInitialLoad = state.isLoading && state.accounts.isEmpty && state.forecasts.isEmpty;

            if (isInitialLoad) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final monthTransactions = state.transactions.where((t) {
              return t.date.year == _selectedDate.year && t.date.month == _selectedDate.month;
            }).toList();

            if (state.accounts.isEmpty && monthTransactions.isEmpty && state.forecasts.isEmpty) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: MonthYearSelector(
                      currentDate: _selectedDate,
                      onPrevious: _onPreviousMonth,
                      onNext: _onNextMonth,
                    ),
                  ),
                  Expanded(child: Center(child: Text(l10n.noDataAvailable))),
                ],
              );
            }

            final incomeRows = <CategoryRowData>[];
            final expenseRows = <CategoryRowData>[];

            double totalIncome = 0;
            double totalOutcome = 0;
            double totalPredicted = 0;

            final incomeTotals = <String, double>{};
            for (final t in monthTransactions) {
              final category = state.categories.cast<Category?>().firstWhere(
                (c) => c?.id == t.categoryId,
                orElse: () => null,
              );

              if (category == null || category.isTechnical) continue;

              if (category.type == CategoryType.income || (category.type == CategoryType.any && t.amount > 0)) {
                incomeTotals[category.id] = (incomeTotals[category.id] ?? 0) + t.amount;
              }
            }

            for (final entry in incomeTotals.entries) {
              if (entry.value > 0) {
                final category = state.categories.firstWhere((c) => c.id == entry.key);
                incomeRows.add(
                  CategoryRowData(
                    category: category,
                    currentSpent: entry.value,
                  ),
                );
                totalIncome += entry.value.round();
              }
            }

            if (isCurrentMonth) {
              for (final f in state.forecasts) {
                final category = state.categories.cast<Category?>().firstWhere(
                  (c) => c?.id == f.categoryId,
                  orElse: () => null,
                );

                if (category == null || category.isTechnical) continue;

                if (category.type == CategoryType.expense || category.type == CategoryType.any) {
                  expenseRows.add(
                    CategoryRowData(
                      category: category,
                      currentSpent: f.currentSpent,
                      predictedSpend: f.predictedSpend,
                    ),
                  );
                  totalOutcome += f.currentSpent.round();
                  if (displayPredictions) {
                    totalPredicted += f.predictedSpend.round();
                  }
                }
              }
            } else {
              final expenseTotals = <String, double>{};
              for (final t in monthTransactions) {
                final category = state.categories.cast<Category?>().firstWhere(
                  (c) => c?.id == t.categoryId,
                  orElse: () => null,
                );

                if (category == null || category.isTechnical) continue;

                if (category.type == CategoryType.expense || (category.type == CategoryType.any && t.amount < 0)) {
                  expenseTotals[category.id] = (expenseTotals[category.id] ?? 0) + t.amount.abs();
                }
              }
              for (final entry in expenseTotals.entries) {
                if (entry.value > 0) {
                  final category = state.categories.firstWhere((c) => c.id == entry.key);
                  expenseRows.add(
                    CategoryRowData(
                      category: category,
                      currentSpent: entry.value,
                    ),
                  );
                  totalOutcome += entry.value.round();
                }
              }
            }

            incomeRows.sort((a, b) => b.currentSpent.compareTo(a.currentSpent));
            expenseRows.sort((a, b) => b.currentSpent.compareTo(a.currentSpent));

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: MonthYearSelector(
                          currentDate: _selectedDate,
                          onPrevious: _onPreviousMonth,
                          onNext: _onNextMonth,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: AccountFilterChips(
                          accounts: state.accounts,
                          selectedAccountId: _selectedAccountId,
                          onAccountSelected: _onAccountSelected,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AnalyticsSummaryCards(
                          income: totalIncome,
                          outcome: totalOutcome,
                          predicted: displayPredictions ? totalPredicted : null,
                        ),
                      ),
                    ),
                    if (displayPredictions)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.info_circle,
                                size: 16,
                                color: CupertinoColors.systemGrey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.predictionWarning,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: AnalyticsPieChart(data: expenseRows),
                      ),
                    ),
                    if (expenseRows.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.expensesTitle,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              if (isCurrentMonth)
                                Row(
                                  children: [
                                    Text(
                                      l10n.prediction,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    CupertinoSwitch(
                                      value: _showPredictions,
                                      onChanged: _onTogglePredictions,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CategoryList(
                            rows: expenseRows,
                            showPredictions: displayPredictions,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    ],
                    if (incomeRows.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            l10n.incomeTitle,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CategoryList(
                            rows: incomeRows,
                            showPredictions: false,
                          ),
                        ),
                      ),
                    ],
                    if (expenseRows.isEmpty && incomeRows.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(child: Text(l10n.noCategoryData)),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
                if (state.isLoading && !isInitialLoad)
                  Positioned.fill(
                    child: ColoredBox(
                      color: CupertinoColors.systemBackground.resolveFrom(context).withValues(alpha: 0.5),
                      child: const Center(child: CupertinoActivityIndicator()),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
