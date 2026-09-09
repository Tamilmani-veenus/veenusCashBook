import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:veenuscashbook/provider/receiptDetails_provider.dart';
import '../entry_screen.dart';
import '../models/receiptDetailsSave_model.dart';
import '../provider/common_provider.dart';
import '../utilities/baseutitiles.dart';
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
  RxList Receipt_EditListApiValue = [].obs;

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

  Future SaveButton_ReceiptDetails(BuildContext context, int id) async {
    int i = 0;
    final String apiDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(ReceiptDate.text),
    );
    await Future.delayed(const Duration(seconds: 0));
    String body = receiptDetailsSaveResponseToJson(ReceiptDetailsSaveResponse(
      id: id != 0 ? id : 0,
      receiptNo: ReceiptNoController.text,
      receiptDate: apiDate,
      companyId: selectedCompanyId,
      cashPortion: double.tryParse(cashPortionController.text) ?? 0.0,
      receivedAmount: double.tryParse(receiptCostController.text) ?? 0.0,
      bankPortion: double.tryParse(accPortionController.text) ?? 0.0,
      tds: double.tryParse(tdsController.text) ?? 0.0,
    ));

    final list = await ReceiptDetailsProvider.SaveReceiptScreenEntryAPI(body, id, context);

    if (list != null ) {
      if(list["success"] == true){
        Fluttertoast.showToast(msg: list["message"]);
        await getReceiptDetails_List();
        // clearDatas();
        BaseUtitiles.popMultiple(context, count: 3);
      }
      else {
        Fluttertoast.showToast(msg: list["message"] ?? RequestConstant.NETWORKERROR);
        BaseUtitiles.popMultiple(context, count: 2);
      }
    }
    else {
      Fluttertoast.showToast(msg: RequestConstant.NETWORKERROR);
      BaseUtitiles.popMultiple(context, count: 2);
    }
  }

  Future ReceiptDetails_List_EditApi(int expenseId,String MenuName, BuildContext context) async {
    final value =
    await ReceiptDetailsProvider.ReceiptDetails_List_editAPI(expenseId);
    if (value != null) {
      if(value.success == true){
        saveButton.value = RequestConstant.RESUBMIT;
        Receipt_EditListApiValue.value = [value.result!];
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

  Future<bool> ReceiptDetails_List_DeleteApi(int reqId) async {
    return CommonProvider.Details_List_deleteAPI(reqId,"Receipt");
  }

}