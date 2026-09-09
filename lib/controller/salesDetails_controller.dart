import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    int i = 0;
    final String apiDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(SalesDate.text),
    );
    await Future.delayed(const Duration(seconds: 0));
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

    if (list != null ) {
      if(list["success"] == true){
        Fluttertoast.showToast(msg: list["message"]);
        await getSalesDetails_List();
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

  void calculateErpCost() {
    final double cash =
        double.tryParse(
          cashPortionController.text.trim(),
        ) ??
            0;

    final double ac =
        double.tryParse(
          accPortionController.text.trim(),
        ) ??
            0;

    final double total = cash + ac;

    erpCostController.text =
        total.toStringAsFixed(2);
  }

  void calculateGst() {
    final double acPortion =
        double.tryParse(accPortionController.text.trim()) ?? 0;

    final double gst = acPortion * 18 / 100;

    gstController.text = gst.toStringAsFixed(2);
  }

  void calculateTds() {
    final double acPortion =
        double.tryParse(accPortionController.text.trim()) ?? 0;

    final double tds = acPortion * 10 / 100;

    tdsController.text = tds.toStringAsFixed(2);
  }

  void calculateNetAmount() {
    final double cash =
        double.tryParse(cashPortionController.text.trim()) ?? 0;

    final double acc =
        double.tryParse(accPortionController.text.trim()) ?? 0;

    final double gst =
        double.tryParse(gstController.text.trim()) ?? 0;

    final double netAmount = cash + acc + gst;

    netAmountController.text = netAmount.toStringAsFixed(2);
  }

  Future<bool> SalesDetails_List_DeleteApi(int reqId) async {
    return SalesDetailsProvider.SalesDetails_List_deleteAPI(reqId);
  }

  Future DeleteAlert(BuildContext context, int index) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert!'),
        content: const Text('Do you want to Delete?'),
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: RequestConstant.Lable_Font_SIZE))),
                  ),
                  VerticalDivider(
                    color: Colors.grey.shade400, //color of divider
                    width: 5, //width space of divider
                    thickness: 2, //thickness of divier line
                    indent: 15, //Spacing at the top of divider.
                    endIndent: 15, //Spacing at the bottom of divider.
                  ),
                  Expanded(
                    child: TextButton(
                        onPressed: () async {
                          bool result = await SalesDetails_List_DeleteApi(SalesDetailsList.value[index].id);
                          if (result) {
                            SalesDetailsList.removeAt(index);
                            Navigator.of(context).pop();
                          }
                          else{
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text("Delete",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: RequestConstant.Lable_Font_SIZE))),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}