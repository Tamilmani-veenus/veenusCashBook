import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:veenuscashbook/provider/salesDetails_provider.dart';

import '../utilities/requestconstant.dart';

class SalesDetailController extends GetxController{

  RxList SalesDetailsList = [].obs;
  String selectedCompany = "--SELECT--";
  RxList companyDropdown = [].obs;

  Future getSalesDetails_List() async {
    SalesDetailsList.value = [];
    var response = await SalesDetailsProvider.getSalesDetails_List();
    if (response != null) {
      if (response.success == true) {
        if (response.result!.isNotEmpty) {
          SalesDetailsList.assignAll(response.result!);
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