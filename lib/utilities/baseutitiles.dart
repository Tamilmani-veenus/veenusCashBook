import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


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

  static  Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  backgroundColor: Colors.transparent,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(BaseUtitiles.primaryColor),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Please Wait....",
                          style: TextStyle(color: Colors.white),
                        )
                      ]),
                    )
                  ]));
        });
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
}


