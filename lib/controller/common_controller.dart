import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:veenuscashbook/controller/billDetails_controller.dart';
import 'package:veenuscashbook/controller/receiptDetails_controller.dart';
import 'package:veenuscashbook/controller/salesDetails_controller.dart';
import 'package:veenuscashbook/provider/common_provider.dart';

import '../entry_screen.dart';
import '../models/billDetailsSave_model.dart';
import '../models/billReport_model.dart';
import '../models/billoutstandingReport_model.dart';
import '../models/outstandingReport_model.dart';
import '../models/receiptDetailsSave_model.dart';
import '../models/receiptReport_model.dart';
import '../models/salesDetailsSave_model.dart';
import '../models/salesReport_model.dart';
import '../provider/billDetails_provider.dart';
import '../provider/companyDetails_provider.dart';
import '../provider/receiptDetails_provider.dart';
import '../provider/salesDetails_provider.dart';
import '../utilities/baseutitiles.dart';
import '../utilities/requestconstant.dart';

class CommonController extends GetxController{

  SalesDetailController salesDetailController = Get.put(SalesDetailController());
  ReceiptDetailsController receiptDetailsController = Get.put(ReceiptDetailsController());
  BillDetailsController billDetailsController = Get.put(BillDetailsController());

  final RptFromDate = TextEditingController();
  final RptToDate = TextEditingController();


  RxString Sales_autoYrsWise = "".obs;
  RxString Receipt_autoYrsWise = "".obs;
  RxString Bill_autoYrsWise = "".obs;
  RxList gstDropdown = [].obs;
  RxList tdsDropdown = [].obs;
  RxList companyDropdown = [].obs;
  var selectedGstPercentage = Rxn<double>();
  var selectedTdsPercentage = Rxn<double>();

  RxList<SalesResult> salesReportList = <SalesResult>[].obs;
  RxList<ReceiptResult> receiptReportList = <ReceiptResult>[].obs;
  RxList<BillResult> billReportList = <BillResult>[].obs;

  RxString selectedCompany = "--SELECT--".obs;
  RxInt selectedCompanyId = 0.obs;


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

