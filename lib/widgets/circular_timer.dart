import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A premium circular timer widget with a painted progress arc.
class CircularTimer extends StatelessWidget {
  const CircularTimer({
    super.key,
    required this.progress,
    required this.timeText,
    this.subtitle = 'Stay Focused',
    this.size = 280,
  });

  /// Progress from 0.0 (empty) to 1.0 (full).
  final double progress;

  /// The countdown string, e.g. "25:00".
  final String timeText;

  /// Subtitle shown below the time.
  final String subtitle;

  /// Diameter of the circle in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Painted rings ───────────────────────────────────
          CustomPaint(
            size: Size(size, size),
            painter: _TimerRingPainter(
              progress: progress,
              trackColor: cs.surfaceContainerLow,
              progressColor: cs.primaryContainer,
              strokeWidth: 8,
            ),
          ),

          // ── Center text ────────────────────────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeText,
                style: GoogleFonts.inter(
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  letterSpacing: -1.5,
                  color: const Color(0xFF050A30),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Custom painter for the two-ring arc
// ─────────────────────────────────────────────────────────────────
class _TimerRingPainter extends CustomPainter {
  _TimerRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    this.strokeWidth = 8,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Active arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Glow / shadow for the progress arc
      final glowPaint = Paint()
        ..color = progressColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      final sweepAngle = 2 * math.pi * progress;
      final rect = Rect.fromCircle(center: center, radius: radius);

      canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, glowPaint);
      canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(_TimerRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.progressColor != progressColor;
}
