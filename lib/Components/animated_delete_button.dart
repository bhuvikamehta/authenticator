import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemedDeleteButton extends StatefulWidget {
  final Future<void> Function() onPressed;

  const ThemedDeleteButton({super.key, required this.onPressed});

  @override
  State<ThemedDeleteButton> createState() => _ThemedDeleteButtonState();
}

class _ThemedDeleteButtonState extends State<ThemedDeleteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _holdController;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();

    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _holdController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Strong heavy haptic feedback on completion
        HapticFeedback.heavyImpact();
        HapticFeedback.vibrate();
        // Trigger deletion when animation completes
        if (mounted) {
          widget.onPressed();
        }
      }
    });
  }

  @override
  void dispose() {
    _holdController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    if (!mounted) return;
    // Medium haptic feedback when starting to press
    HapticFeedback.mediumImpact();
    setState(() {
      _isHolding = true;
    });
    _holdController.forward();
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!mounted) return;
    setState(() {
      _isHolding = false;
    });
    _holdController.reverse();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (!mounted) return;
    setState(() {
      _isHolding = false;
    });
    _holdController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final elevatedButtonStyle = Theme.of(context).elevatedButtonTheme.style;
    final cardColor = elevatedButtonStyle?.backgroundColor?.resolve({}) ?? 
                     Theme.of(context).primaryColor;
    
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: AnimatedBuilder(
        animation: _holdController,
        builder: (context, child) {
          return Transform.scale(
            scale: _isHolding ? 1.2 : 1.0,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _isHolding
                    ? Color.lerp(scaffoldColor, Colors.red, _holdController.value)
                    : scaffoldColor,
                shape: BoxShape.circle,
              ),
              child: CustomPaint(
                painter: HoldProgressPainter(
                  progress: _holdController.value,
                  isHolding: _isHolding,
                ),
                child: Center(
                  child: Icon(
                    Icons.delete_outline,
                    size: 24,
                    color: _holdController.value > 0.5 
                        ? Colors.white 
                        : cardColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom painter for hold progress border
class HoldProgressPainter extends CustomPainter {
  final double progress;
  final bool isHolding;

  HoldProgressPainter({required this.progress, required this.isHolding});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Draw white progress border
    if (isHolding && progress > 0) {
      final paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * 3.14159 * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2, // Start from top
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(HoldProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isHolding != isHolding;
  }
}
