import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:veenuscashbook/provider/receiptDetails_provider.dart';
import '../utilities/requestconstant.dart';

class ReceiptDetailsController extends GetxController{
  final ReceiptDate = TextEditingController();
  final ReceiptNoController = TextEditingController();
  final receiptCostController = TextEditingController();
  final cashPortionController = TextEditingController();
  final accPortionController = TextEditingController();
  final tdsController = TextEditingController();

  int receiptId = 0;
  int selectedCompanyId = 0;
  String selectedCompany = "--SELECT--";

  RxList ReceiptDetailsList = [].obs;

  RxString saveButton = RequestConstant.SUBMIT.obs;

  Future getReceiptDetails_List() async {
    ReceiptDetailsList.value = [];
    var response = await ReceiptDetailsProvider.getReceiptDetails_List();
    if (response != null) {
      if (response.success == true) {
        if (response.result!.isNotEmpty) {
          ReceiptDetailsList.assignAll(response.result!);
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