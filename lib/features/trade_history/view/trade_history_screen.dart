import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/trade_history/widget/trade_history_filter_bar.dart';
import 'package:trade_up/features/trade_history/widget/trade_history_list.dart';
import 'package:trade_up/features/trade_history/widget/trade_summary_card.dart';

class TradeHistoryScreen extends ConsumerStatefulWidget {
  static const String routeName = 'history';
  static const String routePath = '/history';

  const TradeHistoryScreen({super.key});

  @override
  ConsumerState<TradeHistoryScreen> createState() => _TradeHistoryScreenState();
}

class _TradeHistoryScreenState extends ConsumerState<TradeHistoryScreen> {
  String selectedPeriod = 'This Month';
  String selectedType = 'All';
  String selectedSort = 'Date';
  DateTime? customStartDate;
  DateTime? customEndDate;

  Future<void> _showCustomDatePicker() async {
    final DateTimeRange? dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: customStartDate != null && customEndDate != null
          ? DateTimeRange(start: customStartDate!, end: customEndDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.accentColor,
              onPrimary: Colors.white,
              surface: AppTheme.surfaceColor,
              onSurface: AppTheme.primaryText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dateRange != null) {
      setState(() {
        customStartDate = dateRange.start;
        customEndDate = dateRange.end;
        selectedPeriod = 'Custom Date';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 헤더
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.history, color: AppTheme.accentColor, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Trading History',
                      style: GoogleFonts.montserrat(
                        color: AppTheme.primaryText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 월간 요약
            SliverToBoxAdapter(child: TradeSummaryCard()),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 필터 바
            SliverToBoxAdapter(
              child: TradeHistoryFilterBar(
                selectedPeriod: selectedPeriod,
                selectedType: selectedType,
                selectedSort: selectedSort,
                onPeriodChanged: (value) {
                  setState(() {
                    selectedPeriod = value;
                  });
                },
                onTypeChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                onSortChanged: (value) {
                  setState(() {
                    selectedSort = value;
                  });
                },
                onCustomDateTap: _showCustomDatePicker,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // 거래 리스트
            SliverToBoxAdapter(
              child: TradeHistoryList(
                period: selectedPeriod,
                type: selectedType,
                sort: selectedSort,
                customStartDate: customStartDate,
                customEndDate: customEndDate,
              ),
            ),

            // 하단 여백
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
