import '../apimanager/apimanager.dart';
import '../models/receiptDetailsList_model.dart';
import '../utilities/apiconstant.dart';

class ReceiptDetailsProvider{

  static Future<ReceiptDetailsEditResponse?> getReceiptDetails_List() async {
    try {
      var value = await ApiManager.getAPICall(
          "${ApiConstant.GETRECEIPT_DETAILSLIST}");

      return receiptDetailsEditResponseFromJson(value);

    } catch (error,E) {
      print(error);
      print("ERROR...${E}");
      return null;
    }
  }
}