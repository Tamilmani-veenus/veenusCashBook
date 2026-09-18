import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import '../apimanager/apimanager.dart';
import '../models/billReport_model.dart';
import '../models/receiptReport_model.dart';
import '../models/salesReport_model.dart';
import '../utilities/apiconstant.dart';
import '../utilities/requestconstant.dart';

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
      else{
        response = await ApiManager.getAPICall(
            "${ApiConstant.GETAUTONO_YEAR_WISE}?fieldName=BillNo&tableName=BillDetails&formName=Bill");
      }
      final data = json.decode(response);
      return data;
    } catch (error) {
      print("Error == $error");
      return null;
    }
  }

  static Future<bool> Details_List_deleteAPI(int reqId,String title) async {
    var response;
    try {
      if(title == "Sales"){
       response = await ApiManager.deleteAPICall(
          "${ApiConstant.SALESDETAILS_DELETE}?salesId=$reqId");
      }else if(title == "Bills"){
      response = await ApiManager.deleteAPICall(
      "${ApiConstant.BILLDETAILS_DELETE}?billId=$reqId");
      }
      else{
          response = await ApiManager.deleteAPICall(
              "${ApiConstant.RECEIPTDETAILS_DELETE}?receiptId=$reqId");
        }

      final Map<String, dynamic> decoded = jsonDecode(response);


      bool isSuccess = decoded["success"] == true;

      final message = decoded["message"] ??
          (isSuccess
              ? "Deleted successfully"
              : RequestConstant.NETWORKERROR);

      Fluttertoast.showToast(msg: message);

      return isSuccess;
    } catch (error) {
      print("Delete API Error: $error");
      Fluttertoast.showToast(msg: RequestConstant.NETWORKERROR);
      return false;
    }
  }

  static Future<SalesReportResponse?> getSalesReport(String fromDate,String toDate) async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETSALES_REPORTLIST}?FromDate=$fromDate&ToDate=$toDate");

      return salesReportResponseFromJson(value);

    } catch (error,E) {
      print(error);
      print("EEEE...${E}");
      return null;
    }
  }

  static Future<ReceiptReportDetails?> getReceiptReport(String fromDate,String toDate) async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETRECEIPT_REPORTLIST}?FromDate=$fromDate&ToDate=$toDate");

      return receiptReportDetailsFromJson(value);

    } catch (error,E) {
      print(error);
      print("EEEE...${E}");
      return null;
    }
  }

  static Future<BillReportDetails?> getBillReport(String fromDate,String toDate) async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETBILL_REPORTLIST}?FromDate=$fromDate&ToDate=$toDate");

      return billReportDetailsFromJson(value);

    } catch (error,E) {
      print(error);
      print("EEEE...${E}");
      return null;
    }
  }
}