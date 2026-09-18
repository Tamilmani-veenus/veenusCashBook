import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:veenuscashbook/app_theme.dart';
import 'package:veenuscashbook/controller/billDetails_controller.dart';
import 'package:veenuscashbook/controller/common_controller.dart';
import 'package:veenuscashbook/controller/receiptDetails_controller.dart';
import 'package:veenuscashbook/controller/salesDetails_controller.dart';
import '../../app_theme/app_colors.dart';
import '../../utilities/baseutitiles.dart';
import '../../utilities/requestconstant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/salesReport_model.dart';


class SalesReport extends StatefulWidget {
  final String title;
  SalesReport({Key? key,required this.title,}) : super(key: key);

  @override
  State<SalesReport> createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  final CommonController commonController = Get.put(CommonController());
  final SalesDetailController salesDetailController = Get.put(SalesDetailController());
  final ReceiptDetailsController receiptDetailsController = Get.put(ReceiptDetailsController());
  final BillDetailsController billDetailsController = Get.put(BillDetailsController());

  int expandedIndex = -1;
  @override
  void initState() {
    var duration = Duration(seconds: 0);
    Future.delayed(duration, () async {
      DateTime currentDate = DateTime.now();
      DateTime oneWeekBefore = currentDate.subtract(const Duration(days: 7));
      commonController.salesRptFromDate.text = oneWeekBefore.toString().substring(0, 10);
      commonController.salesRptToDate.text = currentDate.toString().substring(0, 10);
      await commonController.getSalesReport();
      commonController.getDropDownCompanyValues();
    });
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool isSalesDetails =
        widget.title == "Sales Report";
    final bool isReceiptDetails =
        widget.title == "Receipt Details";
    final bool isBillDetails =
        widget.title == "Bill Details";
    return SafeArea(
      top: false,
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Setmybackground,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sales Report",
                        style: TextStyle(
                            fontSize: RequestConstant.Heading_Font_SIZE,
                            fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Back",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // FROM DATE
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now().subtract(const Duration(days: 7)),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  ) ?? DateTime.now();

                                  commonController.salesRptFromDate.text =
                                      DateFormat('dd/MM/yyyy').format(picked);

                                  // If To Date is empty or before From Date, update it too
                                  DateTime? toDate;
                                  try {
                                    toDate = DateFormat('dd/MM/yyyy')
                                        .parse(commonController.salesRptToDate.text);
                                  } catch (_) {}

                                  if (toDate == null || toDate.isBefore(picked)) {
                                    commonController.salesRptToDate.text =
                                        DateFormat('dd/MM/yyyy').format(picked);
                                  }

                                  setState(() {});
                                },
                                child: _dateBox(
                                  title: "From Date",
                                  value: commonController.salesRptFromDate.text,
                                  icon: Icons.calendar_month_rounded,
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.arrow_forward_rounded,
                                  size: 17, color: AppColors.primary),
                            ),

                            const SizedBox(width: 10),

                            // TO DATE
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  DateTime fromDate;
                                  try {
                                    fromDate = DateFormat('dd/MM/yyyy')
                                        .parse(commonController.salesRptFromDate.text);
                                  } catch (_) {
                                    fromDate = DateTime.now().subtract(const Duration(days: 7));
                                  }

