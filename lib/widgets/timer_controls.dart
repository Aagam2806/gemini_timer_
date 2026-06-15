import 'package:flutter/material.dart';

/// The Start / Pause / Reset button row matching the Stitch design.
class TimerControls extends StatelessWidget {
  const TimerControls({
    super.key,
    required this.isRunning,
    required this.isPaused,
    required this.onStart,
    required this.onPause,
    required this.onReset,
  });

  final bool isRunning;
  final bool isPaused;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Start / Resume ─────────────────────────────────
        Expanded(
          child: _ControlButton(
            icon: Icons.play_arrow_rounded,
            label: isRunning ? 'Resume' : 'Start',
            filled: true,
            onPressed: isRunning && !isPaused ? null : onStart,
            colorScheme: cs,
          ),
        ),
        const SizedBox(width: 12),

        // ── Pause ──────────────────────────────────────────
        Expanded(
          child: _ControlButton(
            icon: Icons.pause_rounded,
            label: 'Pause',
            filled: true,
            onPressed: isRunning && !isPaused ? onPause : null,
            colorScheme: cs,
          ),
        ),
        const SizedBox(width: 12),

        // ── Reset (icon-only) ──────────────────────────────
        _IconControlButton(
          icon: Icons.refresh_rounded,
          onPressed: onReset,
          colorScheme: cs,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
class _ControlButton extends StatefulWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onPressed,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback? onPressed;
  final ColorScheme colorScheme;

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scale = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final cs = widget.colorScheme;

    return GestureDetector(
      onTapDown: enabled ? (_) => _scaleCtrl.forward() : null,
      onTapUp: enabled ? (_) => _scaleCtrl.reverse() : null,
      onTapCancel: enabled ? () => _scaleCtrl.reverse() : null,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: enabled ? 1.0 : 0.45,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
class _IconControlButton extends StatefulWidget {
  const _IconControlButton({
    required this.icon,
    required this.onPressed,
    required this.colorScheme,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  @override
  State<_IconControlButton> createState() => _IconControlButtonState();
}

class _IconControlButtonState extends State<_IconControlButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scale = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = widget.colorScheme;

    return GestureDetector(
      onTapDown: (_) => _scaleCtrl.forward(),
      onTapUp: (_) => _scaleCtrl.reverse(),
      onTapCancel: () => _scaleCtrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(24),
              child: Icon(widget.icon, color: Colors.white, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}
