import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';

class ZellaScoreWidget extends StatelessWidget {
  const ZellaScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.radar, color: AppTheme.accentColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Zella Score',
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

            // 레이더 차트와 스코어
            Row(
              children: [
                // 레이더 차트
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 200,
                    child: CustomPaint(
                      painter: RadarChartPainter(),
                      child: Container(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // 스코어 표시
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Zella Score',
                        style: GoogleFonts.montserrat(
                          color: AppTheme.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '50.81',
                        style: GoogleFonts.bebasNeue(
                          color: AppTheme.primaryText,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 진행률 바
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '0',
                                style: GoogleFonts.robotoMono(
                                  color: AppTheme.secondaryText,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                '100',
                                style: GoogleFonts.robotoMono(
                                  color: AppTheme.secondaryText,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF6B6B), // 빨강
                                  Color(0xFFFFE66D), // 노랑
                                  Color(0xFF4ECDC4), // 청록
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.backgroundColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.51, // 50.81%
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF6B6B),
                                          Color(0xFFFFE66D),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;

    // 배경 그리드 그리기
    _drawGrid(canvas, center, radius);

    // 라벨 그리기
    _drawLabels(canvas, center, radius);

    // 데이터 영역 그리기
    _drawDataArea(canvas, center, radius);

    // 데이터 포인트 그리기
    _drawDataPoints(canvas, center, radius);
  }

  void _drawGrid(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = AppTheme.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 동심원 그리기 (5개 레벨)
    for (int i = 1; i <= 5; i++) {
      final currentRadius = radius * i / 5;

      final path = Path();
      for (int j = 0; j < 6; j++) {
        final angle = (j * math.pi * 2 / 6) - math.pi / 2;
        final x = center.dx + math.cos(angle) * currentRadius;
        final y = center.dy + math.sin(angle) * currentRadius;

        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }

    // 축 선 그리기
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi * 2 / 6) - math.pi / 2;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    final labels = [
      'Win %',
      'Profit factor',
      'Avg win/loss',
      'Recovery factor',
      'Max drawdown',
      'Consistency',
    ];

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi * 2 / 6) - math.pi / 2;
      final labelRadius = radius + 25;
      final x = center.dx + math.cos(angle) * labelRadius;
      final y = center.dy + math.sin(angle) * labelRadius;

      textPainter.text = TextSpan(
        text: labels[i],
        style: GoogleFonts.montserrat(
          color: AppTheme.secondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  void _drawDataArea(Canvas canvas, Offset center, double radius) {
    // 실제 데이터 값 (0-1 사이)
    final dataValues = [0.75, 0.6, 0.8, 0.4, 0.7, 0.5]; // 예시 데이터

    final path = Path();
    final paint = Paint()
      ..color = AppTheme.accentColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi * 2 / 6) - math.pi / 2;
      final dataRadius = radius * dataValues[i];
      final x = center.dx + math.cos(angle) * dataRadius;
      final y = center.dy + math.sin(angle) * dataRadius;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);

    // 테두리 그리기
    final borderPaint = Paint()
      ..color = AppTheme.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, borderPaint);
  }

  void _drawDataPoints(Canvas canvas, Offset center, double radius) {
    final dataValues = [0.75, 0.6, 0.8, 0.4, 0.7, 0.5];

    final paint = Paint()
      ..color = AppTheme.accentColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi * 2 / 6) - math.pi / 2;
      final dataRadius = radius * dataValues[i];
      final x = center.dx + math.cos(angle) * dataRadius;
      final y = center.dy + math.sin(angle) * dataRadius;

      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