  Future getDropDownGSTValues() async {
    gstDropdown.value = [];
    var response = await CompanyDetailsProvider.getDropDownGST_TDSValues("GST");
    if (response != null) {
      if (response.success == true) {
        if (response.messge!.isNotEmpty) {
          gstDropdown.assignAll(response.messge!);
          final defaultGst = gstDropdown.firstWhere(
                (gst) => gst.percentage == 18,
            orElse: () => gstDropdown.first,
          );

          selectedGstPercentage.value =
              (defaultGst.percentage ?? 0).toDouble();
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

  Future getDropDownTDSValues() async {
    tdsDropdown.value = [];
    var response = await CompanyDetailsProvider.getDropDownGST_TDSValues("TDS");
    if (response != null) {
      if (response.success == true) {
        if (response.messge!.isNotEmpty) {
          tdsDropdown.assignAll(response.messge!);
          final defaultTds = tdsDropdown.firstWhere(
                (tds) => tds.percentage == 10,
            orElse: () => tdsDropdown.first,
          );

          selectedTdsPercentage.value =
              (defaultTds.percentage ?? 0).toDouble();
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

  Future SaveButton_SalesDetails(BuildContext context, int id) async {
    final String apiDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(salesDetailController.SalesDate.text),
    );

    String body = salesDetailsSaveResponseToJson(SalesDetailsSaveResponse(
      id: id != 0 ? id : 0,
      salesNo: salesDetailController.SalesNoController.text,
      date: apiDate,
      companyId: selectedCompanyId.value,
      companyName: selectedCompany.value,
      cashPortion: double.tryParse(salesDetailController.cashPortionController.text) ?? 0.0,
      erpCost: double.tryParse(salesDetailController.erpCostController.text) ?? 0.0,
      accountPortion: double.tryParse(salesDetailController.accPortionController.text) ?? 0.0,
      netAmount: double.tryParse(salesDetailController.netAmountController.text) ?? 0.0,
      gst: double.tryParse(salesDetailController.gstAmtController.text) ?? 0.0,
      gstPercentage: selectedGstPercentage.value,
      tds: double.tryParse(salesDetailController.tdsAmtController.text) ?? 0.0,
      tdsPercentage: selectedTdsPercentage.value,
      tdsCheck: salesDetailController.isTdsEnabled.value,
    ));

    final list = await SalesDetailsProvider.SaveSalesScreenEntryAPI(body, id, context);

    if (list != null) {
      if (list["success"] == true) {
        final bool success = list["success"] == true;
        final String msg = list["message"] ?? '';
        await salesDetailController.getSalesDetails_List();

        await BaseUtitiles.showSuccessAnimation(
          context,
          title: success
              ? (salesDetailController.saveButton.value == RequestConstant.SUBMIT
              ? "Submitted"
              : salesDetailController.saveButton.value == RequestConstant.RESUBMIT
              ? "Updated"
              : "Submitted")
              : "Failed",
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
    } else {
      Fluttertoast.showToast(msg: RequestConstant.NETWORKERROR);
      BaseUtitiles.popMultiple(context, count: 2);
    }
  }

  Future SaveButton_BillDetails(BuildContext context, int id) async {
    int i = 0;
    final String apiDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(billDetailsController.BillDate.text),
    );
    await Future.delayed(const Duration(seconds: 0));
    String body = billDetailsSaveResponseToJson(BillDetailsSaveResponse(
      id: id != 0 ? id : 0,
      billNo: billDetailsController.BillNoController.text,
      billDate: apiDate,
      companyId: selectedCompanyId.value,
      billAmount: double.tryParse(billDetailsController.billCostController.text) ?? 0.0,
      gst: double.tryParse(billDetailsController.gstAmtController.text) ?? 0.0,
      gstPercentage: selectedGstPercentage.value,
      netAmount: double.tryParse(billDetailsController.netAmountController.text) ?? 0.0,
      companyName: selectedCompany.value,
    ));

    final list = await BillDetailsProvider.SaveBillScreenEntryAPI(body, id, context);

    if (list != null) {
      if (list["success"] == true) {
        final bool success = list["success"] == true;
        final String msg = list["message"] ?? '';
        await billDetailsController.getBillDetails_List();
        await BaseUtitiles.showSuccessAnimation(
          context,
          title: success
              ? (billDetailsController.saveButton.value == RequestConstant.SUBMIT
              ? "Submitted"
              : billDetailsController.saveButton.value == RequestConstant.RESUBMIT
              ? "Updated"
              : "Submitted")
              : "Failed",
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

  Future SaveButton_ReceiptDetails(BuildContext context, int id) async {
    int i = 0;
    final String apiDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(receiptDetailsController.ReceiptDate.text),
    );
    await Future.delayed(const Duration(seconds: 0));
    String body = receiptDetailsSaveResponseToJson(ReceiptDetailsSaveResponse(
      id: id != 0 ? id : 0,
      receiptNo: receiptDetailsController.ReceiptNoController.text,
      receiptDate: apiDate,
      companyId: selectedCompanyId.value,
      companyName: selectedCompany.value,
      cashPortion: double.tryParse(receiptDetailsController.cashPortionController.text) ?? 0.0,
      receivedAmount: double.tryParse(receiptDetailsController.receiptCostController.text) ?? 0.0,
      bankPortion: double.tryParse(receiptDetailsController.accPortionController.text) ?? 0.0,
      tds: double.tryParse(receiptDetailsController.tdsAmtController.text) ?? 0.0,
        tdsPercentage: selectedTdsPercentage.value,
        gst: double.tryParse(receiptDetailsController.gstAmtController.text) ?? 0.0,
        gstPercentage: selectedGstPercentage.value,
      tdsCheck: receiptDetailsController.isTdsEnabled.value
    ));

    final list = await ReceiptDetailsProvider.SaveReceiptScreenEntryAPI(body, id, context);

    if (list != null) {
      if (list["success"] == true) {
        final bool success = list["success"] == true;
        final String msg = list["message"] ?? '';
        await receiptDetailsController.getReceiptDetails_List();

        await BaseUtitiles.showSuccessAnimation(
          context,
          title: success
              ? (receiptDetailsController.saveButton.value == RequestConstant.SUBMIT
              ? "Submitted"
              : receiptDetailsController.saveButton.value == RequestConstant.RESUBMIT
              ? "Updated"
              : "Submitted")
              : "Failed",
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


  // Future getSalesReport() async {
  //   salesReportList.value = [];
  //   var response = await CommonProvider.getSalesReport(salesRptFromDate.text,salesRptToDate.text);
  //   if (response != null) {
  //     if (response.success == true) {
  //         salesReportList.assignAll(response.!);
  //
  //
  //     } else {
  //       Fluttertoast.showToast(msg:
  //       response.message ?? RequestConstant.NETWORKERROR);
  //     }
  //   } else {
  //     Fluttertoast.showToast(msg: RequestConstant.NETWORKERROR);
  //   }
  // }

  String apiDate(String date) {
    return DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(date),
    );
  }

  static String formatApiDate(String date) {
    final parts = date.split('-');

    if (parts.length != 3) return date;

    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  Future getSalesReport() async {
    salesReportList.value = [];
    final String fromDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(
        RptFromDate.text,
      ),
    );

    final String toDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(
        RptToDate.text,
      ),
    );
      SalesReportResponse? response = await CommonProvider.getSalesReport(fromDate, toDate,selectedCompanyId.value);
      if (response != null) {
        if(response.success == true) {
          salesReportList.assignAll(response.result ?? []);
        }else {
          Fluttertoast.showToast(msg:
          response.message ?? RequestConstant.NETWORKERROR);
        }
      } else {
        Fluttertoast.showToast(msg: RequestConstant.NETWORKERROR);
      }
  }

  Future getReceiptReport() async {
    receiptReportList.value = [];
    final String fromDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(
        RptFromDate.text,
      ),
    );

    final String toDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(
        RptToDate.text,
      ),
    );
    ReceiptReportDetails? response = await CommonProvider.getReceiptReport(fromDate, toDate,selectedCompanyId.value);
    if (response != null) {
      if(response.success == true) {
        receiptReportList.assignAll(response.result ?? []);
      }else {
        Fluttertoast.showToast(msg:
        response.message ?? RequestConstant.NETWORKERROR);
      }
    } else {
      Fluttertoast.showToast(msg: RequestConstant.NETWORKERROR);
    }
  }

  Future getBillReport() async {
    billReportList.value = [];
    final String fromDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(
        RptFromDate.text,
      ),
    );

    final String toDate = DateFormat('yyyy-MM-dd').format(
      DateFormat('dd/MM/yyyy').parse(
        RptToDate.text,
      ),
    );
    BillReportDetails? response = await CommonProvider.getBillReport(fromDate, toDate,selectedCompanyId.value);
    if (response != null) {
      if(response.success == true) {
        billReportList.assignAll(response.result ?? []);
      }else {
        Fluttertoast.showToast(msg:
        response.message ?? RequestConstant.NETWORKERROR);
      }
    } else {
      Fluttertoast.showToast(msg: RequestConstant.NETWORKERROR);
    }
  }

  RxList outstandingList = [].obs;
  RxList billOutstandingList = [].obs;

  Rxn<OverallTotal> overallTotal = Rxn<OverallTotal>();
  Rxn<BillOverallTotal> overallBillTotal = Rxn<BillOverallTotal>();


  Future getOutStandingReport() async {
    outstandingList.value = [];
    overallTotal.value = null;
    final response =
      await CommonProvider.getOutStandingReport("2025-01-01","2026-09-22"
        // RptFromDate.text, RptToDate.text,
      );

      if (response != null){
        if(response.success == true) {
        outstandingList.value =
            response.data ?? [];

        overallTotal.value =
            response.overallTotal;
      }else {
          Fluttertoast.showToast(msg:
          response.message ?? RequestConstant.NETWORKERROR);
        } }else {
        Fluttertoast.showToast(msg: RequestConstant.NETWORKERROR);
      }
  }

  Future getBillOutStandingReport() async {
    billOutstandingList.value = [];
    overallBillTotal.value = null;
    final response =
    await CommonProvider.getBillOutStandingReport("2025-01-01","2026-09-22"
      // RptFromDate.text, RptToDate.text,
    );

    if (response != null){
      if(response.success == true) {
        billOutstandingList.value =
            response.data ?? [];

        overallBillTotal.value =
            response.overallTotal;
      }else {
        Fluttertoast.showToast(msg:
        response.message ?? RequestConstant.NETWORKERROR);
      } }else {
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

  // void calculateGst(
  //     TextEditingController accPortionController,
  //     TextEditingController gstController
  //     ) {
  //   final double acPortion =
  //       double.tryParse(accPortionController.text.trim()) ?? 0;
  //
  //   final double gst = acPortion * 18 / 100;
  //
  //   gstController.text = gst.toStringAsFixed(2);
  // }

  void calculateGst(
      TextEditingController accPortionController,
      TextEditingController gstAmountController,
      double? gstPercentage,
      ) {
    final double acPortion = double.tryParse(accPortionController.text.trim()) ?? 0;
    final double percentage = gstPercentage ?? 0;

    final double gst = acPortion * percentage / 100;

    gstAmountController.text = gst.toStringAsFixed(2);
  }

  void calculateTds(
      TextEditingController accPortionController,
      TextEditingController tdsAmountController,
      double? tdsPercentage,
      ) {
    final double acPortion = double.tryParse(accPortionController.text.trim()) ?? 0;
    final double percentage = tdsPercentage ?? 0;

    final double tds = acPortion * percentage / 100;

    tdsAmountController.text = tds.toStringAsFixed(2);
  }



  void calculateNetAmount() {
    final double cash =
        double.tryParse(salesDetailController.cashPortionController.text.trim()) ?? 0;

    final double acc =
        double.tryParse(salesDetailController.accPortionController.text.trim()) ?? 0;

    final double gst =
        double.tryParse(salesDetailController.gstAmtController.text.trim()) ?? 0;

    final double netAmount = cash + acc + gst;

    salesDetailController.netAmountController.text = netAmount.toStringAsFixed(2);
  }

  void calculateBillNetAmount() {
    final double cash =
        double.tryParse(billDetailsController.billCostController.text.trim()) ?? 0;

    final double gst =
        double.tryParse(billDetailsController.gstAmtController.text.trim()) ?? 0;

    final double netAmount = cash + gst;

    billDetailsController.netAmountController.text = netAmount.toStringAsFixed(2);
  }

  void salesTdsListener() {
    calculateTds(
      salesDetailController.accPortionController,
      salesDetailController.tdsAmtController,
        selectedTdsPercentage.value
    );
  }

  void receiptTdsListener() {
    calculateTds(
      receiptDetailsController.accPortionController,
      receiptDetailsController.tdsAmtController,
        selectedTdsPercentage.value
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
      salesDetailController.gstAmtController,
      selectedGstPercentage.value,
    );
  }

  void billGSTListener() {
    calculateGst(
      billDetailsController.billCostController,
      billDetailsController.gstAmtController,
      selectedGstPercentage.value,
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