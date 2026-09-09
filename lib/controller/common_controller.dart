import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:veenuscashbook/provider/common_provider.dart';

import '../provider/companyDetails_provider.dart';
import '../utilities/baseutitiles.dart';
import '../utilities/requestconstant.dart';

class CommmonController extends GetxController{

  RxString Sales_autoYrsWise = "".obs;
  RxString Receipt_autoYrsWise = "".obs;

  RxList companyDropdown = [].obs;

  Future AutoYearWiseNo(Url) async {
    final value =await CommonProvider.getAutoYearWise(Url);
    if (value != null) {
      if(value["success"]==true) {
        if (Url == "SALES") {
          Sales_autoYrsWise.value = value["entryAutoNo"];
          return Sales_autoYrsWise.value;
        }
        else if (Url == "RECEIPT") {
          Receipt_autoYrsWise.value = value["entryAutoNo"];
          return Receipt_autoYrsWise.value;
        }
      }
      else {
        BaseUtitiles.showToast(value?.message ?? RequestConstant.NETWORKERROR);
      }
    }
    else{
      BaseUtitiles.showToast(RequestConstant.NETWORKERROR);
    }
  }

  Future getDropDownCompanyValues() async {
    companyDropdown.value = [];
    var response = await CompanyDetailsProvider.getDropDownValues("SalesDetails");
    if (response != null) {
      if (response.success == true) {
        if (response.result!.isNotEmpty) {
          companyDropdown.assignAll(response.result!);
        }
        else {
          Fluttertoast.showToast(msg: "No Data Found");
        }
      } else {
        Fluttertoast.showToast(msg:
        response.message ?? RequestConstant.NETWORKERROR);
      }
    } else {
      Fluttertoast.showToast(msg: RequestConstant.NETWORKERROR);
    }
  }

}