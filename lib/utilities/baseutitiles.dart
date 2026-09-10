import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:veenuscashbook/app_theme.dart';
import 'dart:math' as math;
import '../common_utils/common_listScreen.dart';


String? punchStatus;
bool punchIn = false;

class BaseUtitiles {
  static var deviceName;
  static var deviceVersion;
  static var identifier;
  static RxList dummyListData=[].obs;

  static const Color primaryColor = Color(0xFF4A3AFF);

  static double getheightofPercentage(BuildContext context, int percentage) {
    double _height = MediaQuery.of(context).size.height;
    return (_height / 100) * percentage;
  }

  static double getWidthtofPercentage(BuildContext context, int percentage) {
    double _width = MediaQuery.of(context).size.width;
    return (_width / 100) * percentage;
  }

  String formatAmount(String? value) {
    if (value == null || value.isEmpty) return "0";

    // Extract number and optional suffix (L, CR, etc.)
    final parts = value.trim().split(' ');

    final number = double.tryParse(parts[0]);
    if (number == null) return value;

    final formattedNumber = number % 1 == 0
        ? number.toInt().toString()
        : number.toStringAsFixed(2);

    if (parts.length > 1) {
      return "$formattedNumber ${parts.sublist(1).join(' ')}";
    }

    return formattedNumber;
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }


  static showToast(String message) => Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG,);

  static Future<List<String>> getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.id; //UUID for Android
        // identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    return [deviceName!, deviceVersion!, identifier!];
  }

  String convertToUtcIso(String date) {
    final parsedDate = DateTime.parse(date);
    final now = DateTime.now();

    final localDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
    );

    return localDateTime.toUtc().toIso8601String();
  }



  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  static String formatApiDate(String date) {
    final parts = date.split('-');

    if (parts.length != 3) return date;

    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  static void popMultiple(BuildContext context, {int count = 1}) {
    for (int i = 0; i < count; i++) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  static String initiateCurrentDateFormat(){
    DateTime dateTime = DateTime.now();
    var month = dateTime.month.toString().padLeft(2, '0');
    var day = dateTime.day.toString().padLeft(2, '0');
    var dateformateTime = '${dateTime.year}-$month-$day ${dateTime.hour}:${dateTime.minute}';
    var dateformate = '${dateTime.year}-$month-$day';
    return dateformate;
  }

  static String selectDateFormat(DateTime selectDate){

    var month = selectDate.month.toString().padLeft(2, '0');
    var day = selectDate.day.toString().padLeft(2, '0');
    var dateformateTime = '${selectDate.year}-$month-$day ${selectDate.hour}:${selectDate.minute}';
    var dateformate = '${selectDate.year}-$month-$day';
    return dateformate;
  }

  static Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.40),
      builder: (BuildContext context) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: _ModernLoadingCard(),
          ),
        );
      },
    );
  }

  static Future<bool> isConnectedToNetwork() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static Future<bool> checkNetworkAndShowLoader(BuildContext context) async {
    if (await isConnectedToNetwork()) {
      showLoadingDialog(context);
      return true;
    } else {
      Fluttertoast.showToast(msg: "No Internet Connection. Please check your network.");
      return false;
    }
  }

  static Future<void> showSuccessAnimation(
      BuildContext context, {
        String title = 'Submitted',
        required String message,
        bool isSuccess = true,
        Duration displayDuration = const Duration(milliseconds: 1600),
      }) async {
    if (!context.mounted) return;

    showGeneralDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) => SuccessPopup(
        title: title,
        message: message,
        isSuccess: isSuccess,
      ),
      transitionBuilder: (context, anim, secondaryAnim, child) {
        return FadeTransition(opacity: anim, child: child);
      },
    );

    await Future.delayed(displayDuration);
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

class _ModernLoadingCard extends StatefulWidget {
  const _ModernLoadingCard();

  @override
  State<_ModernLoadingCard> createState() => _ModernLoadingCardState();
}

class _ModernLoadingCardState extends State<_ModernLoadingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 185,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.16),
              blurRadius: 35,
              spreadRadius: 2,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 58,
              height: 58,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: _controller,
                    child: CustomPaint(
                      size: const Size(58, 58),
                      painter: _LoaderRingPainter(
                        color: primary,
                      ),
                    ),
                  ),

                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary.withOpacity(.10),
                    ),
                    child: Icon(
                      Icons.sync_rounded,
                      size: 21,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Text(
              "Please Wait",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade900,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              "Processing your request",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: 90,
              child: LinearProgressIndicator(
                minHeight: 3,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: primary.withOpacity(.10),
                valueColor: AlwaysStoppedAnimation<Color>(primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoaderRingPainter extends CustomPainter {
  final Color color;

  _LoaderRingPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width / 2 - 4;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = color.withOpacity(.18);

    canvas.drawCircle(
      center,
      radius,
      paint,
    );

    paint.color = color;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -math.pi / 2,
      math.pi * 1.25,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _LoaderRingPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
