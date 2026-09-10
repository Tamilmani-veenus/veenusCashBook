import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../apimanager/apimanager.dart';
import '../models/companyDetailsEdit_model.dart';
import '../models/companyDetailsList_model.dart';
import '../models/dropdownCityResponse_model.dart';
import '../utilities/apiconstant.dart';
import '../utilities/requestconstant.dart';

class CompanyDetailsProvider{

  static Future<CompanyDetailsGetAllResponse?> getCompanyDetails_List() async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETCOMPANY_DETAILSLIST}");

      return companyDetailsGetAllResponseFromJson(value);
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<DropDownCityValues?> getDropDownValues(type) async {
    try {
      var value = await ApiManager.getAPICall(
          "${type == "CompanyDetails" ? ApiConstant.GETDROPDOWN_CITYLIST : ApiConstant.GETDROPDOWN_COMPANYLIST}");

      return dropDownCityValuesFromJson(value);

    } catch (error) {
      print(error);
      return null;
    }
  }

  static SaveCompanyScreenEntryAPI(String body, int CompId, context) async {

    try {
      var response;

      if (CompId != 0) {
        response = await ApiManager.putUpdateAPIButton("${ApiConstant.PUTCOMPANYDETAILS_API}?id=$CompId", body);
      } else {
        response = await ApiManager.postAPICall(ApiConstant.COMPANYDETAILS_SAVEAPI, body);
      }
      return jsonDecode(response);

    }  catch (error) {
      print("Error == $error");
      return null;
    }
  }

  static Future<CompanyDetailsEditRes?> CompanyDetails_List_editAPI(int UsageId) async {
    try {
      final response = await ApiManager.getAPICall(
          ApiConstant.EDITCOMPANY_DETAILSLIST + "?CompanyId=$UsageId");
      return companyDetailsEditResFromJson(response);
    }
    catch (error) {
      print("Error == $error");
      return null;
    }
  }

  static Future<bool> CompanyDetails_List_deleteAPI(int reqId) async {
    try {
      final response = await ApiManager.deleteAPICall(
          "${ApiConstant.COMPANYDETAILS_DELETE}?CompanyId=$reqId");

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

}