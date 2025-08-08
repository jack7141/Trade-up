import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';
import 'package:trade_up/l10n/app_localizations.dart';

class DailyPnlChartWidget extends StatelessWidget {
  const DailyPnlChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.backgroundColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Icon(Icons.bar_chart, color: AppTheme.accentColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.netDailyPnl,
                  style: GoogleFonts.montserrat(
                    color: AppTheme.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.info_outline,
                  color: AppTheme.secondaryText,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 차트 (Y축 라벨 공간 확보)
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(left: 40), // Y축 라벨 공간 확보
                child: CustomPaint(
                  painter: BarChartPainter(),
                  child: Container(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 날짜 라벨
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDateLabel('02/03/25'),
                _buildDateLabel('02/14/25'),
                _buildDateLabel('02/21/25'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateLabel(String date) {
    return Text(
      date,
      style: GoogleFonts.robotoMono(
        color: AppTheme.secondaryText,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 차트 데이터 (날짜별 P&L)
    final data = [
      -288.0, // 02/03/25 - 손실
      511.0, // 02/07/25 - 수익
      321.0, // 02/14/25 - 수익
      -340.0, // 02/20/25 - 손실
      101.0, // 02/21/25 - 수익
      427.0, // 02/27/25 - 수익
    ];

    final maxValue = data.map((e) => e.abs()).reduce((a, b) => a > b ? a : b);
    final barWidth = size.width / (data.length * 2);
    final centerY = size.height / 2;

    // Y축 그리드 라인 그리기
    _drawGridLines(canvas, size, maxValue, centerY);

    // 막대 그래프 그리기
    for (int i = 0; i < data.length; i++) {
      final value = data[i];
      final isPositive = value >= 0;
      final barHeight = (value.abs() / maxValue) * (size.height / 2 - 20);

      final left = i * barWidth * 2 + barWidth * 0.5;
      final right = left + barWidth;

      final top = isPositive ? centerY - barHeight : centerY;
      final bottom = isPositive ? centerY : centerY + barHeight;

      final rect = Rect.fromLTRB(left, top, right, bottom);

      final paint = Paint()
        ..color = isPositive ? AppTheme.positiveColor : AppTheme.negativeColor
        ..style = PaintingStyle.fill;

      // 막대 그리기 (둥근 모서리)
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));
      canvas.drawRRect(rrect, paint);

      // 값 표시 (막대 위/아래)
      _drawValueLabel(
        canvas,
        value,
        left + barWidth / 2,
        isPositive ? top - 10 : bottom + 20,
        isPositive,
      );
    }

    // X축 선 그리기
    final axisLine = Paint()
      ..color = AppTheme.borderColor
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), axisLine);
  }

  void _drawGridLines(
    Canvas canvas,
    Size size,
    double maxValue,
    double centerY,
  ) {
    final gridPaint = Paint()
      ..color = AppTheme.borderColor.withOpacity(0.3)
      ..strokeWidth = 0.5;

    // 수평 그리드 라인
    final steps = 4;
    for (int i = 1; i <= steps; i++) {
      final y1 = centerY - (size.height / 2 - 20) * i / steps; // 위쪽
      final y2 = centerY + (size.height / 2 - 20) * i / steps; // 아래쪽

      canvas.drawLine(Offset(0, y1), Offset(size.width, y1), gridPaint);
      canvas.drawLine(Offset(0, y2), Offset(size.width, y2), gridPaint);

      // Y축 값 라벨 (컨테이너 안쪽에 위치)
      _drawYAxisLabel(canvas, (maxValue * i / steps), -35, y1);
      _drawYAxisLabel(canvas, -(maxValue * i / steps), -35, y2);
    }
  }

  void _drawValueLabel(
    Canvas canvas,
    double value,
    double x,
    double y,
    bool isPositive,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '\$${value.abs().toStringAsFixed(0)}',
        style: GoogleFonts.robotoMono(
          color: isPositive ? AppTheme.positiveColor : AppTheme.negativeColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  void _drawYAxisLabel(Canvas canvas, double value, double x, double y) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '\$${value.toStringAsFixed(0)}',
        style: GoogleFonts.robotoMono(
          color: AppTheme.secondaryText.withOpacity(0.7),
          fontSize: 9,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x, y - textPainter.height / 2), // x 위치 조정
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
