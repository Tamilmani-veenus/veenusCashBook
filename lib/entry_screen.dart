import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:veenuscashbook/controller/billDetails_controller.dart';
import 'package:veenuscashbook/controller/common_controller.dart';
import 'package:veenuscashbook/controller/companyDetails_controller.dart';
import 'package:veenuscashbook/controller/receiptDetails_controller.dart';
import 'package:veenuscashbook/controller/salesDetails_controller.dart';
import 'package:veenuscashbook/utilities/baseutitiles.dart';
import 'package:veenuscashbook/utilities/requestconstant.dart';
import 'app_theme.dart';
import 'package:intl/intl.dart';

class EntryScreen extends StatefulWidget {
  final String title;

  const EntryScreen({
    super.key,
    required this.title,
  });

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  CompanyDetailsController companyDetailsController = Get.put(CompanyDetailsController());
  SalesDetailController salesDetailController = Get.put(SalesDetailController());
  ReceiptDetailsController receiptDetailsController = Get.put(ReceiptDetailsController());
  BillDetailsController billDetailsController = Get.put(BillDetailsController());
  CommonController commmonController = Get.put(CommonController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isReceiptTdsEnabled = false;
  String oldTdsAmount = '0.00';

  @override
  void initState() {
    super.initState();
    var duration = const Duration(seconds:0);
    Future.delayed(duration,() async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        companyDetailsController.getDropDownCityValues();
        commmonController.getDropDownCompanyValues();
      });
      if (widget.title == "Company Details") {
        if(companyDetailsController.saveButton.value == RequestConstant.RESUBMIT) {
          companyDetailsController.Company_EditListApiValue.forEach((element) {
            companyDetailsController.companyId=element.id!;
            companyDetailsController.companyNameController.text = element.companyName;
            companyDetailsController.CompanyDate.text = DateFormat('dd/MM/yyyy').format(
                DateFormat('yyyy-MM-dd').parse(element.companyDate));
            companyDetailsController.AdressController.text = element.companyAddress;
            companyDetailsController.ContactNoController.text = element.contactNo.toString();
            companyDetailsController.selectedCity = element.city.toString();
            companyDetailsController.emailController.text = element.email.toString();
            companyDetailsController.GSTNoController.text = element.gstNo.toString();
          });
        }

        else if(companyDetailsController.saveButton.value ==RequestConstant.SUBMIT){
          companyDetailsController.companyId = 0;
          companyDetailsController.companyNameController.text = "";
          companyDetailsController.CompanyDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
          companyDetailsController.AdressController.text = "";
          companyDetailsController.ContactNoController.text = "";
          companyDetailsController.selectedCity = "--SELECT--";
          companyDetailsController.emailController.text = "";
          companyDetailsController.GSTNoController.text = "";
        }
      }

      else if (widget.title == "Sales Details") {
        if(salesDetailController.saveButton.value == RequestConstant.RESUBMIT) {
          await commmonController.getDropDownGSTValues();
          await commmonController.getDropDownTDSValues();
          salesDetailController.Sales_EditListApiValue.forEach((element) {
            salesDetailController.salesId=element.id!;
            salesDetailController.SalesNoController.text = element.salesNo;
            commmonController.selectedCompanyId.value = element.companyId;
            commmonController.selectedCompany.value = element.companyName;
            salesDetailController.SalesDate.text = DateFormat('dd/MM/yyyy').format(
                DateFormat('yyyy-MM-dd').parse(element.date));
            salesDetailController.erpCostController.text = element.erpCost.toString();
            salesDetailController.cashPortionController.text = element.cashPortion.toString();
            salesDetailController.accPortionController.text = element.accountPortion.toString();
            commmonController.selectedGstPercentage.value = element.gstPercentage;
            salesDetailController.gstAmtController.text = element.gst.toString();
            commmonController.selectedTdsPercentage.value = element.tdsPercentage;
            salesDetailController.tdsAmtController.text = element.tds.toString();
            salesDetailController.netAmountController.text = element.netAmount.toString();
            salesDetailController.isTdsEnabled.value = element.tdsCheck;
            salesDetailController.tdsnetAmountController.text = element.netPayAmt.toString();
            // salesDetailController.isTdsEnabled.value =
            //     (element.tds ?? 0) > 0;
          });
        }

        else if(salesDetailController.saveButton.value ==RequestConstant.SUBMIT){
          await commmonController.getDropDownGSTValues();
          await commmonController.getDropDownTDSValues();
          salesDetailController.salesId=0;
          await commmonController.AutoYearWiseNo("SALES");
          salesDetailController.SalesNoController.text = commmonController.Sales_autoYrsWise.value;
          commmonController.selectedCompanyId.value = 0;
          commmonController.selectedCompany.value = "--SELECT--";
          salesDetailController.SalesDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
          salesDetailController.erpCostController.text = "0.0";
          salesDetailController.cashPortionController.text = "0.0";
          salesDetailController.accPortionController.text = "0.0";
          salesDetailController.gstAmtController.text = "0.0";
          salesDetailController.tdsAmtController.text = "0.0";
          salesDetailController.netAmountController.text = "0.0";
          salesDetailController.isTdsEnabled.value = false;
          salesDetailController.tdsnetAmountController.text = "0.0";
        }
      }

      else if (widget.title == "Receipt Details") {
        if(receiptDetailsController.saveButton.value == RequestConstant.RESUBMIT) {
          await commmonController.getDropDownGSTValues();
          await commmonController.getDropDownTDSValues();
          receiptDetailsController.Receipt_EditListApiValue.forEach((element) {
            receiptDetailsController.receiptId=element.id!;
            receiptDetailsController.ReceiptNoController.text = element.receiptNo;
            commmonController.selectedCompanyId.value = element.companyId;
            commmonController.selectedCompany.value = element.companyName;
            receiptDetailsController.ReceiptDate.text = DateFormat('dd/MM/yyyy').format(
                DateFormat('yyyy-MM-dd').parse(element.date));
            receiptDetailsController.receiptCostController.text = element.receivedAmount.toString();
            receiptDetailsController.cashPortionController.text = element.cashPortion.toString();
            receiptDetailsController.accPortionController.text = element.bankPortion.toString();
            commmonController.selectedGstPercentage.value = element.gstPercentage;
            receiptDetailsController.gstAmtController.text = element.gst.toString();
            commmonController.selectedTdsPercentage.value = element.tdsPercentage;
            receiptDetailsController.tdsAmtController.text = element.tds.toString();
            receiptDetailsController.isTdsEnabled.value = element.tdsCheck;
            receiptDetailsController.netAmountController.text = element.netAmount.toString();
          });
        }

        else if(receiptDetailsController.saveButton.value ==RequestConstant.SUBMIT){
          await commmonController.getDropDownGSTValues();
          await commmonController.getDropDownTDSValues();
          receiptDetailsController.receiptId=0;
          await commmonController.AutoYearWiseNo("RECEIPT");
          receiptDetailsController.ReceiptNoController.text = commmonController.Receipt_autoYrsWise.value;
          commmonController.selectedCompanyId.value = 0;
          commmonController.selectedCompany.value = "--SELECT--";
          receiptDetailsController.ReceiptDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
          receiptDetailsController.receiptCostController.text = "0.0";
          receiptDetailsController.cashPortionController.text = "0.0";
          receiptDetailsController.gstAmtController.text = "0.0";
          receiptDetailsController.accPortionController.text = "0.0";
          receiptDetailsController.tdsAmtController.text = "0.0";
          receiptDetailsController.isTdsEnabled.value = false;
          receiptDetailsController.netAmountController.text = "0.0";
        }
      }

      else if (widget.title == "Bill Details") {
        if(billDetailsController.saveButton.value == RequestConstant.RESUBMIT) {
          await commmonController.getDropDownGSTValues();
          billDetailsController.Bill_EditListApiValue.forEach((element) {
            billDetailsController.billId=element.id!;
            billDetailsController.BillNoController.text = element.billNo;
            commmonController.selectedCompanyId.value = element.companyId;
            commmonController.selectedCompany.value = element.companyName;
            billDetailsController.BillDate.text = DateFormat('dd/MM/yyyy').format(
                DateFormat('yyyy-MM-dd').parse(element.billDate));
            billDetailsController.billCostController.text = element.billAmount.toString();
            commmonController.selectedGstPercentage.value = element.gstPercentage;
            billDetailsController.gstAmtController.text = element.gst.toString();
            billDetailsController.netAmountController.text = element.netAmount.toString();
          });
        }

        else if(billDetailsController.saveButton.value ==RequestConstant.SUBMIT){
          await commmonController.getDropDownGSTValues();
          billDetailsController.billId=0;
          // await commmonController.AutoYearWiseNo("BILL");
          billDetailsController.BillNoController.text = "";
          commmonController.selectedCompanyId.value = 0;
          commmonController.selectedCompany.value = "--SELECT--";
          billDetailsController.BillDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
          billDetailsController.billCostController.text = "0.0";
          billDetailsController.billCostController.text = "0.0";
          billDetailsController.gstAmtController.text = "0.0";
          billDetailsController.netAmountController.text = "0.0";
        }
      }
      void salesNetPay() => commmonController.calcNetPay(
        salesDetailController.netAmountController,
        salesDetailController.tdsAmtController,
        salesDetailController.tdsnetAmountController,
      );
      salesDetailController.netAmountController.addListener(salesNetPay);
      salesDetailController.tdsAmtController.addListener(salesNetPay);

      // RECEIPT
      void receiptNetPay() => commmonController.calcNetPay(
        receiptDetailsController.netAmountController,
        receiptDetailsController.tdsAmtController,
        receiptDetailsController.tdsnetAmountController,
      );
      receiptDetailsController.netAmountController.addListener(receiptNetPay);
      receiptDetailsController.tdsAmtController.addListener(receiptNetPay);
    });
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final bool isSalesDetails = widget.title == "Sales Details";
    final bool isReceiptDetails = widget.title == "Receipt Details";
    final bool isBillDetails = widget.title == "Bill Details";

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header
              Text(
                '${widget.title} Entry',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Enter the details below',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.subText,
                ),
              ),

              const SizedBox(height: 22),

              // Form Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if (widget.title != "Company Details") ...[
                      _entryField(
                        label: isSalesDetails ? 'Sales No' : isReceiptDetails ? 'Receipt No' : 'Bill No',
                        hint: isBillDetails ? 'Enter bill no' : "",
                        icon: Icons.numbers,
                        controller: isSalesDetails ? salesDetailController.SalesNoController : isReceiptDetails ? receiptDetailsController.ReceiptNoController : billDetailsController.BillNoController,
                        isDateField: false,
                        readOnly: isBillDetails ? false : true,
                        requiredField: true
                      ),
                      const SizedBox(height: 16),
                    ],

                    _entryField(
                      label: 'Company Name',
                      hint: widget.title == "Company Details" ? 'Enter company name' : "--SELECT--",
                      icon: Icons.business_outlined,
                      controller: companyDetailsController.companyNameController,
                      isDropdown: widget.title == "Company Details" ? false : true,
                      requiredField: true,
                    ),
                    const SizedBox(height: 16),

                    _entryField(
                        label: 'Date',
                        hint: '',
                        icon: Icons.calendar_month_outlined,
                        controller: isSalesDetails ? salesDetailController.SalesDate
                            : isReceiptDetails ? receiptDetailsController.ReceiptDate
                            : isBillDetails ? billDetailsController.BillDate : companyDetailsController.CompanyDate,
                        isDateField: true,
                      ),
                      const SizedBox(height: 16),

                    if (isSalesDetails || isReceiptDetails ) ...[
                      _entryField(
                        label: 'Cash portion',
                        hint: 'Enter cash portion',
                        icon: Icons.payments_outlined,
                        controller: isSalesDetails ? salesDetailController.cashPortionController : receiptDetailsController.cashPortionController,
                        keyboardType: TextInputType.number,
                        isNumberField: true,
                        onTap: () {
                          final controller = isSalesDetails
                              ? salesDetailController.cashPortionController
                              : receiptDetailsController.cashPortionController;

                          final value = controller.text.trim();

                          if (value == '0.0' || value == '0.00') {
                            controller.clear();
                          }
                        },
                        onChanged: (_) {
                          if (isSalesDetails) {
                            commmonController.calculateErpCost(
                              salesDetailController.cashPortionController,
                              salesDetailController.accPortionController,
                              salesDetailController.erpCostController,
                            );
                            commmonController.calculateNetAmount();
                          } else if (isReceiptDetails) {
                            commmonController.calculateErpCost(
                              receiptDetailsController.cashPortionController,
                              receiptDetailsController.accPortionController,
                              receiptDetailsController.receiptCostController,
                            );
                            commmonController.calculateReceiptNetAmount();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _entryField(
                        label: 'A/C portion',
                        hint: 'Enter A/C portion',
                        icon: Icons.account_balance_outlined,
                        controller: isSalesDetails ? salesDetailController.accPortionController : receiptDetailsController.accPortionController,
                        keyboardType: TextInputType.number,
                        isNumberField: true,
                        onTap: () {
                          final controller = isSalesDetails
                              ? salesDetailController.accPortionController
                              : receiptDetailsController.accPortionController;

                          final value = controller.text.trim();

                          if (value == '0.0' || value == '0.00') {
                            controller.clear();
                          }
                        },
                        onChanged: (_) {
                          if (isSalesDetails) {
                            //ERP COST
                            commmonController.calculateErpCost(
                              salesDetailController.cashPortionController,
                              salesDetailController.accPortionController,
                              salesDetailController.erpCostController,
                            );
                            // GST
                            commmonController.calculateGst(
                              salesDetailController.accPortionController,
                              salesDetailController.gstAmtController,
                              commmonController.selectedGstPercentage.value,
                            );

                            // TDS - only calculate when unticked
                            // if (!salesDetailController.isTdsEnabled.value) {
                              commmonController.calculateTds(
                                salesDetailController.accPortionController,
                                salesDetailController.tdsAmtController,
                                commmonController.selectedTdsPercentage.value,
                              );
                            // }
                            commmonController.calculateNetAmount();
                          } else {
                            // ERP COST
                            commmonController.calculateErpCost(
                              receiptDetailsController.cashPortionController,
                              receiptDetailsController.accPortionController,
                              receiptDetailsController.receiptCostController,
                            );
                            // GST
                            commmonController.calculateGst(
                              receiptDetailsController.accPortionController,
                              receiptDetailsController.gstAmtController,
                              commmonController.selectedGstPercentage.value,
                            );

                            // TDS - only calculate when unticked
                            // if (!receiptDetailsController.isTdsEnabled.value) {
                              commmonController.calculateTds(
                                receiptDetailsController.accPortionController,
                                receiptDetailsController.tdsAmtController,
                                commmonController.selectedTdsPercentage.value,
                              );
                              commmonController.calculateReceiptNetAmount();
                            // }
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (isSalesDetails || isReceiptDetails || isBillDetails) ...[
                      _entryField(
                        label: isSalesDetails ? 'ERP Cost' : isReceiptDetails ? 'Receipt Amount' : 'Bill Amount',
                        hint: '0.0',
                        icon: Icons.numbers,
                        controller: isSalesDetails ? salesDetailController.erpCostController
                            : isReceiptDetails ? receiptDetailsController.receiptCostController
                            : billDetailsController.billCostController,
                        readOnly: widget.title != "Bill Details" ? true : false,
                        keyboardType: TextInputType.number,
                        isNumberField: true,
                        requiredField: true,
                        onTap: (){
                          if (billDetailsController.billCostController.text.trim() == '0.0' ||
                              billDetailsController.billCostController.text.trim() == '0.00') {
                            billDetailsController.billCostController.clear();
                          }
                        },
                        onChanged: (_) {
                          setState(() {
                            if (isBillDetails) {
                              // GST
                              commmonController.calculateGst(
                                billDetailsController.billCostController,
                                billDetailsController.gstAmtController,
                                commmonController.selectedGstPercentage.value,
                              );
                              commmonController.calculateBillNetAmount();
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (isSalesDetails || isReceiptDetails || isBillDetails) ...[
                      _gstFields(

                        gstAmountController: isSalesDetails
                            ? salesDetailController.gstAmtController
                            : isBillDetails
                            ? billDetailsController.gstAmtController
                            : receiptDetailsController.gstAmtController,
                      ),
                      const SizedBox(height: 16),
                      ],
                    if (isSalesDetails || isBillDetails || isReceiptDetails) ...[
                      _entryField(
                        label: 'Net Amount',
                        hint: '0.00',
                        icon: Icons.calculate_outlined,
                        controller: isSalesDetails ? salesDetailController.netAmountController
                            : isReceiptDetails ? receiptDetailsController.netAmountController
                            : billDetailsController.netAmountController,
                        readOnly: true,
                        requiredField: true,

                      ),
                      const SizedBox(height: 16,),
                      ],
                    if (isSalesDetails || isReceiptDetails) ...[
                      Obx(() =>
                         _tdsFields(
                          tdsAmountController: isSalesDetails
                              ? salesDetailController.tdsAmtController
                              : receiptDetailsController.tdsAmtController,

                          isTdsEnabled: isSalesDetails
                              ? salesDetailController.isTdsEnabled.value
                              : receiptDetailsController.isTdsEnabled.value,
                          onTdsChanged: (value) {
                              final bool enabled = value ?? false;
                              if (isSalesDetails) {
                              salesDetailController.isTdsEnabled.value = enabled;
                              if (enabled) {
                                // Ticked → amount becomes zero
                                salesDetailController.tdsAmtController.text = '0.00';
                              } else {
                                // Unticked → immediately recalculate
                                commmonController.calculateTds(
                                    salesDetailController.accPortionController,
                                    salesDetailController.tdsAmtController,
                                    commmonController.selectedTdsPercentage.value);}
                              }else if (isReceiptDetails) {
                                receiptDetailsController.isTdsEnabled.value = enabled;
                                if (enabled) {
                                  // Ticked → amount becomes zero
                                  receiptDetailsController.tdsAmtController.text = '0.00';
                                } else {
                                  // Unticked → immediately recalculate
                                  commmonController.calculateTds(
                                      receiptDetailsController.accPortionController,
                                      receiptDetailsController.tdsAmtController,
                                      commmonController.selectedTdsPercentage.value);
                                }
                              }
                          },

                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (isSalesDetails || isReceiptDetails) ...[
                      _entryField(
                        label: 'Net Pay Amount',
                        hint: '0.00',
                        icon: Icons.calculate_outlined,
                        controller: isSalesDetails ? salesDetailController.tdsnetAmountController :
                            receiptDetailsController.tdsnetAmountController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16,),
                    ],
                    if (widget.title == "Company Details") ...[
                        _entryField(
                          label: 'Address',
                          hint: 'Enter address',
                          icon: Icons.location_on_outlined,
                          controller: companyDetailsController.AdressController,
                          maxLines: 3,
                          requiredField: true,
                        ),
                        const SizedBox(height: 16),

                        _entryField(
                          label: 'Contact No.',
                          hint: 'Enter contact number',
                          icon: Icons.phone_outlined,
                          controller: companyDetailsController.ContactNoController,
                          requiredField: true,
                          keyboardType: TextInputType.phone,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.contacts_outlined, color: AppColors.drawerIcon),
                            tooltip: 'Pick from contacts',
                            onPressed: () =>
                                _pickContact(companyDetailsController.ContactNoController),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _entryField(
                          label: 'City',
                          hint: '--SELECT--',
                          icon: Icons.location_city_outlined,
                          isDropdown: true,
                          requiredField: true,
                        ),
                        const SizedBox(height: 16),

                        _entryField(
                          label: 'Email',
                          hint: 'Enter email address',
                          icon: Icons.email_outlined,
                          controller: companyDetailsController.emailController,
                          keyboardType: TextInputType.emailAddress,
                          requiredField: true,
                        ),
                        const SizedBox(height: 16),

                        _entryField(
                          label: 'GST No.',
                          hint: 'Enter GST number',
                          icon: Icons.receipt_long_outlined,
                          controller: companyDetailsController.GSTNoController,
                          requiredField: true,
                        ),

                        const SizedBox(height: 16),
                    ]
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: ()
                  {
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      SubmitAlert(context);
                    }
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: Text(
                    widget.title == "Company Details" ? companyDetailsController.saveButton.value :
                    isSalesDetails ? salesDetailController.saveButton.value :
                    isReceiptDetails ? receiptDetailsController.saveButton.value : billDetailsController.saveButton.value,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gstFields({
    required TextEditingController gstAmountController,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _entryField(
            label: 'GST %',
            hint: '0.0%',
            icon: Icons.percent_rounded,
            readOnly: true,
            isDropdown: true,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _entryField(
            label: 'GST Amount',
            hint: '0.00',
            icon: Icons.currency_rupee_rounded,
            controller: gstAmountController,
            readOnly: true,
          ),
        ),
      ],
    );
  }

  Widget _tdsFields({
    required TextEditingController tdsAmountController,
    required bool isTdsEnabled,
    required ValueChanged<bool?> onTdsChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     const Text(
        //       'Exclude TDS',
        //       style: TextStyle(
        //         fontFamily: 'Poppins',
        //         fontSize: 11,
        //         fontWeight: FontWeight.w600,
        //         color: AppColors.text,
        //       ),
        //     ),
        //
        //     // const Spacer(),
        //
        //     Checkbox(
        //       value: isTdsEnabled,
        //       onChanged: onTdsChanged,
        //       activeColor: AppColors.primary,
        //       visualDensity: VisualDensity.compact,
        //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //     ),
        //   ],
        // ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _entryField(
                label: 'TDS %',
                hint: '0.00',
                icon: Icons.percent_rounded,
                readOnly: true,
                isDropdown: true
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _entryField(
                label: 'TDS Amount',
                hint: '0.00',
                icon: Icons.currency_rupee_rounded,
                controller: tdsAmountController,
                readOnly: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
  final FlutterContactPicker _contactPicker = FlutterContactPicker();

  Future<void> _pickContact(TextEditingController controller) async {
    try {
      final contact = await _contactPicker.selectContact(); // type inferred
      if (contact == null) return; // user cancelled

      final numbers = contact.phoneNumbers ?? <String>[];
      if (numbers.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selected contact has no phone number')),
        );
        return;
      }

      // If several numbers, let the user choose
      String raw = numbers.first;
      if (numbers.length > 1) {
        final chosen = await showModalBottomSheet<String>(
          context: context,
          builder: (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: numbers
                  .map((n) => ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: Text(n),
                onTap: () => Navigator.pop(ctx, n),
              ))
                  .toList(),
            ),
          ),
        );
        if (chosen == null) return;
        raw = chosen;
      }

      // Digits only, then last 10 (drops +91 / 0 prefix)
      var number = raw.replaceAll(RegExp(r'[^0-9]'), '');
      // if (number.length > 10) number = number.substring(number.length - 10);

      setState(() => controller.text = number);
    } catch (e, st) {
      debugPrint('CONTACT ERROR: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }


  Widget _entryField({
    required String label,
    required String hint,
    required IconData icon,
    TextEditingController? controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isDropdown = false,
    bool isDateField = false,
    bool readOnly = false,
    bool requiredField = false,
    bool isNumberField = false,
    Widget? suffixIcon,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            if (label == 'ERP Cost' || label == "Receipt Amount") ...[
              const SizedBox(width: 8),
              Icon(
                Icons.info_outline_rounded,
                size: 15,
                color: Colors.green.shade800,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Cash portion + A/C portion',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 7),
          if (isDateField)
            TextField(
              controller: controller,
              readOnly: true,
              onTap: () async {
                FocusScope.of(context).unfocus();

                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.primary,
                          onPrimary: AppColors.white,
                          surface: AppColors.white,
                          onSurface: AppColors.text,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  final String formattedDate =
                      "${pickedDate.day.toString().padLeft(2, '0')}/"
                      "${pickedDate.month.toString().padLeft(2, '0')}/"
                      "${pickedDate.year}";

                  controller?.text = formattedDate;
                }
              },

              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),

              decoration: InputDecoration(
                hintText: hint,

                hintStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.subText,
                ),

                prefixIcon: Icon(
                  icon,
                  color: AppColors.drawerIcon,
                  size: 21,
                ),

                filled: true,
                fillColor: AppColors.background,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: AppColors.border,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: AppColors.border,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: AppColors.accent,
                    width: 1.3,
                  ),
                ),
              ),
            )
          else if (isDropdown)
            Obx(() {
              final bool isSalesDetails =
                  widget.title == "Sales Details";
              final bool isReceiptDetails =
                  widget.title == "Receipt Details";
              final bool isBillDetails =
                  widget.title == "Bill Details";
              final bool isGst = label == 'GST %';
              final bool isTds = label == 'TDS %';

              if (isGst || isTds) {
                final dropdownList = isTds
                    ? commmonController.tdsDropdown
                    : commmonController.gstDropdown;


                print("GST Match: ${dropdownList.any((e) =>
                (e.percentage ?? 0.0) ==
                    (commmonController.selectedGstPercentage.value ?? 0.0))}");
                return DropdownButtonFormField2<double>(
                  value: isTds
                      ? commmonController.selectedTdsPercentage.value
                      : commmonController.selectedGstPercentage.value,
                  isExpanded: true,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 13, color: AppColors.subText,
                    ),
                    prefixIcon: Icon(icon, color: AppColors.drawerIcon, size: 21),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(color: AppColors.accent, width: 1.3),
                    ),
                  ),
                  hint: Text(
                    hint,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.subText),
                  ),
                  items: dropdownList.map((gst) {
                    return DropdownMenuItem<double>(
                      value: gst.percentage ?? 0.0,
                      child: Text(
                        formatPercentage(gst.percentage),
                        style: const TextStyle(
                          fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.text,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      if (isTds) {
                        commmonController.selectedTdsPercentage.value = value;
                        if(isSalesDetails){
                          commmonController.calculateTds(
                            salesDetailController.accPortionController,
                            salesDetailController.tdsAmtController,
                            commmonController.selectedTdsPercentage.value,
                          );
                        }else if(isReceiptDetails){
                          commmonController.calculateTds(
                            receiptDetailsController.accPortionController,
                            receiptDetailsController.tdsAmtController,
                            commmonController.selectedTdsPercentage.value,
                          );
                        }
                      }
                      else {
                        commmonController.selectedGstPercentage.value = value;
                        if(isBillDetails){
                          commmonController.calculateGst(
                            billDetailsController.billCostController,
                            billDetailsController.gstAmtController,
                            commmonController.selectedGstPercentage.value,
                          );
                          commmonController.calculateBillNetAmount();
                        }else if(isReceiptDetails){
                          commmonController.calculateGst(
                            receiptDetailsController.accPortionController,
                            receiptDetailsController.gstAmtController,
                            commmonController.selectedGstPercentage.value,
                          );
                          commmonController.calculateReceiptNetAmount();
                        }else{
                          commmonController.calculateGst(
                            salesDetailController.accPortionController,
                            salesDetailController.gstAmtController,
                            commmonController.selectedGstPercentage.value,
                          );
                          commmonController.calculateNetAmount();
                        }
                      }
                    });
                  },
                  buttonStyleData: const ButtonStyleData(height: 20, padding: EdgeInsets.zero),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.subText),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 220,
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(11)),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 45, padding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                );
              }

              if (isSalesDetails || isReceiptDetails || isBillDetails) {
                return DropdownButtonFormField2<int>(
                  value: commmonController.selectedCompanyId.value == 0
                      ? null
                      : commmonController.selectedCompanyId.value,

                  isExpanded: true,
                  validator: requiredField
                      ? (value) {
                    if (value == null || value == 0) {
                      return '* Required';
                    }
                    return null;
                  }
                      : null,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: AppColors.subText,
                    ),

                    prefixIcon: Icon(
                      icon,
                      color: AppColors.drawerIcon,
                      size: 21,
                    ),

                    // Reduce the gap between prefix icon and dropdown text
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 42,
                      minHeight: 48,
                    ),

                    filled: true,
                    fillColor: AppColors.background,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 14,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(
                        color: AppColors.border,
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(
                        color: AppColors.border,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(
                        color: AppColors.accent,
                        width: 1.3,
                      ),
                    ),
                  ),

                  hint: Text(
                    hint,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: AppColors.subText,
                    ),
                  ),

                  items: [
                    ...commmonController.companyDropdown.map((company) {
                      return DropdownMenuItem<int>(
                        value: company.companyId ?? 0,
                        child: Text(
                          company.companyName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.text,
                          ),
                        ),
                      );
                    }),
                  ],

                  onChanged: (value) {
                    final selected = commmonController.companyDropdown.firstWhere(
                          (company) => company.companyId == value,
                    );

                    setState(() {
                        commmonController.selectedCompanyId.value = value ?? 0;
                        commmonController.selectedCompany.value =
                            selected.companyName ?? '';

                    });
                  },
                  autovalidateMode: AutovalidateMode.always,
                  buttonStyleData: const ButtonStyleData(
                    height: 20,
                    padding: EdgeInsets.zero,
                  ),

                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.subText,
                    ),
                  ),

                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 220,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),

                  menuItemStyleData: const MenuItemStyleData(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                );
              }

              // CITY DROPDOWN
              return DropdownButtonFormField2<String>(
                value: companyDetailsController.selectedCity,

                isExpanded: true,
                validator: requiredField
                    ? (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value == "--SELECT--") {
                    return '* Required';
                  }

                  return null;
                }
                    : null,

                decoration: InputDecoration(
                  hintText: hint,
                  prefixIcon: Icon(
                    icon,
                    color: AppColors.drawerIcon,
                    size: 21,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 1,
                    ),
                  ),

// Normal border when tapping an invalid field
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      color: AppColors.accent,
                      width: 1.3,
                    ),
                  ),
                ),
                autovalidateMode: AutovalidateMode.always,
                hint: Text(
                  hint,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppColors.subText,
                  ),
                ),

                items: [
                  const DropdownMenuItem<String>(
                    value: "--SELECT--",
                    child: Text(
                      "--SELECT--",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppColors.subText,
                      ),
                    ),
                  ),

                  ...companyDetailsController.cityDropDown
                      .map((city) => city.cityName?.trim() ?? '')
                      .where((city) => city.isNotEmpty)
                      .toSet()
                      .map(
                        (city) => DropdownMenuItem<String>(
                      value: city,
                      child: Text(
                        city,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    companyDetailsController.selectedCity =
                        value ?? "--SELECT--";
                  });
                },

                buttonStyleData: const ButtonStyleData(
                  height: 20,
                ),

                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.subText,
                  ),
                ),

                dropdownStyleData: DropdownStyleData(
                  maxHeight: 220,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),

                menuItemStyleData: const MenuItemStyleData(
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 14),
                ),
              );
            })
          // else if (isNumberField && controller != null)
          //     AmountView(
          //       source: controller,
          //       builder: (activeController, focusNode) => TextFormField(
          //         controller: activeController,
          //         focusNode: focusNode,
          //         cursorColor: AppColors.primary,
          //         autovalidateMode: AutovalidateMode.always,
          //         keyboardType: const TextInputType.numberWithOptions(decimal: true),
          //         maxLines: maxLines,
          //         readOnly: readOnly,
          //         onTap: onTap,
          //         onChanged: onChanged,
          //         style: const TextStyle(
          //           fontFamily: 'Poppins',
          //           fontSize: 14,
          //           fontWeight: FontWeight.w500,
          //           color: AppColors.text,
          //         ),
          //         validator: requiredField
          //             ? (value) {
          //           final text = (value ?? '').replaceAll(',', '').trim();
          //           if (text.isEmpty) return '* Required';
          //           final number = double.tryParse(text);
          //           if (number == null || number <= 0) return '* Required';
          //           return null;
          //         }
          //             : null,
          //         decoration: InputDecoration(
          //           hintText: hint,
          //
          //           hintStyle: const TextStyle(
          //             fontFamily: 'Poppins',
          //             fontSize: 13,
          //             color: AppColors.subText,
          //           ),
          //           suffixIcon: suffixIcon,
          //
          //           prefixIcon: Icon(
          //             icon,
          //             color: AppColors.drawerIcon,
          //             size: 21,
          //           ),
          //
          //           filled: true,
          //           fillColor: readOnly
          //               ? AppColors.background.withOpacity(0.7)
          //               : AppColors.background,
          //
          //           contentPadding: const EdgeInsets.symmetric(
          //             horizontal: 14,
          //             vertical: 14,
          //           ),
          //
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(11),
          //             borderSide: const BorderSide(
          //               color: AppColors.border,
          //             ),
          //           ),
          //
          //           enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(11),
          //             borderSide: const BorderSide(
          //               color: AppColors.border,
          //             ),
          //           ),
          //           errorBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(11),
          //             borderSide: const BorderSide(
          //               color: AppColors.border,
          //               width: 1,
          //             ),
          //           ),
          //
          //           focusedErrorBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(11),
          //             borderSide: const BorderSide(
          //               color: AppColors.border,
          //               width: 1,
          //             ),
          //           ),
          //           focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(11),
          //             borderSide: const BorderSide(
          //               color: AppColors.accent,
          //               width: 1.3,
          //             ),
          //           ),
          //         ),
          //       ),
          //     )
          else
            TextFormField(
              cursorColor: AppColors.primary,
              controller: controller,
              autovalidateMode: AutovalidateMode.always,
              keyboardType: keyboardType,
              maxLines: maxLines,
              readOnly: readOnly,
              onTap: onTap,
              onChanged: onChanged,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
              validator: requiredField
                  ? (value) {
                final text = value?.trim() ?? '';

                // Required validation
                if (text.isEmpty || text == "--SELECT--") {
                  return '* Required';
                }

                if (isNumberField) {
                  final number = double.tryParse(text);

                  if (number == null) {
                    return '* Required';
                  }

                  if (number <= 0) {
                    return '* Required';
                  }
                }
                return null;
              }
                  : null,

              decoration: InputDecoration(
                hintText: hint,

                hintStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.subText,
                ),
                suffixIcon: suffixIcon,

                prefixIcon: Icon(
                  icon,
                  color: AppColors.drawerIcon,
                  size: 21,
                ),

                filled: true,
                fillColor: readOnly
                    ? AppColors.background.withOpacity(0.7)
                    : AppColors.background,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: AppColors.border,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: AppColors.border,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),

                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: AppColors.accent,
                    width: 1.3,
                  ),
                ),
              ),
            ),
      ],
    );
  }

  String formatPercentage(double? p) {
    if (p == null) return '0%';
    return p == p.truncateToDouble()
        ? '${p.toInt()}%'
        : '$p%';
  }

  Future SubmitAlert(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),),
        title: const Text('Alert!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
        content: Text((companyDetailsController.saveButton.value ==RequestConstant.RESUBMIT  ||
            salesDetailController.saveButton.value == RequestConstant.RESUBMIT ||
            receiptDetailsController.saveButton.value == RequestConstant.RESUBMIT ||
            billDetailsController.saveButton.value == RequestConstant.RESUBMIT)? 'Are you sure to Re-Submit?' :
        'Are you sure to Submit?'),
        actions:[
          Container(
            margin: const EdgeInsets.only(left: 20,right: 20),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: RequestConstant.Lable_Font_SIZE))),
                  ),
                  VerticalDivider(
                    color: Colors.grey.shade400,
                    width: 5,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),

                  Expanded(
                    child: StatefulBuilder(
                      builder: (context, setState) => TextButton(
                        onPressed:  () async {
                            if (await BaseUtitiles.checkNetworkAndShowLoader(context)) {
                              if(widget.title == "Company Details"){
                              await companyDetailsController.SaveButton_CompanyDetails(
                                context, companyDetailsController.companyId != 0 ? companyDetailsController.companyId : 0,
                              );
                              }
                              else if(widget.title == "Sales Details") {
                                  await commmonController.SaveButton_SalesDetails(
                                      context, salesDetailController.salesId != 0 ? salesDetailController.salesId : 0,);
                                }
                              else if(widget.title == "Receipt Details"){
                                await commmonController.SaveButton_ReceiptDetails(
                                context, receiptDetailsController.receiptId != 0 ? receiptDetailsController.receiptId : 0,);
                              }
                              else{
                                await commmonController.SaveButton_BillDetails(
                                  context, billDetailsController.billId != 0 ? billDetailsController.billId : 0,);
                              }
                            }
                        },
                        child: Text(
                          widget.title == "Company Details" ? companyDetailsController.saveButton.value :
                          widget.title == "Sales Details" ? salesDetailController.saveButton.value :
                          widget.title == "Receipt Details" ? receiptDetailsController.saveButton.value : billDetailsController.saveButton.value,
                          style: TextStyle(
                            color: AppColors.primary, // Change color when button is disabled
                            fontWeight: FontWeight.bold,
                            fontSize: RequestConstant.Lable_Font_SIZE,
                          ),
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

String commaView(String raw) {
  var t = raw.trim().replaceAll(',', '');
  if (t.isEmpty) return raw;
  final neg = t.startsWith('-');
  if (neg) t = t.substring(1);

  final dot = t.indexOf('.');
  final intPart = dot == -1 ? t : t.substring(0, dot);
  final decPart = dot == -1 ? '' : t.substring(dot);
  if (!RegExp(r'^\d+$').hasMatch(intPart)) return raw;

  String grouped;
  if (intPart.length <= 3) {
    grouped = intPart;
  } else {
    final last3 = intPart.substring(intPart.length - 3);
    var rest = intPart.substring(0, intPart.length - 3);
    final parts = <String>[];
    while (rest.length > 2) {
      parts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.insert(0, rest);
    grouped = '${parts.join(',')},$last3';
  }
  // For international grouping (1,234,567) use instead:
  // grouped = intPart.replaceAllMapped(
  //     RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  return '${neg ? '-' : ''}$grouped$decPart';
}

/// Shows commas when the field is not focused, raw text while typing.
/// The [source] controller text is NEVER modified.
class AmountView extends StatefulWidget {
  final TextEditingController source;
  final Widget Function(TextEditingController active, FocusNode focusNode) builder;

  const AmountView({Key? key, required this.source, required this.builder})
      : super(key: key);

  @override
  State<AmountView> createState() => _AmountViewState();
}

class _AmountViewState extends State<AmountView> {
  final FocusNode _focus = FocusNode();
  final TextEditingController _display = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncDisplay();
    widget.source.addListener(_syncDisplay);
    _focus.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _syncDisplay() {
    final formatted = commaView(widget.source.text);
    if (_display.text != formatted) _display.text = formatted;
  }

  @override
  void didUpdateWidget(covariant AmountView old) {
    super.didUpdateWidget(old);
    if (old.source != widget.source) {
      old.source.removeListener(_syncDisplay);
      widget.source.addListener(_syncDisplay);
      _syncDisplay();
    }
  }

  @override
  void dispose() {
    widget.source.removeListener(_syncDisplay);
    _focus.dispose();
    _display.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_focus.hasFocus ? widget.source : _display, _focus);
  }
}