                                  final DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: fromDate,
                                    firstDate: fromDate,
                                    lastDate: DateTime(2100),
                                  ) ?? fromDate;

                                  commonController.salesRptToDate.text =
                                      DateFormat('dd/MM/yyyy').format(picked);

                                  setState(() {});
                                },
                                child: _dateBox(
                                  title: "To Date",
                                  value: commonController.salesRptToDate.text,
                                  icon: Icons.event_rounded,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Obx(
                          () => DropdownButtonFormField2<int>(
                        value: isSalesDetails
                            ? (salesDetailController.selectedCompanyId == 0
                            ? null
                            : salesDetailController.selectedCompanyId)
                            : isReceiptDetails
                            ? (receiptDetailsController.selectedCompanyId == 0
                            ? null
                            : receiptDetailsController.selectedCompanyId)
                            : (billDetailsController.selectedCompanyId == 0
                            ? null
                            : billDetailsController.selectedCompanyId),

                        isExpanded: true,

                        // Remove default TextFormField border
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),

                        // Custom hint
                        hint: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: BaseUtitiles.primaryColor.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.business_rounded,
                                size: 19,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "COMPANY",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.7,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "--SELECT--",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        items: commonController.companyDropdown.map((company) {
                          return DropdownMenuItem<int>(
                            value: company.companyId ?? 0,
                            child: Text(
                              company.companyName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                            selectedItemBuilder: (context) {
                              return commonController.companyDropdown.map((company) {
                                return Row(
                                  children: [
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.10),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.business_rounded,
                                        size: 19,
                                        color: AppColors.primary,
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "COMPANY",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.7,
                                              color: Colors.grey,
                                            ),
                                          ),

                                          const SizedBox(height: 3),

                                          Text(
                                            company.companyName ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            },

                        onChanged: (value) {
                          if (value == null) return;

                          final selected = commonController.companyDropdown.firstWhere(
                                (company) => company.companyId == value,
                          );

                          setState(() {
                            if (isSalesDetails) {
                              salesDetailController.selectedCompanyId = value;
                              salesDetailController.selectedCompany =
                                  selected.companyName ?? '';
                            } else if (isBillDetails) {
                              billDetailsController.selectedCompanyId = value;
                              billDetailsController.selectedCompany =
                                  selected.companyName ?? '';
                            } else {
                              receiptDetailsController.selectedCompanyId = value;
                              receiptDetailsController.selectedCompany =
                                  selected.companyName ?? '';
                            }
                          });
                        },

                        validator: (value) {
                          if (value == null) {
                            return '\u26A0 ${RequestConstant.VALIDATE}';
                          }
                          return null;
                        },

                        buttonStyleData: const ButtonStyleData(
                          height: 38,
                          padding: EdgeInsets.zero,
                        ),

                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),

                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 220,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 5,
                        ),

                        menuItemStyleData: const MenuItemStyleData(
                          height: 45,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20,top:10),
                        width: BaseUtitiles.getWidthtofPercentage(context, 25),
                        height: BaseUtitiles.getheightofPercentage(context, 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: AppColors.primary),
                        alignment: Alignment.center,
                        child: Text("Show",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: RequestConstant.Lable_Font_SIZE,
                              color: Colors.white),
                        ),
                      ),
                      onTap: () async {
                        setState(() {
                          commonController.getSalesReport();
                        });
                      },
                    ),
                  ],
                ),



                Divider(color: AppColors.primary),

                ListDetails()

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateBox({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final bool hasValue = value.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FC),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: hasValue
              ? AppColors.primary.withOpacity(0.25)
              : Colors.grey.withOpacity(0.18),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: hasValue
                ? AppColors.primary
                : Colors.grey,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  hasValue ? value : "Select date",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: hasValue
                        ? Colors.black87
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ListDetails() {
    return Obx(() {
      if (commonController.salesReportList.isEmpty) {
        return const Center(
          child: Text(
            "No Sales Report Found",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        itemCount: commonController.salesReportList.length,
        itemBuilder: (context, index) {
          final SalesResult result =
          commonController.salesReportList[index];

          final details = result.salesDetails ?? [];

          return Column(
            children: details.map((detail) {
              return _salesReportCard(
                result: result,
                detail: detail,
              );
            }).toList(),
          );
        },
      );
    });
  }

  Widget _salesReportCard({
    required SalesResult result,
    required SalesDetail detail,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE1E1E1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ------------------------------------------------
          // DATE + SALES NO + COMPANY
          // ------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              8,
              14,
              8,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        detail.date != null
                            ?
                        detail.date!
                            : result.companyDate != null
                            ? result.companyDate!
                            : "--",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    Text(
                      detail.salesNo ?? "--",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1763A8),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    result.companyName ?? "--",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE0E0E0),
          ),

          // ------------------------------------------------
          // ERP COST + CASH + ACCOUNT
          // ------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _reportAmountItem(
                    title: "ERP Cost",
                    value: detail.erpCost,
                  ),
                ),

                _reportDivider(),

                Expanded(
                  child: _reportAmountItem(
                    title: "Cash",
                    value: detail.cashPortion,
                  ),
                ),

                _reportDivider(),

                Expanded(
                  child: _reportAmountItem(
                    title: "Account",
                    value: detail.accountPortion,
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE0E0E0),
          ),

          // ------------------------------------------------
          // GST + TDS + NET AMOUNT
          // ------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _reportAmountItem(
                    title: "GST",
                    value: detail.gst,
                  ),
                ),

                _reportDivider(),

                Expanded(
                  child: _reportAmountItem(
                    title: "TDS",
                    value: detail.tds,
                  ),
                ),

                // _reportDivider(),
                //
                // Expanded(
                //   child: _reportAmountItem(
                //     title: "Net Amount",
                //     value: detail.netAmount,
                //     isNetAmount: true,
                //   ),
                // ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE0E0E0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Net Amount",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3F6F55),
                  ),
                ),

                Text(
                  "₹ ${detail.netAmount ?? 0}",
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF278447),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reportAmountItem({
    required String title,
    required num? value,
    bool isNetAmount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: isNetAmount
                  ? const Color(0xFF267A42)
                  : const Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 2),

          Text(
            _formatAmount(1220098475),
            style: TextStyle(
              fontSize: isNetAmount ? 19 : 16,
              fontWeight:
              isNetAmount ? FontWeight.w700 : FontWeight.w500,
              color: isNetAmount
                  ? const Color(0xFF155A2F)
                  : const Color(0xFF202020),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reportDivider() {
    return Container(
      width: 1,
      height: 42,
      color: const Color(0xFFD6D6D6),
    );
  }

  String _formatAmount(num? value) {
    return NumberFormat.currency(
      locale: "en_IN",
      symbol: "₹",
      decimalDigits: 0,
    ).format(value ?? 0);
  }
}
