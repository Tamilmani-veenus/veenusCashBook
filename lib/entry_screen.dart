import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
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
            companyDetailsController.companyNameController.text = element.companyName!;
            companyDetailsController.AdressController.text = element.companyAddress!;
            companyDetailsController.ContactNoController.text = element.contactNo!;
            companyDetailsController.selectedCity = element.city!;
            companyDetailsController.emailController.text = element.email!;
            companyDetailsController.GSTNoController.text = element.gstNo!;
          });
        }

        else if(companyDetailsController.saveButton.value ==RequestConstant.SUBMIT){
          companyDetailsController.companyNameController.text = "";
          companyDetailsController.AdressController.text = "";
          companyDetailsController.ContactNoController.text = "";
          companyDetailsController.selectedCity = "--SELECT--";
          companyDetailsController.emailController.text = "";
          companyDetailsController.GSTNoController.text = "";
        }
      }

      else if (widget.title == "Sales Details") {
        if(salesDetailController.saveButton.value == RequestConstant.RESUBMIT) {
          salesDetailController.Sales_EditListApiValue.forEach((element) {
            salesDetailController.salesId=element.id!;
            salesDetailController.SalesNoController.text = element.salesNo;
            salesDetailController.selectedCompanyId = element.companyId;
            salesDetailController.selectedCompany = element.companyName;
            salesDetailController.SalesDate.text = DateFormat('dd/MM/yyyy').format(
                DateFormat('yyyy-MM-dd').parse(element.date));
            salesDetailController.erpCostController.text = element.erpCost.toString();
            salesDetailController.cashPortionController.text = element.cashPortion.toString();
            salesDetailController.accPortionController.text = element.accountPortion.toString();
            salesDetailController.gstController.text = element.gst.toString();
            salesDetailController.tdsController.text = element.tds.toString();
            salesDetailController.netAmountController.text = element.netAmount.toString();
          });
        }

        else if(salesDetailController.saveButton.value ==RequestConstant.SUBMIT){
          salesDetailController.salesId=0;
          await commmonController.AutoYearWiseNo("SALES");
          salesDetailController.SalesNoController.text = commmonController.Sales_autoYrsWise.value;
          salesDetailController.selectedCompanyId = 0;
          salesDetailController.selectedCompany = "--SELECT--";
          salesDetailController.SalesDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
          salesDetailController.erpCostController.text = "0.0";
          salesDetailController.cashPortionController.text = "0.0";
          salesDetailController.accPortionController.text = "0.0";
          salesDetailController.gstController.text = "0.0";
          salesDetailController.tdsController.text = "0.0";
          salesDetailController.netAmountController.text = "0.0";
        }
      }

      else if (widget.title == "Receipt Details") {
        if(receiptDetailsController.saveButton.value == RequestConstant.RESUBMIT) {
          receiptDetailsController.Receipt_EditListApiValue.forEach((element) {
            receiptDetailsController.receiptId=element.id!;
            receiptDetailsController.ReceiptNoController.text = element.receiptNo;
            receiptDetailsController.selectedCompanyId = element.companyId;
            receiptDetailsController.selectedCompany = element.companyName;
            receiptDetailsController.ReceiptDate.text = DateFormat('dd/MM/yyyy').format(
                DateFormat('yyyy-MM-dd').parse(element.date));
            receiptDetailsController.receiptCostController.text = element.receivedAmount.toString();
            receiptDetailsController.cashPortionController.text = element.cashPortion.toString();
            receiptDetailsController.accPortionController.text = element.bankPortion.toString();
            receiptDetailsController.tdsController.text = element.tds.toString();
          });
        }

        else if(receiptDetailsController.saveButton.value ==RequestConstant.SUBMIT){
          receiptDetailsController.receiptId=0;
          await commmonController.AutoYearWiseNo("RECEIPT");
          receiptDetailsController.ReceiptNoController.text = commmonController.Receipt_autoYrsWise.value;
          receiptDetailsController.selectedCompanyId = 0;
          receiptDetailsController.selectedCompany = "--SELECT--";
          receiptDetailsController.ReceiptDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
          receiptDetailsController.receiptCostController.text = "0.0";
          receiptDetailsController.cashPortionController.text = "0.0";
          receiptDetailsController.gstController.text = "0.0";
          receiptDetailsController.accPortionController.text = "0.0";
          receiptDetailsController.tdsController.text = "0.0";
        }
      }

      else if (widget.title == "Bill Details") {
        if(billDetailsController.saveButton.value == RequestConstant.RESUBMIT) {
          billDetailsController.Bill_EditListApiValue.forEach((element) {
            billDetailsController.billId=element.id!;
            billDetailsController.BillNoController.text = element.billNo;
            billDetailsController.selectedCompanyId = element.companyId;
            billDetailsController.selectedCompany = element.companyName;
            billDetailsController.BillDate.text = DateFormat('dd/MM/yyyy').format(
                DateFormat('yyyy-MM-dd').parse(element.billDate));
            billDetailsController.billCostController.text = element.billAmount.toString();
            billDetailsController.gstController.text = element.gst.toString();
            billDetailsController.netAmountController.text = element.netAmount.toString();
          });
        }

        else if(billDetailsController.saveButton.value ==RequestConstant.SUBMIT){
          billDetailsController.billId=0;
          await commmonController.AutoYearWiseNo("BILL");
          billDetailsController.BillNoController.text = commmonController.Bill_autoYrsWise.value;
          billDetailsController.selectedCompanyId = 0;
          billDetailsController.selectedCompany = "--SELECT--";
          billDetailsController.BillDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
          billDetailsController.billCostController.text = "0.0";
          billDetailsController.billCostController.text = "0.0";
          billDetailsController.gstController.text = "0.0";
          billDetailsController.netAmountController.text = "0.0";
        }
      }

      salesDetailController.cashPortionController.addListener(() {
        commmonController.calculateErpCost(
          salesDetailController.cashPortionController,
          salesDetailController.accPortionController,
          salesDetailController.erpCostController,
        );
      });

      salesDetailController.accPortionController.addListener(() {
        commmonController.calculateErpCost(
          salesDetailController.cashPortionController,
          salesDetailController.accPortionController,
          salesDetailController.erpCostController,
        );
      });

      receiptDetailsController.cashPortionController.addListener(() {
        commmonController.calculateErpCost(
          receiptDetailsController.cashPortionController,
          receiptDetailsController.accPortionController,
          receiptDetailsController.receiptCostController,
        );
      });

      receiptDetailsController.accPortionController.addListener(() {
        commmonController.calculateErpCost(
          receiptDetailsController.cashPortionController,
          receiptDetailsController.accPortionController,
          receiptDetailsController.receiptCostController,
        );
      });

      salesDetailController.accPortionController.addListener(() {
        commmonController.calculateGst(
        salesDetailController.accPortionController,
        salesDetailController.gstController
        );
      });

      billDetailsController.billCostController.addListener(() {
        commmonController.calculateGst(
            billDetailsController.billCostController,
            billDetailsController.gstController
        );
      });

      // TDS CALCULATION

      salesDetailController.accPortionController.addListener(() {
        commmonController.calculateTds(
          salesDetailController.accPortionController,
          salesDetailController.tdsController,
        );
      });

      receiptDetailsController.accPortionController.addListener(() {
        commmonController.calculateTds(
          receiptDetailsController.accPortionController,
          receiptDetailsController.tdsController,
        );
      });

      salesDetailController.cashPortionController
          .addListener(commmonController.calculateNetAmount);

      salesDetailController.accPortionController
          .addListener(commmonController.calculateNetAmount);

      salesDetailController.gstController
          .addListener(commmonController.calculateNetAmount);

      billDetailsController.billCostController
          .addListener(commmonController.calculateBillNetAmount);

      billDetailsController.gstController
          .addListener(commmonController.calculateBillNetAmount);

      // Calculate initial value
      commmonController.calculateErpCost(
        salesDetailController.cashPortionController,
        salesDetailController.accPortionController,
        salesDetailController.erpCostController,
      );
      commmonController.calculateErpCost(
        receiptDetailsController.cashPortionController,
        receiptDetailsController.accPortionController,
        receiptDetailsController.receiptCostController,
      );
      commmonController.calculateGst(
        salesDetailController.accPortionController,
        salesDetailController.gstController
      );
      commmonController.calculateGst(
          billDetailsController.billCostController,
          billDetailsController.gstController
      );
      commmonController.calculateTds(
        salesDetailController.accPortionController,
        salesDetailController.tdsController,
      );

      // Initial calculation - Receipt
      commmonController.calculateTds(
        receiptDetailsController.accPortionController,
        receiptDetailsController.tdsController,
      );
      commmonController.calculateNetAmount();
      commmonController.calculateBillNetAmount();
    });


  }

  @override
  void dispose() {
    salesDetailController.cashPortionController
        .removeListener(commmonController.salesERPListener);

    salesDetailController.accPortionController
        .removeListener(commmonController.salesERPListener);

    receiptDetailsController.cashPortionController
        .removeListener(commmonController.receiptERPListener);

    receiptDetailsController.accPortionController
        .removeListener(commmonController.receiptERPListener);

    salesDetailController.accPortionController
        .removeListener(commmonController.salesGSTListener);

    billDetailsController.billCostController
        .removeListener(commmonController.billGSTListener);

    salesDetailController.accPortionController
        .removeListener(commmonController.salesTdsListener);

    receiptDetailsController.accPortionController
        .removeListener(commmonController.receiptTdsListener);

    salesDetailController.cashPortionController
        .removeListener(commmonController.calculateNetAmount);

    salesDetailController.accPortionController
        .removeListener(commmonController.calculateNetAmount);

    salesDetailController.gstController
        .removeListener(commmonController.calculateNetAmount);
    billDetailsController.billCostController
        .removeListener(commmonController.calculateBillNetAmount);
    billDetailsController.gstController
        .removeListener(commmonController.calculateBillNetAmount);
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
                        hint: '',
                        icon: Icons.numbers,
                        controller: isSalesDetails ? salesDetailController.SalesNoController : isReceiptDetails ? receiptDetailsController.ReceiptNoController : billDetailsController.BillNoController,
                        isDateField: true,
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

                    if (isSalesDetails || isReceiptDetails || isBillDetails) ...[
                      _entryField(
                        label: 'Date',
                        hint: '',
                        icon: Icons.calendar_month_outlined,
                        controller: isSalesDetails ? salesDetailController.SalesDate :
                        isReceiptDetails ? receiptDetailsController.ReceiptDate : billDetailsController.BillDate,
                        isDateField: true,
                      ),
                      const SizedBox(height: 16),

                      _entryField(
                        label: isSalesDetails ? 'ERP Cost' : isReceiptDetails ? 'Receipt Amount' : 'Bill Amount',
                        hint: '0.0',
                        icon: Icons.numbers,
                        controller: isSalesDetails ? salesDetailController.erpCostController :
                        isReceiptDetails ? receiptDetailsController.receiptCostController : billDetailsController.billCostController,
                        readOnly: widget.title != "Bill Details" ? true : false,
                        onTap: (){
                          if (billDetailsController.billCostController.text.trim() == '0.0' ||
                              billDetailsController.billCostController.text.trim() == '0.00') {
                            billDetailsController.billCostController.clear();
                          }
                        }
                      ),
                      const SizedBox(height: 16),
                      ],
                    if (isSalesDetails || isReceiptDetails ) ...[
                      _entryField(
                        label: 'Cash portion',
                        hint: 'Enter cash portion',
                        icon: Icons.payments_outlined,
                        controller: isSalesDetails ? salesDetailController.cashPortionController : receiptDetailsController.cashPortionController,
                        keyboardType: TextInputType.number,
                        onTap: () {
                          if (salesDetailController.cashPortionController.text.trim() == '0.0' ||
                              salesDetailController.cashPortionController.text.trim() == '0.00') {
                            salesDetailController.cashPortionController.clear();
                          }
                          else if (receiptDetailsController.cashPortionController.text.trim() == '0.0' ||
                              receiptDetailsController.cashPortionController.text.trim() == '0.00') {
                            receiptDetailsController.cashPortionController.clear();
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
                        onTap: () {
                          if (salesDetailController.accPortionController.text.trim() == '0.0' ||
                              salesDetailController.accPortionController.text.trim() == '0.00') {
                            salesDetailController.accPortionController.clear();
                          }
                          else if (receiptDetailsController.accPortionController.text.trim() == '0.0' ||
                              receiptDetailsController.accPortionController.text.trim() == '0.00') {
                            receiptDetailsController.accPortionController.clear();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (isSalesDetails || isReceiptDetails || isBillDetails) ...[
                      _entryField(
                        label: 'GST %',
                        hint: '0.0%',
                        icon: Icons.percent,
                        controller: isSalesDetails ? salesDetailController.gstController : isBillDetails ? billDetailsController.gstController : receiptDetailsController.gstController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      ],
                    if (isSalesDetails || isBillDetails) ...[
                      _entryField(
                        label: 'Net Amount',
                        hint: '0.00',
                        icon: Icons.calculate_outlined,
                        controller: isSalesDetails ? salesDetailController.netAmountController : billDetailsController.netAmountController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16,),
                      ],
                    if (isSalesDetails || isReceiptDetails) ...[
                      _entryField(
                        label: 'TDS %',
                        hint: '0.0',
                        icon: Icons.percent,
                        controller: isSalesDetails ? salesDetailController.tdsController : receiptDetailsController.tdsController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
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
                          keyboardType: TextInputType.number,
                          controller: companyDetailsController.ContactNoController,
                          requiredField: true,
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
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

              if (isSalesDetails || isReceiptDetails || isBillDetails) {
                return DropdownButtonFormField2<int>(
                  value: isSalesDetails ? salesDetailController.selectedCompanyId == 0
                      ? null
                      : salesDetailController.selectedCompanyId :
                  isReceiptDetails ? receiptDetailsController.selectedCompanyId == 0
                      ? null
                      : receiptDetailsController.selectedCompanyId
                      : billDetailsController.selectedCompanyId == 0
                      ? null
                      : billDetailsController.selectedCompanyId,

                  isExpanded: true,

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
                    final selected = commmonController.companyDropdown
                        .firstWhere(
                          (company) => company.companyId == value,
                    );

                    setState(() {
                      if(isSalesDetails){
                        salesDetailController.selectedCompanyId =
                            value ?? 0;

                        salesDetailController.selectedCompany =
                            selected.companyName ?? '';
                      }else if(isBillDetails){
                        billDetailsController.selectedCompanyId =
                            value ?? 0;

                        billDetailsController.selectedCompany =
                            selected.companyName ?? '';
                      } else {
                          receiptDetailsController.selectedCompanyId = value ?? 0;
                          receiptDetailsController.selectedCompany = selected.companyName ?? '';
                        }

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
              }

              // CITY DROPDOWN
              return DropdownButtonFormField2<String>(
                value: companyDetailsController.selectedCity,

                isExpanded: true,

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

                  ...companyDetailsController.cityDropDown.map((city) {
                    return DropdownMenuItem<String>(
                      value: city.cityName ?? '',
                      child: Text(
                        city.cityName ?? '',
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
          else
            TextFormField(
              cursorColor: AppColors.primary,
              controller: controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: keyboardType,
              maxLines: maxLines,
              readOnly: readOnly,
              onTap: onTap,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
              validator: requiredField
                  ? (value) {
                final text = value?.trim() ?? '';

                // Empty validation
                if (text.isEmpty || text == "--SELECT--") {
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

  Future SubmitAlert(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),),
        title: const Text('Alert!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
        content: Text(companyDetailsController.saveButton==RequestConstant.RESUBMIT  ||
            salesDetailController.saveButton.value == RequestConstant.RESUBMIT ||
            receiptDetailsController.saveButton.value == RequestConstant.RESUBMIT ||
            billDetailsController.saveButton.value == RequestConstant.RESUBMIT ? 'Are you sure to Re-Submit?' :
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
                                  await salesDetailController.SaveButton_SalesDetails(
                                      context, salesDetailController.salesId != 0 ? salesDetailController.salesId : 0,);
                                }
                              else if(widget.title == "Receipt Details"){
                                await receiptDetailsController.SaveButton_ReceiptDetails(
                                context, receiptDetailsController.receiptId != 0 ? receiptDetailsController.receiptId : 0,);
                              }
                              else{
                                await billDetailsController.SaveButton_BillDetails(
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