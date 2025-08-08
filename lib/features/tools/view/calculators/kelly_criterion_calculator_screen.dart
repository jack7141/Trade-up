import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/features/tools/view/calculators/position_size_calculator_screen.dart';
import 'package:trade_up/features/tools/widget/calculator_input_field.dart';
import 'package:trade_up/features/tools/widget/calculator_result_card.dart';

class KellyCriterionCalculatorScreen extends ConsumerStatefulWidget {
  const KellyCriterionCalculatorScreen({super.key});

  @override
  ConsumerState<KellyCriterionCalculatorScreen> createState() =>
      _KellyCriterionCalculatorScreenState();
}

class _KellyCriterionCalculatorScreenState
    extends ConsumerState<KellyCriterionCalculatorScreen> {
  final TextEditingController _winRateController = TextEditingController();
  final TextEditingController _avgWinController = TextEditingController();
  final TextEditingController _avgLossController = TextEditingController();
  final TextEditingController _accountBalanceController =
      TextEditingController();

  double? _kellyPercentage;
  double? _optimalPositionSize;
  String? _riskLevel;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // 기본값 설정 (실제 트레이딩 시나리오)
    _winRateController.text = '60';
    _avgWinController.text = '300';
    _avgLossController.text = '200';
    _accountBalanceController.text = '10000';

    // 초기 계산
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateKelly();
    });
  }

  @override
  void dispose() {
    _winRateController.dispose();
    _avgWinController.dispose();
    _avgLossController.dispose();
    _accountBalanceController.dispose();
    super.dispose();
  }

  void _calculateKelly() {
    setState(() {
      _errorMessage = null;
      _kellyPercentage = null;
      _optimalPositionSize = null;
      _riskLevel = null;
    });

    try {
      final winRate = double.parse(_winRateController.text) / 100;
      final avgWin = double.parse(_avgWinController.text);
      final avgLoss = double.parse(_avgLossController.text);
      final accountBalance = double.parse(_accountBalanceController.text);

      // 유효성 검사
      if (winRate <= 0 || winRate >= 1) {
        setState(() => _errorMessage = 'Win rate must be between 0-100%');
        return;
      }
      if (avgWin <= 0 || avgLoss <= 0) {
        setState(() => _errorMessage = 'Average win and loss must be positive');
        return;
      }
      if (accountBalance <= 0) {
        setState(() => _errorMessage = 'Account balance must be positive');
        return;
      }

      // Kelly Criterion 계산
      // Kelly % = (Win Rate × Avg Win - Loss Rate × Avg Loss) / Avg Win
      final lossRate = 1 - winRate;
      final kellyFraction = (winRate * avgWin - lossRate * avgLoss) / avgWin;
      final kellyPercentage = kellyFraction * 100;

      // 실용적 조정 (Kelly의 25-50% 사용 권장)
      final conservativeKelly = kellyPercentage * 0.25; // 25% Kelly
      final optimalPositionSize = accountBalance * (conservativeKelly / 100);

      // 위험 수준 평가
      String riskLevel;
      if (kellyPercentage < 0) {
        riskLevel = 'Negative Edge - Don\'t Trade';
      } else if (kellyPercentage < 5) {
        riskLevel = 'Very Conservative';
      } else if (kellyPercentage < 15) {
        riskLevel = 'Conservative';
      } else if (kellyPercentage < 25) {
        riskLevel = 'Moderate';
      } else if (kellyPercentage < 40) {
        riskLevel = 'Aggressive';
      } else {
        riskLevel = 'Very Aggressive';
      }

      setState(() {
        _kellyPercentage = kellyPercentage;
        _optimalPositionSize = optimalPositionSize;
        _riskLevel = riskLevel;
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
          'Kelly Criterion Calculator',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.psychology,
                          color: AppTheme.accentColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Kelly Criterion Formula',
                          style: GoogleFonts.montserrat(
                            color: AppTheme.primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Calculate optimal position size based on your win rate and average profits/losses. Use 25% of Kelly result for conservative risk management.',
                      style: GoogleFonts.montserrat(
                        color: AppTheme.primaryText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 입력 필드들
              CalculatorInputField(
                label: 'Win Rate',
                controller: _winRateController,
                suffix: '%',
                hintText: 'e.g. 60',
                onChanged: (_) => _calculateKelly(),
              ),

              const SizedBox(height: 16),

              CalculatorInputField(
                label: 'Average Win',
                controller: _avgWinController,
                prefix: '\$',
                hintText: 'e.g. 300',
                onChanged: (_) => _calculateKelly(),
              ),

              const SizedBox(height: 16),

              CalculatorInputField(
                label: 'Average Loss',
                controller: _avgLossController,
                prefix: '\$',
                hintText: 'e.g. 200',
                onChanged: (_) => _calculateKelly(),
              ),

              const SizedBox(height: 16),

              CalculatorInputField(
                label: 'Account Balance',
                controller: _accountBalanceController,
                prefix: '\$',
                hintText: 'e.g. 10000',
                onChanged: (_) => _calculateKelly(),
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
              if (_kellyPercentage != null && _errorMessage == null)
                CalculatorResultCard(
                  title: 'Kelly Criterion Results',
                  results: [
                    ResultItem(
                      label: 'Full Kelly %',
                      value: '${_kellyPercentage!.toStringAsFixed(1)}%',
                      icon: Icons.psychology,
                      color: _kellyPercentage! >= 0
                          ? AppTheme.accentColor
                          : AppTheme.negativeColor,
                    ),
                    ResultItem(
                      label: 'Conservative Kelly (25%)',
                      value:
                          '${(_kellyPercentage! * 0.25).toStringAsFixed(1)}%',
                      icon: Icons.shield,
                      color: AppTheme.positiveColor,
                    ),
                    ResultItem(
                      label: 'Optimal Position Size',
                      value: '\$${_optimalPositionSize!.toStringAsFixed(2)}',
                      icon: Icons.account_balance_wallet,
                      color: AppTheme.accentColor,
                    ),
                    ResultItem(
                      label: 'Risk Level',
                      value: _riskLevel!,
                      icon: Icons.speed,
                      color: _getRiskLevelColor(_riskLevel!),
                    ),
                  ],
                ),

              const SizedBox(height: 16),

              // Kelly 설명 카드
              if (_kellyPercentage != null && _errorMessage == null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡 Kelly Criterion Tips',
                        style: GoogleFonts.montserrat(
                          color: AppTheme.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Use 25-50% of full Kelly for safer trading\n'
                        '• Negative Kelly means no statistical edge\n'
                        '• Higher Kelly = higher returns but more volatility\n'
                        '• Review your win rate and R:R regularly',
                        style: GoogleFonts.montserrat(
                          color: AppTheme.secondaryText,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
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

  Color _getRiskLevelColor(String riskLevel) {
    switch (riskLevel) {
      case 'Negative Edge - Don\'t Trade':
        return AppTheme.negativeColor;
      case 'Very Conservative':
      case 'Conservative':
        return AppTheme.positiveColor;
      case 'Moderate':
        return AppTheme.accentColor;
      case 'Aggressive':
      case 'Very Aggressive':
        return AppTheme.negativeColor;
      default:
        return AppTheme.secondaryText;
    }
  }

  void _resetCalculator() {
    _winRateController.clear();
    _avgWinController.clear();
    _avgLossController.clear();
    _accountBalanceController.clear();
    setState(() {
      _kellyPercentage = null;
      _optimalPositionSize = null;
      _riskLevel = null;
      _errorMessage = null;
    });
  }
}
