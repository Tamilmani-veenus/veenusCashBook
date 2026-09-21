import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:veenuscashbook/provider/common_provider.dart';
import 'package:veenuscashbook/provider/salesDetails_provider.dart';
import '../entry_screen.dart';
import '../models/salesDetailsSave_model.dart';
import '../utilities/baseutitiles.dart';
import '../utilities/requestconstant.dart';

class SalesDetailController extends GetxController{

  final SalesDate = TextEditingController();
  final SalesNoController = TextEditingController();
  final erpCostController = TextEditingController();
  final cashPortionController = TextEditingController();
  final accPortionController = TextEditingController();
  final gstAmtController = TextEditingController();
  final netAmountController = TextEditingController();
  final tdsAmtController = TextEditingController();

  int salesId = 0;
  final RxBool isTdsEnabled = false.obs;

  RxList SalesDetailsList = [].obs;
  RxList Sales_EditListApiValue = [].obs;

  RxString saveButton = RequestConstant.SUBMIT.obs;

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


  Future SalesDetails_List_EditApi(int expenseId,String MenuName, BuildContext context) async {
    final value =
    await SalesDetailsProvider.SalesDetails_List_editAPI(expenseId);
    if (value != null) {
      if(value.success == true){
        saveButton.value = RequestConstant.RESUBMIT;
        Sales_EditListApiValue.value = [value.result!];
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


  Future<bool> SalesDetails_List_DeleteApi(int reqId) async {
    return CommonProvider.Details_List_deleteAPI(reqId,"Sales");
  }
}