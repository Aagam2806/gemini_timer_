import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/circular_timer.dart';
import '../widgets/timer_controls.dart';
import '../services/gemini_service.dart';

/// Single-screen Focus Timer matching a polished, minimalist design.
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  // ── Timer state ──────────────────────────────────────────────
  int _selectedDuration = 25 * 60; // 25 minutes default
  late int _remainingSeconds = _selectedDuration;
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;

  // ── Recent Sessions ──────────────────────────────────────────
  final List<int> _recentSessions = [];

  // ── Milestone flags ──────────────────────────────────────────
  bool _halfwayTriggered = false;
  bool _tenSecondsTriggered = false;
  bool _zeroTriggered = false;

  // ── Animation ────────────────────────────────────────────────
  late final AnimationController _progressCtrl;

  // ── Services ──────────────────────────────────────────────────
  final _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: _selectedDuration),
      value: 1.0, // full ring
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressCtrl.dispose();
    super.dispose();
  }

  void _addRecentSession(int duration) {
    setState(() {
      _recentSessions.insert(0, duration);
      if (_recentSessions.length > 5) {
        _recentSessions.removeLast();
      }
    });
  }

  // ── Timer logic ──────────────────────────────────────────────
  void _start() {
    if (_isRunning && !_isPaused) return;
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    // Calculate how many milliseconds are left total
    final durationMs = _remainingSeconds * 1000;
    
    // Animate progress ring from current value to 0
    _progressCtrl.duration = Duration(milliseconds: durationMs);
    _progressCtrl.reverse(from: _progressCtrl.value);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds <= 0) {
        if (!_zeroTriggered) {
          debugPrint('Time up triggered');
          _geminiService.generateMotivation('Time is up');
          _zeroTriggered = true;
          _addRecentSession(_selectedDuration);
        }
        _timer?.cancel();
        setState(() {
          _isRunning = false;
          _isPaused = false;
        });
        return;
      }
      setState(() => _remainingSeconds--);

      if (_remainingSeconds == _selectedDuration ~/ 2 && !_halfwayTriggered) {
        debugPrint('Halfway triggered');
        _geminiService.generateMotivation('Halfway reached');
        _halfwayTriggered = true;
      }

      if (_remainingSeconds == 10 && !_tenSecondsTriggered) {
        debugPrint('10 seconds triggered');
        _geminiService.generateMotivation('10 seconds remaining');
        _tenSecondsTriggered = true;
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    _progressCtrl.stop();
    setState(() => _isPaused = true);
  }

  void _reset() {
    _timer?.cancel();
    _progressCtrl.stop();
    _progressCtrl.value = 1.0;
    _halfwayTriggered = false;
    _tenSecondsTriggered = false;
    _zeroTriggered = false;
    setState(() {
      _remainingSeconds = _selectedDuration;
      _isRunning = false;
      _isPaused = false;
    });
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '$seconds sec';
    return '${seconds ~/ 60} min';
  }

  Future<void> _showDurationPicker() async {
    final durations = [
      30, // 30 sec
      60, // 1 min
      120, // 2 min
      300, // 5 min
      600, // 10 min
      900, // 15 min
      1500, // 25 min
      1800, // 30 min
      2700, // 45 min
      3600, // 60 min
    ];

    final int? selectedSecs = await showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Select Duration', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: durations.length,
                  itemBuilder: (context, index) {
                    final secs = durations[index];
                    return ListTile(
                      title: Center(
                        child: Text(
                          _formatDuration(secs),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: secs == _selectedDuration ? FontWeight.bold : FontWeight.normal,
                            color: secs == _selectedDuration ? Theme.of(context).colorScheme.primary : null,
                          ),
                        ),
                      ),
                      onTap: () => Navigator.pop(context, secs),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedSecs != null) {
      setState(() {
        _selectedDuration = selectedSecs;
        _remainingSeconds = _selectedDuration;
        _progressCtrl.duration = Duration(seconds: _selectedDuration);
        _progressCtrl.value = 1.0;
        _halfwayTriggered = false;
        _tenSecondsTriggered = false;
        _zeroTriggered = false;
      });
    }
  }

  String get _timeText {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Build ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      // Minimalist App Bar without navigation/settings
      appBar: AppBar(
        title: const Text('Focus Timer'),
        centerTitle: true,
        elevation: 0,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Main timer area
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Circular timer
                        AnimatedBuilder(
                          animation: _progressCtrl,
                          builder: (context, _) {
                            return CircularTimer(
                              progress: _progressCtrl.value,
                              timeText: _timeText,
                              subtitle: _isRunning && !_isPaused
                                  ? 'Stay Focused'
                                  : _isPaused
                                      ? 'Paused'
                                      : 'Ready',
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        
                        // Duration picker
                        FilledButton.icon(
                          onPressed: (_isRunning || _isPaused) ? null : _showDurationPicker,
                          icon: const Icon(Icons.timer_outlined, size: 18),
                          label: Text(_formatDuration(_selectedDuration)),
                        ),
                        const SizedBox(height: 32),

                        // Controls
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TimerControls(
                            isRunning: _isRunning,
                            isPaused: _isPaused,
                            onStart: _start,
                            onPause: _pause,
                            onReset: _reset,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // AI subtitle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 16,
                              color: cs.onSurfaceVariant.withOpacity(0.7),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AI announcements will play automatically',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: cs.onSurfaceVariant.withOpacity(0.7),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Recent Sessions Section
            if (_recentSessions.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Recent Sessions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: _recentSessions.map((duration) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_rounded, size: 16, color: cs.primary),
                              const SizedBox(width: 6),
                              Text(
                                _formatDuration(duration),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: cs.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
