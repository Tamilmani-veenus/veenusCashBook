import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:veenuscashbook/provider/billDetails_provider.dart';

import '../entry_screen.dart';
import '../models/billDetailsSave_model.dart';
import '../provider/common_provider.dart';
import '../utilities/baseutitiles.dart';
import '../utilities/requestconstant.dart';

class BillDetailsController extends GetxController{
  final BillDate = TextEditingController();
  final BillNoController = TextEditingController();
  final billCostController = TextEditingController();
  final gstController = TextEditingController();
  final gstAmtController = TextEditingController();
  final netAmountController = TextEditingController();

  int billId = 0;

  RxList BillDetailsList = [].obs;
  RxList Bill_EditListApiValue = [].obs;
  int selectedCompanyId = 0;
  String selectedCompany = "--SELECT--";
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

  Future SaveButton_BillDetails(BuildContext context, int id) async {
    int i = 0;
    final String apiDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(BillDate.text),
    );
    await Future.delayed(const Duration(seconds: 0));
    String body = billDetailsSaveResponseToJson(BillDetailsSaveResponse(
      id: id != 0 ? id : 0,
      billNo: BillNoController.text,
      billDate: apiDate,
      companyId: selectedCompanyId,
      billAmount: double.tryParse(billCostController.text) ?? 0.0,
      gst: double.tryParse(gstController.text) ?? 0.0,
      netAmount: double.tryParse(netAmountController.text) ?? 0.0,
      companyName: selectedCompany,
    ));

    final list = await BillDetailsProvider.SaveBillScreenEntryAPI(body, id, context);

    if (list != null) {
      if (list["success"] == true) {
        final bool success = list["success"] == true;
        final String msg = list["message"] ?? '';
        await getBillDetails_List();
        await BaseUtitiles.showSuccessAnimation(
          context,
          title: success ? 'Submitted' : 'Failed',
          message: msg,
          isSuccess: success,
        );

        BaseUtitiles.popMultiple(context, count: success ? 3 : 2);
      } else {
        await BaseUtitiles.showSuccessAnimation(
          context,
          title: 'Failed',
          message: RequestConstant.NETWORKERROR,
          isSuccess: false,
        );
        BaseUtitiles.popMultiple(context, count: 2);
      }
    }
    else {
      Fluttertoast.showToast(msg: RequestConstant.NETWORKERROR);
      BaseUtitiles.popMultiple(context, count: 2);
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