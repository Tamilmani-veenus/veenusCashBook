import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veenuscashbook/app_theme.dart';

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
  final String message;
  const SuccessPopup({super.key, required this.message});

  @override
  State<SuccessPopup> createState() => _SuccessPopupState();
}

class _SuccessPopupState extends State<SuccessPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _checkAnim;
  late final Animation<double> _ringAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnim = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 65,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
    ]).animate(_controller);

    _checkAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
    );

    _ringAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 240,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Expanding soft ring pulse
                        Transform.scale(
                          scale: 0.6 + (_ringAnim.value * 0.6),
                          child: Opacity(
                            opacity: (1 - _ringAnim.value).clamp(0.0, 0.4),
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accent.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                        // Green circle with checkmark
                        Transform.scale(
                          scale: _scaleAnim.value,
                          child: Container(
                            width: 68,
                            height: 68,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF34C759),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 34,
                                height: 34,
                                child: CustomPaint(
                                  painter: _CheckPainter(progress: _checkAnim.value),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Opacity(
                    opacity: _checkAnim.value,
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
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

class _CheckPainter extends CustomPainter {
  final double progress; // 0..1
  _CheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final p1 = Offset(size.width * 0.18, size.height * 0.52);
    final p2 = Offset(size.width * 0.42, size.height * 0.74);
    final p3 = Offset(size.width * 0.85, size.height * 0.28);

    final firstLeg = (progress * 2).clamp(0.0, 1.0);
    final secondLeg = ((progress - 0.5) * 2).clamp(0.0, 1.0);

    path.moveTo(p1.dx, p1.dy);
    path.lineTo(
      p1.dx + (p2.dx - p1.dx) * firstLeg,
      p1.dy + (p2.dy - p1.dy) * firstLeg,
    );

    if (secondLeg > 0) {
      path.lineTo(
        p2.dx + (p3.dx - p2.dx) * secondLeg,
        p2.dy + (p3.dy - p2.dy) * secondLeg,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
