import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';

class NetPlCardWidget extends StatelessWidget {
  const NetPlCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.positiveColor.withOpacity(0.15),
              AppTheme.surfaceColor.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.positiveColor.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Net P/L',
                  style: GoogleFonts.montserrat(
                    color: AppTheme.secondaryText,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.positiveColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '+1.25% (24h)',
                    style: GoogleFonts.montserrat(
                      color: AppTheme.positiveColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    '+\$2,875.50',
                    style: GoogleFonts.bebasNeue(
                      color: AppTheme.positiveColor,
                      fontSize: 40,
                      letterSpacing: 1.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    height: 40,
                    child: _SparklineChart(color: AppTheme.positiveColor),
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

class _SparklineChart extends StatelessWidget {
  final Color color;
  // 실제 앱에서는 List<double> data 와 같이 데이터를 받아옵니다.
  const _SparklineChart({required this.color});

  @override
  Widget build(BuildContext context) {
    // CustomPaint를 사용하여 직접 차트를 그립니다.
    return CustomPaint(
      painter: _SparklinePainter(color: color),
      size: Size.infinite,
    );
  }
}

// --- 스파크라인 차트를 그리는 CustomPainter ---
class _SparklinePainter extends CustomPainter {
  final Color color;
  // 임시 데이터. 실제로는 ViewModel에서 전달받은 데이터를 사용합니다.
  final List<double> data = [0.5, 0.7, 0.6, 0.8, 0.5, 0.9, 0.4, 0.6, 0.8, 1.0];

  _SparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final stepX = size.width / (data.length - 1);

    // 데이터 포인트를 기반으로 경로를 생성합니다.
    for (int i = 0; i < data.length; i++) {
      final x = stepX * i;
      // Y값은 위아래가 반대이므로 (1 - data)를 사용합니다.
      final y = size.height * (1 - data[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // 생성된 경로를 캔버스에 그립니다.
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
