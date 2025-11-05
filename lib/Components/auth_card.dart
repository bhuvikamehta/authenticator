import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:auth_app/Models/account.dart';
import 'package:crypto/crypto.dart';

class AuthCard extends StatefulWidget {
  final TOTPCard totpCard;
  
  const AuthCard({
    super.key,
    required this.totpCard,
  });

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late String _currentCode;
  late int _secondsRemaining;
  late AnimationController _animationController;
  bool _isCodeVisible = false; // Hidden by default

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.totpCard.period),
    );
    _animationController.addListener(() {
      setState(() {}); // Rebuild when animation updates
    });
    _updateCode();
    _startSmoothAnimation();
    _startTimer();
  }

  void _updateCode() {
    _currentCode = _generateTOTP();
    
    final secondsPassed = (DateTime.now().millisecondsSinceEpoch ~/ 1000) % widget.totpCard.period;
    _secondsRemaining = widget.totpCard.period - secondsPassed;
  }

  void _startSmoothAnimation() {
    _animationController.stop();
    _animationController.reset();
    
    final secondsPassed = (DateTime.now().millisecondsSinceEpoch ~/ 1000) % widget.totpCard.period;
    final millisWithinSecond = DateTime.now().millisecondsSinceEpoch % 1000;
    final totalProgress = (secondsPassed * 1000 + millisWithinSecond) / (widget.totpCard.period * 1000);
    
    _animationController.value = totalProgress;
    final remainingDuration = (widget.totpCard.period * 1000 * (1 - totalProgress)).round();
    
    _animationController.animateTo(
      1.0,
      duration: Duration(milliseconds: remainingDuration),
      curve: Curves.linear,
    );
  }

  String _generateTOTP() {
    final time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final counter = time ~/ widget.totpCard.period;
    
    // Decode base32 secret
    final key = _base32Decode(widget.totpCard.secret);
    
    // Generate HMAC
    final counterBytes = _intToBytes(counter);
    final hmac = Hmac(sha1, key);
    final digest = hmac.convert(counterBytes);
    
    // Dynamic truncation
    final offset = digest.bytes[digest.bytes.length - 1] & 0x0f;
    final binary = ((digest.bytes[offset] & 0x7f) << 24) |
        ((digest.bytes[offset + 1] & 0xff) << 16) |
        ((digest.bytes[offset + 2] & 0xff) << 8) |
        (digest.bytes[offset + 3] & 0xff);
    
    final code = binary % _pow10(widget.totpCard.digits);
    return code.toString().padLeft(widget.totpCard.digits, '0');
  }

  Uint8List _intToBytes(int value) {
    final result = Uint8List(8);
    for (int i = 7; i >= 0; i--) {
      result[i] = value & 0xff;
      value >>= 8;
    }
    return result;
  }

  int _pow10(int exponent) {
    int result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }

  Uint8List _base32Decode(String encoded) {
    // Remove padding and convert to uppercase
    encoded = encoded.toUpperCase().replaceAll('=', '');
    
    const base32Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final output = <int>[];
    int buffer = 0;
    int bitsLeft = 0;
    
    for (int i = 0; i < encoded.length; i++) {
      final value = base32Chars.indexOf(encoded[i]);
      if (value < 0) continue;
      
      buffer = (buffer << 5) | value;
      bitsLeft += 5;
      
      if (bitsLeft >= 8) {
        output.add((buffer >> (bitsLeft - 8)) & 0xff);
        bitsLeft -= 8;
      }
    }
    
    return Uint8List.fromList(output);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateCode();
        // Check if we need to restart the animation
        if (_secondsRemaining == widget.totpCard.period) {
          _startSmoothAnimation();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use theme colors
    final theme = Theme.of(context);
    final elevatedButtonStyle = theme.elevatedButtonTheme.style;
    final buttonBackgroundColor = elevatedButtonStyle?.backgroundColor?.resolve({}) ?? theme.primaryColor;
    final buttonForegroundColor = elevatedButtonStyle?.foregroundColor?.resolve({}) ?? Colors.white;
    final surfaceColor = theme.colorScheme.surface;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final borderColor = onSurfaceColor;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: buttonBackgroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
            // Glow effect with card's background color
            BoxShadow(
              color: buttonBackgroundColor.withOpacity(0.1),
              blurRadius: 30,
              spreadRadius: 8,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with issuer and level indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.totpCard.issuer,
                      style: TextStyle(
                        color: buttonForegroundColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: buttonForegroundColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '+${widget.totpCard.digits} Digit',
                      style: TextStyle(
                        color: buttonForegroundColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Account name
              Text(
                widget.totpCard.accountName,
                style: TextStyle(
                  color: buttonForegroundColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              
              // Progress indicator with dots
              Row(
                children: [
                  for (int i = 0; i < 4; i++)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == 0 
                            ? buttonForegroundColor 
                            : buttonForegroundColor.withOpacity(0.3),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Code display with animated border
              Stack(
                children: [
                  // Background container
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  
                  // Animated border that depletes
                  Positioned.fill(
                    child: CustomPaint(
                      painter: BorderProgressPainter(
                        progress: 1 - _animationController.value, // Reverse so it depletes
                        strokeWidth: 6,
                        color: borderColor,
                      ),
                    ),
                  ),
                  
                  // Code and eye icon
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Empty space for symmetry
                        const SizedBox(width: 40),
                        // Centered OTP code
                        Expanded(
                          child: Center(
                            child: Text(
                              _isCodeVisible ? _currentCode : '••••••',
                              style: TextStyle(
                                color: onSurfaceColor,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ),
                        // Eye icon toggle
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isCodeVisible = !_isCodeVisible;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: onSurfaceColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isCodeVisible ? Icons.visibility : Icons.visibility_off,
                              color: onSurfaceColor.withOpacity(0.7),
                              size: 20,
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
      ),
    );
  }
}

/// Custom painter for animated border that depletes around the perimeter
class BorderProgressPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0 (1.0 = full border, 0.0 = no border)
  final double strokeWidth;
  final Color color;

  BorderProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Adjust for stroke width to align with container border
    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    
    // Adjust radius to match the container's border radius minus the stroke inset
    final radius = 35.0 - inset;
    
    // Calculate the total perimeter of the rounded rectangle
    final width = rect.width;
    final height = rect.height;
    
    // Approximate perimeter: 2 * (width + height) - 4 * radius + 2 * pi * radius
    final straightParts = 2 * (width + height) - 8 * radius;
    final curvedParts = 2 * 3.14159 * radius;
    final totalPerimeter = straightParts + curvedParts;
    
    // Calculate how much of the perimeter to draw based on progress
    final drawLength = totalPerimeter * progress;
    
    // Create path for the border
    final path = Path();
    
    // Start from top-left, going clockwise
    final topLeft = Offset(rect.left + radius, rect.top);
    path.moveTo(topLeft.dx, topLeft.dy);
    
    double currentLength = 0;
    
    // Top edge
    final topEdgeLength = width - 2 * radius;
    if (currentLength + topEdgeLength <= drawLength) {
      path.lineTo(rect.right - radius, rect.top);
      currentLength += topEdgeLength;
    } else {
      final remaining = drawLength - currentLength;
      path.lineTo(topLeft.dx + remaining, rect.top);
      canvas.drawPath(path, paint);
      return;
    }
    
    // Top-right corner
    final cornerLength = (3.14159 * radius) / 2;
    if (currentLength + cornerLength <= drawLength) {
      path.arcToPoint(
        Offset(rect.right, rect.top + radius),
        radius: Radius.circular(radius),
        clockwise: true,
      );
      currentLength += cornerLength;
    } else {
      final remaining = drawLength - currentLength;
      final sweepAngle = (remaining / cornerLength) * (3.14159 / 2);
      path.arcTo(
        Rect.fromCircle(center: Offset(rect.right - radius, rect.top + radius), radius: radius),
        -3.14159 / 2,
        sweepAngle,
        false,
      );
      canvas.drawPath(path, paint);
      return;
    }
    
    // Right edge
    final rightEdgeLength = height - 2 * radius;
    if (currentLength + rightEdgeLength <= drawLength) {
      path.lineTo(rect.right, rect.bottom - radius);
      currentLength += rightEdgeLength;
    } else {
      final remaining = drawLength - currentLength;
      path.lineTo(rect.right, rect.top + radius + remaining);
      canvas.drawPath(path, paint);
      return;
    }
    
    // Bottom-right corner
    if (currentLength + cornerLength <= drawLength) {
      path.arcToPoint(
        Offset(rect.right - radius, rect.bottom),
        radius: Radius.circular(radius),
        clockwise: true,
      );
      currentLength += cornerLength;
    } else {
      final remaining = drawLength - currentLength;
      final sweepAngle = (remaining / cornerLength) * (3.14159 / 2);
      path.arcTo(
        Rect.fromCircle(center: Offset(rect.right - radius, rect.bottom - radius), radius: radius),
        0,
        sweepAngle,
        false,
      );
      canvas.drawPath(path, paint);
      return;
    }
    
    // Bottom edge
    if (currentLength + topEdgeLength <= drawLength) {
      path.lineTo(rect.left + radius, rect.bottom);
      currentLength += topEdgeLength;
    } else {
      final remaining = drawLength - currentLength;
      path.lineTo(rect.right - radius - remaining, rect.bottom);
      canvas.drawPath(path, paint);
      return;
    }
    
    // Bottom-left corner
    if (currentLength + cornerLength <= drawLength) {
      path.arcToPoint(
        Offset(rect.left, rect.bottom - radius),
        radius: Radius.circular(radius),
        clockwise: true,
      );
      currentLength += cornerLength;
    } else {
      final remaining = drawLength - currentLength;
      final sweepAngle = (remaining / cornerLength) * (3.14159 / 2);
      path.arcTo(
        Rect.fromCircle(center: Offset(rect.left + radius, rect.bottom - radius), radius: radius),
        3.14159 / 2,
        sweepAngle,
        false,
      );
      canvas.drawPath(path, paint);
      return;
    }
    
    // Left edge
    if (currentLength + rightEdgeLength <= drawLength) {
      path.lineTo(rect.left, rect.top + radius);
      currentLength += rightEdgeLength;
    } else {
      final remaining = drawLength - currentLength;
      path.lineTo(rect.left, rect.bottom - radius - remaining);
      canvas.drawPath(path, paint);
      return;
    }
    
    // Top-left corner (closing)
    if (currentLength + cornerLength <= drawLength) {
      path.arcToPoint(
        Offset(rect.left + radius, rect.top),
        radius: Radius.circular(radius),
        clockwise: true,
      );
    } else {
      final remaining = drawLength - currentLength;
      final sweepAngle = (remaining / cornerLength) * (3.14159 / 2);
      path.arcTo(
        Rect.fromCircle(center: Offset(rect.left + radius, rect.top + radius), radius: radius),
        3.14159,
        sweepAngle,
        false,
      );
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}