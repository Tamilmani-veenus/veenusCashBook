import '../apimanager/apimanager.dart';
import '../models/billDetailsEdit_model.dart';
import '../models/billDetailsList_model.dart';
import '../utilities/apiconstant.dart';

class BillDetailsProvider{

  static Future<BillDetailsGetAllesponse?> getBillDetails_List() async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETBILL_DETAILSLIST}");

      return billDetailsGetAllesponseFromJson(value);

    } catch (error,E) {
      print(error);
      print("ERROR...${E}");
      return null;
    }
  }

  static Future<BillDetailsEditResponse?> BillDetails_List_editAPI(int UsageId) async {
    try {
      final response = await ApiManager.getAPICall(
          ApiConstant.EDITBILL_DETAILSLIST + "?billId=$UsageId");
      return billDetailsEditResponseFromJson(response);
    }
    catch (error,e) {
      print("Error == $error");
      print("ERROR .......${e}");
      return null;
    }
  }
}