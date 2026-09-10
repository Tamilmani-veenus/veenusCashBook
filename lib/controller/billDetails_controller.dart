import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:veenuscashbook/provider/billDetails_provider.dart';

import '../entry_screen.dart';
import '../provider/common_provider.dart';
import '../utilities/requestconstant.dart';

class BillDetailsController extends GetxController{
  final BillDate = TextEditingController();
  final BillNoController = TextEditingController();
  final billCostController = TextEditingController();
  final gstController = TextEditingController();
  final netAmountController = TextEditingController();

  int receiptId = 0;

  RxList BillDetailsList = [].obs;
  RxList Bill_EditListApiValue = [].obs;

  RxString saveButton = RequestConstant.SUBMIT.obs;

  Future getBillDetails_List() async {
    BillDetailsList.value = [];
    var response = await BillDetailsProvider.getBillDetails_List();
    if (response != null) {
      if (response.success == true) {
        if (response.result!.isNotEmpty) {
          BillDetailsList.assignAll(response.result!);
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

  Future BillDetails_List_EditApi(int expenseId,String MenuName, BuildContext context) async {
    final value =
    await BillDetailsProvider.BillDetails_List_editAPI(expenseId);
    if (value != null) {
      if(value.success == true){
        saveButton.value = RequestConstant.RESUBMIT;
        Bill_EditListApiValue.value = [value.result!];
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EntryScreen(title: MenuName,)),
        );
      }else {
        Fluttertoast.showToast(msg: value.message ?? RequestConstant.NETWORKERROR);
      }
    }
    else {
      Fluttertoast.showToast(msg:RequestConstant.NETWORKERROR);
    }
  }

  Future<bool> BillDetails_List_DeleteApi(int reqId) async {
    return CommonProvider.Details_List_deleteAPI(reqId,"Bills");
  }
}