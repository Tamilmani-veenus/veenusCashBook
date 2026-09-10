import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:veenuscashbook/provider/common_provider.dart';
import 'package:veenuscashbook/provider/salesDetails_provider.dart';

import '../entry_screen.dart';
import '../models/salesDetailsSave_model.dart';
import '../provider/companyDetails_provider.dart';
import '../utilities/baseutitiles.dart';
import '../utilities/requestconstant.dart';

class SalesDetailController extends GetxController{
  final SalesDate = TextEditingController();
  final SalesNoController = TextEditingController();
  final erpCostController = TextEditingController();
  final cashPortionController = TextEditingController();
  final accPortionController = TextEditingController();
  final gstController = TextEditingController();
  final tdsController = TextEditingController();
  final netAmountController = TextEditingController();

  int salesId = 0;

  RxList SalesDetailsList = [].obs;
  String selectedCompany = "--SELECT--";
  int selectedCompanyId = 0;
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


  Future SaveButton_SalesDetails(BuildContext context, int id) async {
    final String apiDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(SalesDate.text),
    );

    String body = salesDetailsSaveResponseToJson(SalesDetailsSaveResponse(
      id: id != 0 ? id : 0,
      salesNo: SalesNoController.text,
      date: apiDate,
      companyId: selectedCompanyId,
      companyName: selectedCompany,
      cashPortion: double.tryParse(cashPortionController.text) ?? 0.0,
      erpCost: double.tryParse(erpCostController.text) ?? 0.0,
      accountPortion: double.tryParse(accPortionController.text) ?? 0.0,
      netAmount: double.tryParse(netAmountController.text) ?? 0.0,
      gst: double.tryParse(gstController.text) ?? 0.0,
      tds: double.tryParse(tdsController.text) ?? 0.0,
    ));

    final list = await SalesDetailsProvider.SaveSalesScreenEntryAPI(body, id, context);

    if (list != null) {
      if (list["success"] == true) {
        final String msg = list["message"] ?? '';
        await getSalesDetails_List();

        if (msg.toLowerCase().contains('submitted successfully')) {
          await BaseUtitiles.showSuccessAnimation(context, msg);
        } else {
          Fluttertoast.showToast(msg: msg);
        }

        BaseUtitiles.popMultiple(context, count: 3);
      } else {
        Fluttertoast.showToast(msg: list["message"] ?? RequestConstant.NETWORKERROR);
        BaseUtitiles.popMultiple(context, count: 2);
      }
    } else {
      Fluttertoast.showToast(msg: RequestConstant.NETWORKERROR);
      BaseUtitiles.popMultiple(context, count: 2);
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