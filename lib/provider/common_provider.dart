import 'dart:convert';

import '../apimanager/apimanager.dart';
import '../utilities/apiconstant.dart';

class CommonProvider{

  static Future<dynamic> getAutoYearWise(Url) async {
    var response;
    try {
      if (Url == "SALES") {
        response = await ApiManager.getAPICall(
            "${ApiConstant.GETAUTONO_YEAR_WISE}?fieldName=SalesNo&tableName=SalesDetails&formName=Sales");
      }
      else if (Url == "RECEIPT") {
        response = await ApiManager.getAPICall(
            "${ApiConstant.GETAUTONO_YEAR_WISE}?fieldName=receiptNo&tableName=ReceiptDetails&formName=Receipt");
      }
      final data = json.decode(response);
      return data;
    } catch (error) {
      print("Error == $error");
      return null;
    }
  }
}