import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/tools/view/calculators/position_size_calculator_screen.dart';
import 'package:trade_up/features/tools/widget/calculator_input_field.dart';
import 'package:trade_up/features/tools/widget/calculator_result_card.dart';

class ProfitLossCalculatorScreen extends ConsumerStatefulWidget {
  const ProfitLossCalculatorScreen({super.key});

  @override
  ConsumerState<ProfitLossCalculatorScreen> createState() =>
      _ProfitLossCalculatorScreenState();
}

class _ProfitLossCalculatorScreenState
    extends ConsumerState<ProfitLossCalculatorScreen> {
  final TextEditingController _entryPriceController = TextEditingController();
  final TextEditingController _exitPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _leverageController = TextEditingController();

  bool _isLong = true;
  double? _grossProfit;
  double? _netProfit;
  double? _profitPercentage;
  double? _roe; // Return on Equity (with leverage)
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // 기본값 설정
    _entryPriceController.text = '42500';
    _exitPriceController.text = '43200';
    _quantityController.text = '0.1';
    _leverageController.text = '1';

    // 초기 계산
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateProfitLoss();
    });
  }

  @override
  void dispose() {
    _entryPriceController.dispose();
    _exitPriceController.dispose();
    _quantityController.dispose();
    _leverageController.dispose();
    super.dispose();
  }

  void _calculateProfitLoss() {
    setState(() {
      _errorMessage = null;
      _grossProfit = null;
      _netProfit = null;
      _profitPercentage = null;
      _roe = null;
    });

    try {
      final entryPrice = double.parse(_entryPriceController.text);
      final exitPrice = double.parse(_exitPriceController.text);
      final quantity = double.parse(_quantityController.text);
      final leverage = double.parse(_leverageController.text);

      // 유효성 검사
      if (entryPrice <= 0 || exitPrice <= 0) {
        setState(() => _errorMessage = 'Prices must be positive');
        return;
      }
      if (quantity <= 0) {
        setState(() => _errorMessage = 'Quantity must be positive');
        return;
      }
      if (leverage <= 0) {
        setState(() => _errorMessage = 'Leverage must be positive');
        return;
      }

      // 계산
      double priceDifference;
      if (_isLong) {
        priceDifference = exitPrice - entryPrice;
      } else {
        priceDifference = entryPrice - exitPrice;
      }

      final grossProfit = priceDifference * quantity;
      final tradingFee =
          (entryPrice * quantity * 0.001) +
          (exitPrice * quantity * 0.001); // 0.1% 수수료 가정
      final netProfit = grossProfit - tradingFee;

      final initialMargin = entryPrice * quantity / leverage;
      final profitPercentage = (grossProfit / (entryPrice * quantity)) * 100;
      final roe = (netProfit / initialMargin) * 100;

      setState(() {
        _grossProfit = grossProfit;
        _netProfit = netProfit;
        _profitPercentage = profitPercentage;
        _roe = roe;
      });
    } catch (e) {
      setState(() => _errorMessage = 'Please enter valid numbers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profit/Loss Calculator',
          style: GoogleFonts.montserrat(
            color: AppTheme.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 설명
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accentColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.accentColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Calculate potential profits and losses for your trades, including fees and leverage.',
                        style: GoogleFonts.montserrat(
                          color: AppTheme.primaryText,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Long/Short 선택
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _isLong = true);
                          _calculateProfitLoss();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isLong
                                ? AppTheme.positiveColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'LONG',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: _isLong
                                  ? Colors.white
                                  : AppTheme.secondaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _isLong = false);
                          _calculateProfitLoss();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isLong
                                ? AppTheme.negativeColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'SHORT',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: !_isLong
                                  ? Colors.white
                                  : AppTheme.secondaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 입력 필드들
              CalculatorInputField(
                label: 'Entry Price',
                controller: _entryPriceController,
                prefix: '\$',
                onChanged: (_) => _calculateProfitLoss(),
              ),

              const SizedBox(height: 16),

              CalculatorInputField(
                label: 'Exit Price',
                controller: _exitPriceController,
                prefix: '\$',
                onChanged: (_) => _calculateProfitLoss(),
              ),

              const SizedBox(height: 16),

              CalculatorInputField(
                label: 'Quantity',
                controller: _quantityController,
                onChanged: (_) => _calculateProfitLoss(),
              ),

              const SizedBox(height: 16),

              CalculatorInputField(
                label: 'Leverage',
                controller: _leverageController,
                suffix: 'x',
                onChanged: (_) => _calculateProfitLoss(),
              ),

              const SizedBox(height: 24),

              // 에러 메시지
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.negativeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.negativeColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.montserrat(
                      color: AppTheme.negativeColor,
                      fontSize: 12,
                    ),
                  ),
                ),

              // 결과
              if (_grossProfit != null && _errorMessage == null)
                CalculatorResultCard(
                  title: 'P&L Results',
                  results: [
                    ResultItem(
                      label: 'Gross P&L',
                      value:
                          '${_grossProfit! >= 0 ? '+' : ''}\$${_grossProfit!.toStringAsFixed(2)}',
                      icon: Icons.trending_up,
                      color: _grossProfit! >= 0
                          ? AppTheme.positiveColor
                          : AppTheme.negativeColor,
                    ),
                    ResultItem(
                      label: 'Net P&L (after fees)',
                      value:
                          '${_netProfit! >= 0 ? '+' : ''}\$${_netProfit!.toStringAsFixed(2)}',
                      icon: Icons.account_balance_wallet,
                      color: _netProfit! >= 0
                          ? AppTheme.positiveColor
                          : AppTheme.negativeColor,
                    ),
                    ResultItem(
                      label: 'P&L Percentage',
                      value:
                          '${_profitPercentage! >= 0 ? '+' : ''}${_profitPercentage!.toStringAsFixed(2)}%',
                      icon: Icons.percent,
                      color: _profitPercentage! >= 0
                          ? AppTheme.positiveColor
                          : AppTheme.negativeColor,
                    ),
                    ResultItem(
                      label: 'ROE (with leverage)',
                      value:
                          '${_roe! >= 0 ? '+' : ''}${_roe!.toStringAsFixed(2)}%',
                      icon: Icons.rocket_launch,
                      color: _roe! >= 0
                          ? AppTheme.positiveColor
                          : AppTheme.negativeColor,
                    ),
                  ],
                ),

              const SizedBox(height: 24),

              // 리셋 버튼
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _resetCalculator,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppTheme.borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Reset Calculator',
                    style: GoogleFonts.montserrat(
                      color: AppTheme.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetCalculator() {
    _entryPriceController.clear();
    _exitPriceController.clear();
    _quantityController.clear();
    _leverageController.text = '1';
    setState(() {
      _isLong = true;
      _grossProfit = null;
      _netProfit = null;
      _profitPercentage = null;
      _roe = null;
      _errorMessage = null;
    });
  }
}
