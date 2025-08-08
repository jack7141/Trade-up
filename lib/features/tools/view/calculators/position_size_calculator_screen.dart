import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/tools/widget/calculator_input_field.dart';
import 'package:trade_up/features/tools/widget/calculator_result_card.dart';

class PositionSizeCalculatorScreen extends ConsumerStatefulWidget {
  const PositionSizeCalculatorScreen({super.key});

  @override
  ConsumerState<PositionSizeCalculatorScreen> createState() =>
      _PositionSizeCalculatorScreenState();
}

class _PositionSizeCalculatorScreenState
    extends ConsumerState<PositionSizeCalculatorScreen> {
  final TextEditingController _accountBalanceController =
      TextEditingController();
  final TextEditingController _riskPercentageController =
      TextEditingController();
  final TextEditingController _entryPriceController = TextEditingController();
  final TextEditingController _stopLossPriceController =
      TextEditingController();

  double? _positionSize;
  double? _maxLoss;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // 기본값 설정
    _accountBalanceController.text = '10000';
    _riskPercentageController.text = '2';
    _entryPriceController.text = '42500';
    _stopLossPriceController.text = '41000';

    // 초기 계산
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculatePositionSize();
    });
  }

  @override
  void dispose() {
    _accountBalanceController.dispose();
    _riskPercentageController.dispose();
    _entryPriceController.dispose();
    _stopLossPriceController.dispose();
    super.dispose();
  }

  void _calculatePositionSize() {
    setState(() {
      _errorMessage = null;
      _positionSize = null;
      _maxLoss = null;
    });

    try {
      final accountBalance = double.parse(_accountBalanceController.text);
      final riskPercentage = double.parse(_riskPercentageController.text);
      final entryPrice = double.parse(_entryPriceController.text);
      final stopLossPrice = double.parse(_stopLossPriceController.text);

      // 유효성 검사
      if (accountBalance <= 0) {
        setState(() => _errorMessage = 'Account balance must be positive');
        return;
      }
      if (riskPercentage <= 0 || riskPercentage > 100) {
        setState(
          () => _errorMessage = 'Risk percentage must be between 0-100%',
        );
        return;
      }
      if (entryPrice <= 0 || stopLossPrice <= 0) {
        setState(() => _errorMessage = 'Prices must be positive');
        return;
      }
      if (entryPrice == stopLossPrice) {
        setState(
          () => _errorMessage = 'Entry price and stop loss must be different',
        );
        return;
      }

      // 계산
      final riskAmount = accountBalance * (riskPercentage / 100);
      final priceRisk = (entryPrice - stopLossPrice).abs();
      final positionSize = riskAmount / priceRisk;

      setState(() {
        _positionSize = positionSize;
        _maxLoss = riskAmount;
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
          'Position Size Calculator',
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
                        'Calculate the optimal position size based on your account balance and risk tolerance.',
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

              // 입력 필드들
              CalculatorInputField(
                label: 'Account Balance',
                controller: _accountBalanceController,
                prefix: '\$',
                onChanged: (_) => _calculatePositionSize(),
              ),

              const SizedBox(height: 16),

              CalculatorInputField(
                label: 'Risk Per Trade',
                controller: _riskPercentageController,
                suffix: '%',
                onChanged: (_) => _calculatePositionSize(),
              ),

              const SizedBox(height: 16),

              CalculatorInputField(
                label: 'Entry Price',
                controller: _entryPriceController,
                prefix: '\$',
                onChanged: (_) => _calculatePositionSize(),
              ),

              const SizedBox(height: 16),

              CalculatorInputField(
                label: 'Stop Loss Price',
                controller: _stopLossPriceController,
                prefix: '\$',
                onChanged: (_) => _calculatePositionSize(),
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
              if (_positionSize != null && _errorMessage == null)
                CalculatorResultCard(
                  title: 'Calculation Results',
                  results: [
                    ResultItem(
                      label: 'Position Size',
                      value: '${_positionSize!.toStringAsFixed(6)} units',
                      icon: Icons.pie_chart,
                      color: AppTheme.accentColor,
                    ),
                    ResultItem(
                      label: 'Maximum Loss',
                      value: '\$${_maxLoss!.toStringAsFixed(2)}',
                      icon: Icons.trending_down,
                      color: AppTheme.negativeColor,
                    ),
                    ResultItem(
                      label: 'Risk Amount',
                      value: '${_riskPercentageController.text}% of balance',
                      icon: Icons.warning,
                      color: AppTheme.secondaryText,
                    ),
                    ResultItem(
                      label: 'Price Risk',
                      value:
                          '\$${(double.parse(_entryPriceController.text) - double.parse(_stopLossPriceController.text)).abs().toStringAsFixed(2)}',
                      icon: Icons.show_chart,
                      color: AppTheme.secondaryText,
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
    _accountBalanceController.clear();
    _riskPercentageController.clear();
    _entryPriceController.clear();
    _stopLossPriceController.clear();
    setState(() {
      _positionSize = null;
      _maxLoss = null;
      _errorMessage = null;
    });
  }
}

class ResultItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const ResultItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
