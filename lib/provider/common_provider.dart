import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import '../apimanager/apimanager.dart';
import '../models/billReport_model.dart';
import '../models/billoutstandingReport_model.dart';
import '../models/outstandingReport_model.dart';
import '../models/receiptReport_model.dart';
import '../models/salesReport_model.dart';
import '../models/tdsReport_model.dart';
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

  static Future<SalesReportResponse?> getSalesReport(String fromDate,String toDate,int companyId) async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETSALES_REPORTLIST}?FromDate=$fromDate&ToDate=$toDate&CompanyId=$companyId");

      return salesReportResponseFromJson(value);

    } catch (error,E) {
      print(error);
      print("EEEE...${E}");
      return null;
    }
  }

  static Future<ReceiptReportDetails?> getReceiptReport(String fromDate,String toDate,int companyId) async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETRECEIPT_REPORTLIST}?FromDate=$fromDate&ToDate=$toDate&CompanyId=$companyId");

      return receiptReportDetailsFromJson(value);

    } catch (error,E) {
      print(error);
      print("EEEE...${E}");
      return null;
    }
  }

  static Future<BillReportDetails?> getBillReport(String fromDate,String toDate,int companyId) async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETBILL_REPORTLIST}?FromDate=$fromDate&ToDate=$toDate&CompanyId=$companyId");

      return billReportDetailsFromJson(value);

    } catch (error,E) {
      print(error);
      print("EEEE...${E}");
      return null;
    }
  }

  static Future<OutStandingReport?> getOutStandingReport(String fromDate,String toDate,int? financialYrId) async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETOUTSTANDING_REPORTLIST}?FromDate=$fromDate&ToDate=$toDate&FinancialYearid=$financialYrId");
      return outStandingReportFromJson(value);

    } catch (error,E) {
      print(error);
      print("EEEE...${E}");
      return null;
    }
  }

  static Future<BillOutStandingReport?> getBillOutStandingReport(String fromDate,String toDate,int? fnclYrId) async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETBILLOUTSTANDING_REPORTLIST}?FromDate=$fromDate&ToDate=$toDate&FinancialYearid=$fnclYrId");
      return billOutStandingReportFromJson(value);

    } catch (error,E) {
      print(error);
      print("EEEE...${E}");
      return null;
    }
  }

  static Future<TdsReportResponse?> getTdsReport(String fromDate,String toDate,int? fnclYrId) async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETTDS_REPORTLIST}?FromDate=$fromDate&ToDate=$toDate&FinancialYearid=$fnclYrId");
      return tdsReportResponseFromJson(value);

    } catch (error,E) {
      print(error);
      print("EEEE...${E}");
      return null;
    }
  }

  static Future<dynamic> getFinancialReport() async {
    try {
      final value = await ApiManager.getAPICall(ApiConstant.GETFINANCIAL_REPORTLIST);
      print('API Response: ${value}');
      return jsonDecode(value);

    } catch (error) {
      print("Error == $error");
      return null;
    }
  }


}