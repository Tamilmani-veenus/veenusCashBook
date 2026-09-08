import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:veenuscashbook/provider/companyDetails_provider.dart';

import '../utilities/requestconstant.dart';

class CompanyDetailsController extends GetxController{
  final companyNameController = TextEditingController();
  final AdressController = TextEditingController();
  final ContactNoController = TextEditingController();
  final emailController = TextEditingController();
  final GSTNoController = TextEditingController();

  RxList CompanyDetailsList = [].obs;
  RxList cityDropDown = [].obs;

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
    var response = await CompanyDetailsProvider.getDropDownValues();
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