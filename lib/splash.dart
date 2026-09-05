import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController logoController;
  late AnimationController flowController;

  late Animation<double> logoScale;
  late Animation<double> logoOpacity;
  late Animation<double> textOpacity;
  @override
  void initState() {
    super.initState();

    // Logo animation
    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    logoScale = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: logoController,
        curve: Curves.easeOutBack,
      ),
    );

    logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: logoController,
        curve: Curves.easeIn,
      ),
    );

    textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: logoController,
        curve: const Interval(
          0.4,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );

    // Cash flow animation
    flowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    logoController.forward();

    Future.delayed(
      const Duration(milliseconds: 700),
          () {
        if (mounted) {
          flowController.repeat();
        }
      },
    );

    // Navigate after splash
    Future.delayed(
      const Duration(seconds: 3),
          () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const CashBookHomeScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    logoController.dispose();
    flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,

        child: SafeArea(
          child: Column(
            children: [

              const Spacer(),

              /// LOGO
              FadeTransition(
                opacity: logoOpacity,
                child: ScaleTransition(
                  scale: logoScale,
                  child: Image.asset(
                    'assets/drawerimg.png',
                    height: 200,
                  ),
                ),
              ),

              // const SizedBox(height: 18),
              //
              // /// APP NAME
              // FadeTransition(
              //   opacity: textOpacity,
              //   child: const Text(
              //     'CashBook',
              //     style: TextStyle(
              //       fontFamily: 'Poppins',
              //       fontSize: 28,
              //       fontWeight: FontWeight.w700,
              //       letterSpacing: -0.5,
              //     ),
              //   ),
              // ),
              //
              // const SizedBox(height: 8),

              /// TAGLINE
              FadeTransition(
                opacity: textOpacity,
                child: const Text(
                  'Track. Manage. Grow.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 45),

              /// CASH FLOW
              SizedBox(
                height: 55,
                width: 280,
                child: AnimatedBuilder(
                  animation: flowController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: CashFlowPainter(
                        progress: flowController.value,
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: FadeTransition(
                  opacity: textOpacity,
                  child: const Text(
                    'Smart Cash Management',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CashFlowPainter extends CustomPainter {
  final double progress;

  CashFlowPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(0, size.height * 0.65);

    path.cubicTo(
      size.width * 0.20,
      size.height * 0.10,
      size.width * 0.35,
      size.height * 0.90,
      size.width * 0.52,
      size.height * 0.45,
    );

    path.cubicTo(
      size.width * 0.68,
      0,
      size.width * 0.82,
      size.height * 0.85,
      size.width,
      size.height * 0.35,
    );

    final pathMetrics = path.computeMetrics().first;

    final animatedPath = pathMetrics.extractPath(
      0,
      pathMetrics.length * progress,
    );

    canvas.drawPath(animatedPath, paint);

    /// Moving ₹ symbol
    final tangent = pathMetrics.getTangentForOffset(
      pathMetrics.length * progress,
    );

    if (tangent != null) {
      final textPainter = TextPainter(
        text: const TextSpan(
          text: '₹',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        tangent.position -
            Offset(
              textPainter.width / 2,
              textPainter.height / 2,
            ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CashFlowPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}