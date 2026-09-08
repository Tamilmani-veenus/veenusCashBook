import '../apimanager/apimanager.dart';
import '../models/salesDetailsList_model.dart';
import '../utilities/apiconstant.dart';

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
}