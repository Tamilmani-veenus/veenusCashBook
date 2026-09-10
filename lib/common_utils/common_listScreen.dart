import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veenuscashbook/app_theme.dart';
import 'dart:math' as math;
import '../utilities/requestconstant.dart';

class CommonRequestBottomBar extends StatelessWidget {
  final int totalCount;
  final VoidCallback onAdd;

  const CommonRequestBottomBar({
    super.key,
    required this.totalCount,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.07),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [

          // ========================================================
          // TOTAL ICON
          // ========================================================

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.bar_chart_rounded,
              color: AppColors.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

          // ========================================================
          // TOTAL
          // ========================================================

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Requests",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff667085),
                ),
              ),

              const SizedBox(height: 2),

              Row(
                children: [
                  Text(
                    "$totalCount",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 4),

                  Text(
                    totalCount==1?"Request":"Requests",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff667085),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // ========================================================
          // ADD
          // ========================================================


            SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  AppColors.primary,
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 21,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      "Add",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:
                        RequestConstant.Lable_Font_SIZE,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}



class SuccessPopup extends StatefulWidget {
  final String title;
  final String message;
  final bool isSuccess;

  const SuccessPopup({
    super.key,
    this.title = 'Submitted',
    required this.message,
    this.isSuccess = true,
  });

  @override
  State<SuccessPopup> createState() => _SuccessPopupState();
}

class _SuccessPopupState extends State<SuccessPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _iconScale;
  late final Animation<double> _ringProgress;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _ringProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.05, 0.65, curve: Curves.easeOut),
    );

    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Status-driven colors, computed once per build
  Color get _statusColor =>
      widget.isSuccess ? AppColors.primary : const Color(0xFFE24B4A);

  Color get _statusChipBg =>
      widget.isSuccess ? AppColors.lightBlue : const Color(0xFFFCEBEB);

  IconData get _statusIcon =>
      widget.isSuccess ? Icons.check_rounded : Icons.close_rounded;

  IconData get _chipIcon =>
      widget.isSuccess ? Icons.verified_rounded : Icons.error_outline_rounded;



  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 290,
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: _statusColor.withOpacity(0.12),
                    blurRadius: 35,
                    spreadRadius: 3,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated status icon
                  SizedBox(
                    width: 105,
                    height: 105,
                    child: CustomPaint(
                      painter: _SuccessRingPainter(
                        progress: _ringProgress.value,
                        color: _statusColor,
                      ),
                      child: Center(
                        child: Transform.scale(
                          scale: _iconScale.value,
                          child: Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: _statusColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _statusColor.withOpacity(0.22),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(
                              _statusIcon,
                              color: AppColors.white,
                              size: 34,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Content
                  FadeTransition(
                    opacity: _contentFade,
                    child: SlideTransition(
                      position: _contentSlide,
                      child: Column(
                        children: [
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              height: 1.5,
                              color: AppColors.subText,
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SuccessRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _SuccessRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 7;

    // Background ring
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Animated ring
    final progressPaint = Paint()
      ..color = color.withOpacity(0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );

    // Decorative dots
    const dotCount = 8;
    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * math.pi * 2;
      final dotRadius = radius + 5;
      final position = Offset(
        center.dx + math.cos(angle) * dotRadius,
        center.dy + math.sin(angle) * dotRadius,
      );

      final opacity = (progress - i * 0.06).clamp(0.0, 1.0);
      final paint = Paint()..color = color.withOpacity(0.18 * opacity);

      canvas.drawCircle(position, 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SuccessRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}