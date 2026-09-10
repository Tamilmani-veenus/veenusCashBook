import 'dart:convert';

import '../apimanager/apimanager.dart';
import '../models/receiptDetailsEdit_model.dart';
import '../models/receiptDetailsList_model.dart';
import '../utilities/apiconstant.dart';

class ReceiptDetailsProvider{

  static Future<ReceiptDetailsGetAllResponse?> getReceiptDetails_List() async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETRECEIPT_DETAILSLIST}");

      return receiptDetailsGetAllResponseFromJson(value);

    } catch (error,E) {
      print(error);
      print("ERROR...${E}");
      return null;
    }
  }

  static SaveReceiptScreenEntryAPI(String body, int id, context) async {

    try {
      var response;

      if (id != 0) {
        response = await ApiManager.putUpdateAPIButton("${ApiConstant.PUTRECEIPTDETAILS_API}?id=$id", body);
      } else {
        response = await ApiManager.postAPICall(ApiConstant.RECEIPTDETAILS_SAVEAPI, body);
      }
      return jsonDecode(response);

    }  catch (error) {
      print("Error == $error");
      return null;
    }
  }

  static Future<ReceiptDetailsEditesponse?> ReceiptDetails_List_editAPI(int UsageId) async {
    try {
      final response = await ApiManager.getAPICall(
          ApiConstant.EDITRECEIPT_DETAILSLIST + "?receiptId=$UsageId");
      return receiptDetailsEditesponseFromJson(response);
    }
    catch (error,e) {
      print("Error == $error");
      print("ERROR .......${e}");
      return null;
    }
  }

}