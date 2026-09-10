import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import '../apimanager/apimanager.dart';
import '../models/salesDetailsEdit_model.dart';
import '../models/salesDetailsList_model.dart';
import '../utilities/apiconstant.dart';
import '../utilities/requestconstant.dart';

class SalesDetailsProvider{

  static Future<SalesDetailsGetAllResponse?> getSalesDetails_List() async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETSALES_DETAILSLIST}");

      return salesDetailsGetAllResponseFromJson(value);

    } catch (error,E) {
      print(error);
      print("ERROR...${E}");
      return null;
    }
  }

  static SaveSalesScreenEntryAPI(String body, int SaleId, context) async {

    try {
      var response;

      if (SaleId != 0) {
        response = await ApiManager.putUpdateAPIButton("${ApiConstant.PUTSALESDETAILS_API}?id=$SaleId", body);
      } else {
        response = await ApiManager.postAPICall(ApiConstant.SALESDETAILS_SAVEAPI, body);
      }
      return jsonDecode(response);

    }  catch (error) {
      print("Error == $error");
      return null;
    }
  }

  static Future<SalesDetailsEditResponse?> SalesDetails_List_editAPI(int UsageId) async {
    try {
      final response = await ApiManager.getAPICall(
          ApiConstant.EDITSALES_DETAILSLIST + "?SalesId=$UsageId");
      return salesDetailsEditResponseFromJson(response);
    }
    catch (error,e) {
      print("Error == $error");
      print("ERROR .......${e}");
      return null;
    }
  }

}