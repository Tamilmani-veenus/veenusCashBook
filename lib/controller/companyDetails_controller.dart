import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:veenuscashbook/provider/companyDetails_provider.dart';
import '../entry_screen.dart';
import '../models/companyDetailsEdit_model.dart';
import '../models/companyDetailsList_model.dart';
import '../models/companyDetailsSave_model.dart';
import '../utilities/baseutitiles.dart';
import '../utilities/requestconstant.dart';

class CompanyDetailsController extends GetxController{
  final companyNameController = TextEditingController();
  final AdressController = TextEditingController();
  final ContactNoController = TextEditingController();
  final emailController = TextEditingController();
  final GSTNoController = TextEditingController();

  int companyId = 0;

  RxList CompanyDetailsList = [].obs;
  RxList cityDropDown = [].obs;

  String selectedCity = "--SELECT--";
  RxList<CompanyEditResult> Company_EditListApiValue = <CompanyEditResult>[].obs;

  RxString saveButton = RequestConstant.SUBMIT.obs;

  Future getCompanyDetails_List() async {
    CompanyDetailsList.value = [];
    var response = await CompanyDetailsProvider.getCompanyDetails_List();
    if (response != null) {
      if (response.success == true) {
        if (response.result!.isNotEmpty) {
          CompanyDetailsList.assignAll(response.result!);
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

  Future getDropDownCityValues() async {
    cityDropDown.value = [];
    var response = await CompanyDetailsProvider.getDropDownValues("CompanyDetails");
    if (response != null) {
      if (response.success == true) {
        if (response.result!.isNotEmpty) {
          cityDropDown.assignAll(response.result!);
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

  Future SaveButton_CompanyDetails(BuildContext context, int id) async {
    int i = 0;
    await Future.delayed(const Duration(seconds: 0));
    String body = companyDetailsSaveResponseToJson(CompanyDetailsSaveResponse(
      id: id != 0 ? id : 0,
      companyName: companyNameController.text,
      companyAddress: AdressController.text,
      city: selectedCity,
      contactNo: ContactNoController.text,
      email: emailController.text,
      gstNo: GSTNoController.text,
    ));

    final list = await CompanyDetailsProvider.SaveCompanyScreenEntryAPI(body, id, context);

    if (list != null ) {
      if(list["success"] == true){
        Fluttertoast.showToast(msg: list["message"]);
        await getCompanyDetails_List();
        // clearDatas();
        BaseUtitiles.popMultiple(context, count: 2);
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

  Future CompanyDetails_List_EditApi(int expenseId,String MenuName, BuildContext context) async {
      final value =
      await CompanyDetailsProvider.CompanyDetails_List_editAPI(expenseId);
      if (value != null) {
        if(value.success == true){
          saveButton.value = RequestConstant.RESUBMIT;
          Company_EditListApiValue.value = [value.result!];
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


  Future<bool> CompanyDetails_List_DeleteApi(int reqId) async {
    return CompanyDetailsProvider.CompanyDetails_List_deleteAPI(reqId);
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
                          bool result = await CompanyDetails_List_DeleteApi(CompanyDetailsList.value[index].id);
                          if (result) {
                            CompanyDetailsList.removeAt(index);
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