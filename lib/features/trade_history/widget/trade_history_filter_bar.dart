import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';

class TradeHistoryFilterBar extends StatelessWidget {
  final String selectedPeriod;
  final String selectedType;
  final String selectedSort;
  final ValueChanged<String> onPeriodChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onSortChanged;
  final VoidCallback? onCustomDateTap;

  const TradeHistoryFilterBar({
    super.key,
    required this.selectedPeriod,
    required this.selectedType,
    required this.selectedSort,
    required this.onPeriodChanged,
    required this.onTypeChanged,
    required this.onSortChanged,
    this.onCustomDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 600;

          if (isCompact) {
            // 모바일: 세로 배치
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        'Period',
                        selectedPeriod,
                        _periodOptions,
                        onPeriodChanged,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterDropdown(
                        'Type',
                        selectedType,
                        _typeOptions,
                        onTypeChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildFilterDropdown(
                  'Sort',
                  selectedSort,
                  _sortOptions,
                  onSortChanged,
                ),
              ],
            );
          } else {
            // 데스크톱: 가로 배치
            return Row(
              children: [
                Expanded(
                  child: _buildFilterDropdown(
                    'Period',
                    selectedPeriod,
                    _periodOptions,
                    onPeriodChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFilterDropdown(
                    'Type',
                    selectedType,
                    _typeOptions,
                    onTypeChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFilterDropdown(
                    'Sort',
                    selectedSort,
                    _sortOptions,
                    onSortChanged,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String selectedValue,
    List<String> options,
    ValueChanged<String> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: AppTheme.secondaryText,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.secondaryText,
                size: 18,
              ),
              style: GoogleFonts.montserrat(
                color: AppTheme.primaryText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              dropdownColor: AppTheme.surfaceColor,
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.montserrat(
                      color: AppTheme.primaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue == 'Custom Date' && onCustomDateTap != null) {
                  onCustomDateTap!();
                } else if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  static const List<String> _periodOptions = [
    'Today',
    'This Week',
    'This Month',
    'Last Month',
    '3 Months',
    'All',
    'Custom Date',
  ];

  static const List<String> _typeOptions = [
    'All',
    'Profit Only',
    'Loss Only',
    'Break Even',
  ];

  static const List<String> _sortOptions = [
    'Date',
    'Amount (High)',
    'Amount (Low)',
    'Win Rate',
  ];
}
