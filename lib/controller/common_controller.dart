import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:veenuscashbook/controller/billDetails_controller.dart';
import 'package:veenuscashbook/controller/receiptDetails_controller.dart';
import 'package:veenuscashbook/controller/salesDetails_controller.dart';
import 'package:veenuscashbook/provider/common_provider.dart';

import '../provider/companyDetails_provider.dart';
import '../utilities/baseutitiles.dart';
import '../utilities/requestconstant.dart';

class CommonController extends GetxController{

  SalesDetailController salesDetailController = Get.put(SalesDetailController());
  ReceiptDetailsController receiptDetailsController = Get.put(ReceiptDetailsController());
  BillDetailsController billDetailsController = Get.put(BillDetailsController());

  RxString Sales_autoYrsWise = "".obs;
  RxString Receipt_autoYrsWise = "".obs;
  RxString Bill_autoYrsWise = "".obs;

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
        else {
            Bill_autoYrsWise.value = value["entryAutoNo"];
            return Bill_autoYrsWise.value;
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

  void calculateErpCost(
      TextEditingController cashPortionController,
      TextEditingController accPortionController,
      TextEditingController erpCostController,
      ) {
    final double cash =
        double.tryParse(cashPortionController.text.trim()) ?? 0;

    final double ac =
        double.tryParse(accPortionController.text.trim()) ?? 0;

    final double total = cash + ac;

    erpCostController.text = total.toStringAsFixed(2);
  }

  void calculateGst(
      TextEditingController accPortionController,
      TextEditingController gstController
      ) {
    final double acPortion =
        double.tryParse(accPortionController.text.trim()) ?? 0;

    final double gst = acPortion * 18 / 100;

    gstController.text = gst.toStringAsFixed(2);
  }

  void calculateTds(
      TextEditingController accPortionController,
      TextEditingController tdsController,
      ) {
    final double accPortion =
        double.tryParse(accPortionController.text.trim()) ?? 0;

    final double tds = accPortion * 10 / 100;

    tdsController.text = tds.toStringAsFixed(2);
  }

  void calculateNetAmount() {
    final double cash =
        double.tryParse(salesDetailController.cashPortionController.text.trim()) ?? 0;

    final double acc =
        double.tryParse(salesDetailController.accPortionController.text.trim()) ?? 0;

    final double gst =
        double.tryParse(salesDetailController.gstController.text.trim()) ?? 0;

    final double netAmount = cash + acc + gst;

    salesDetailController.netAmountController.text = netAmount.toStringAsFixed(2);
  }

  void calculateBillNetAmount() {
    final double cash =
        double.tryParse(billDetailsController.billCostController.text.trim()) ?? 0;

    final double gst =
        double.tryParse(billDetailsController.gstController.text.trim()) ?? 0;

    final double netAmount = cash + gst;

    billDetailsController.netAmountController.text = netAmount.toStringAsFixed(2);
  }

  void salesTdsListener() {
    calculateTds(
      salesDetailController.accPortionController,
      salesDetailController.tdsController,
    );
  }

  void receiptTdsListener() {
    calculateTds(
      receiptDetailsController.accPortionController,
      receiptDetailsController.tdsController,
    );
  }

  void receiptERPListener() {
    calculateErpCost(
      receiptDetailsController.cashPortionController,
      receiptDetailsController.accPortionController,
      receiptDetailsController.receiptCostController,
    );
  }


  void salesERPListener() {
    calculateErpCost(
      receiptDetailsController.cashPortionController,
      receiptDetailsController.accPortionController,
      receiptDetailsController.receiptCostController,
    );
  }

  void salesGSTListener() {
    calculateGst(
      salesDetailController.accPortionController,
      salesDetailController.gstController,
    );
  }

  void billGSTListener() {
    calculateGst(
      billDetailsController.billCostController,
      billDetailsController.gstController,
    );
  }

  Future<void> DeleteAlert(
      BuildContext context,
      int index,
      String title,
      ) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Alert!'),
        content: const Text('Do you want to Delete?'),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: RequestConstant.Lable_Font_SIZE,
                        ),
                      ),
                    ),
                  ),

                  VerticalDivider(
                    color: Colors.grey.shade400,
                    width: 5,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),

                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        bool result = false;

                        if (title == "Sales Details") {
                          final id = salesDetailController
                              .SalesDetailsList[index]
                              .id;

                          result = await salesDetailController
                              .SalesDetails_List_DeleteApi(id);

                          if (result) {
                            salesDetailController
                                .SalesDetailsList
                                .removeAt(index);
                          }
                        } else if (title == "Receipt Details") {
                          final id = receiptDetailsController
                              .ReceiptDetailsList[index]
                              .id;

                          result = await receiptDetailsController
                              .ReceiptDetails_List_DeleteApi(id);

                          if (result) {
                            receiptDetailsController
                                .ReceiptDetailsList
                                .removeAt(index);
                          }
                        }else
                          {
                            final id = billDetailsController
                                .BillDetailsList[index]
                                .id;

                            result = await billDetailsController
                                .BillDetails_List_DeleteApi(id);

                            if (result) {
                              billDetailsController
                                  .BillDetailsList
                                  .removeAt(index);
                            }
                          }

                        Navigator.pop(dialogContext);
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: RequestConstant.Lable_Font_SIZE,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}