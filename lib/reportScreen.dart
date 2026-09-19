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
import 'models/billReport_model.dart';
import 'models/receiptReport_model.dart';
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
      final DateTime today = DateTime.now();
      final DateTime oneWeekBefore =
      today.subtract(const Duration(days: 7));

      commonController.RptFromDate.text =
          DateFormat('dd/MM/yyyy').format(oneWeekBefore);

      commonController.RptToDate.text =
          DateFormat('dd/MM/yyyy').format(today);
      setState(() {

      });
      commonController.selectedCompanyId = 0;
      commonController.selectedCompany = "--SELECT--";
      if(widget.title == "Sales Report"){

        commonController.salesReportList.value = [];
      }
      else if(widget.title == "Receipt Report"){
        commonController.receiptReportList.value = [];
      }
      else if(widget.title == "Bill Report"){
        commonController.billReportList.value = [];
      }

      commonController.getDropDownCompanyValues();
    });
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool isSalesReport =
        widget.title == "Sales Report";
    final bool isReceiptReport =
        widget.title == "Receipt Report";
    final bool isBillReport =
        widget.title == "Bill Report";
    return SafeArea(
      top: false,
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Setmybackground,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
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
                                DateTime fromDate;

                                try {
                                  fromDate = DateFormat('dd/MM/yyyy')
                                      .parse(commonController.RptFromDate.text);
                                } catch (_) {
                                  fromDate = DateTime.now()
                                      .subtract(const Duration(days: 7));
                                }

                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: fromDate,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );

                                if (picked == null) return;

                                commonController.RptFromDate.text =
                                    DateFormat('dd/MM/yyyy').format(picked);

                                // If To Date is before From Date, update To Date
                                DateTime? toDate;

                                try {
                                  toDate = DateFormat('dd/MM/yyyy')
                                      .parse(commonController.RptToDate.text);
                                } catch (_) {}

                                if (toDate == null || toDate.isBefore(picked)) {
                                  commonController.RptToDate.text =
                                      DateFormat('dd/MM/yyyy').format(picked);
                                }

                                setState(() {});
                              },
                              child: _dateBox(
                                title: "From Date",
                                value: commonController.RptFromDate.text,
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
                                      .parse(commonController.RptFromDate.text);
                                } catch (_) {
                                  fromDate = DateTime.now()
                                      .subtract(const Duration(days: 7));
                                }

                                DateTime toDate;

                                try {
                                  toDate = DateFormat('dd/MM/yyyy')
                                      .parse(commonController.RptToDate.text);
                                } catch (_) {
                                  toDate = DateTime.now();
                                }

                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: toDate,
                                  firstDate: fromDate,
                                  lastDate: DateTime(2100),
                                );

                                if (picked == null) return;

                                commonController.RptToDate.text =
                                    DateFormat('dd/MM/yyyy').format(picked);

                                setState(() {});
                              },
                              child: _dateBox(
                                title: "To Date",
                                value: commonController.RptToDate.text,
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
                      value:
                          commonController.selectedCompanyId == 0
                          ? null
                          : commonController.selectedCompanyId,

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
                            commonController.selectedCompanyId = value;
                            commonController.selectedCompany =
                                selected.companyName ?? '';
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
                        if(isSalesReport){
                          commonController.getSalesReport();
                        }else if(isReceiptReport){
                          commonController.getReceiptReport();
                        }else if(isBillReport){
                          commonController.getBillReport();
                        }
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
      late final List<Object> list;
      late final String emptyLabel;

      switch (widget.title) {
        case "Sales Report":
          list = commonController.salesReportList;
          emptyLabel = "No Sales Report Found";
          break;
        case "Receipt Report":
          list = commonController.receiptReportList;
          emptyLabel = "No Receipt Report Found";
          break;
        case "Bill Report":
          list = commonController.billReportList; // make sure this exists
          emptyLabel = "No Bill Report Found";
          break;
        default:
          list = const [];
          emptyLabel = "No Data Found";
      }

      if (list.isEmpty) {
        return Center(
          child: Text(
            emptyLabel,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return Expanded(
        child: ListView.builder(
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
        
            if (item is SalesResult) {
              final details = item.salesDetails ?? [];
              return Column(
                children: details
                    .map((detail) => _salesReportCard(result: item, detail: detail))
                    .toList(),
              );
            } else if (item is ReceiptResult) {
              final details = item.receiptDetails ?? []; // adjust field name
              return Column(
                children: details
                    .map((detail) => _receiptReportCard(result: item, detail: detail))
                    .toList(),
              );
            }else if (item is BillResult) {
              final details = item.billDetails ?? []; // adjust field name
              return Column(
                children: details
                    .map((detail) => _billReportCard(result: item, detail: detail))
                    .toList(),
              );
            }
        
            return const SizedBox.shrink();
          },
        ),
      );
    });
  }

  Widget _commonReportCard({
    required String date,
    required String documentNo,
    required String companyName,
    required dynamic erpCost,
    dynamic cash,
    dynamic account,
    required dynamic gst,
    dynamic tds,
    dynamic netAmount,
    String noLabel = "No",
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.9),
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
          // ==================================================
          // DATE + DOCUMENT NO + COMPANY
          // ==================================================
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
                      size: 18,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        date.isNotEmpty ? date : "--",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    Text(
                      documentNo.isNotEmpty ? documentNo : "--",
                      style: const TextStyle(
                        fontSize: 13,
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
                    companyName.isNotEmpty ? companyName : "--",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if(widget.title != "Bill Report")
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE0E0E0),
          ),

          // ==================================================
          // ERP COST + CASH + ACCOUNT
          // ==================================================
          if(widget.title != "Bill Report")
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _reportAmountItem(
                    title: widget.title == "Sales Report" ? "ERP COST" : "RECEIPT AMT",
                    value: erpCost,
                    labelColor: const Color(0xFF6D5BD0),
                    amountColor: const Color(0xFF5746B8),
                  ),
                ),

                _reportDivider(),

                Expanded(
                  child: _reportAmountItem(
                    title: "CASH",
                    value: cash,
                    labelColor: const Color(0xFF2E8B6D),
                    amountColor: const Color(0xFF217052),
                  ),
                ),

                _reportDivider(),

                Expanded(
                  child: _reportAmountItem(
                    title: "ACCOUNT",
                    value: account,
                    labelColor: const Color(0xFFC58A32),
                    amountColor: const Color(0xFFA96F18),
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

          // ==================================================
          // GST + TDS
          // ==================================================
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _reportAmountItem(
                    title: widget.title == "Bill Report" ? "BILL AMT" : "GST",
                    value: widget.title == "Bill Report" ? erpCost : gst,
                    labelColor: const Color(0xFF2685A6),
                    amountColor: const Color(0xFF1D6D8A),
                  ),
                ),

                _reportDivider(),

                Expanded(
                  child: _reportAmountItem(
                    title: widget.title == "Bill Report" ? "GST" : "TDS",
                    value: widget.title == "Bill Report" ? gst : tds,
                    labelColor: const Color(0xFFA85D72),
                    amountColor: const Color(0xFF8F465C),
                  ),
                ),
                if(widget.title != "Receipt Report")
                _reportDivider(),
                if(widget.title != "Receipt Report")
                Expanded(
                  child: _reportAmountItem(
                    title: "NET AMT",
                    value: netAmount,
                    labelColor: const Color(0xFF3F6F55),
                    amountColor: Color(0xFF278447),
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

          // ==================================================
          // NET AMOUNT
          // ==================================================
          // if(widget.title == "Sales Report" || widget.title == "Bill Report")
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 14,
          //     vertical: 8,
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       const Text(
          //         "Net Amount   ",
          //         style: TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.w500,
          //           color: Color(0xFF3F6F55),
          //         ),
          //       ),
          //
          //
          //       Flexible(
          //         child: FittedBox(
          //           fit: BoxFit.scaleDown,
          //           alignment: Alignment.centerRight,
          //           child: Text(
          //             "₹ ${netAmount ?? 0}",
          //             style: const TextStyle(
          //               fontSize: 16,
          //               fontWeight: FontWeight.w700,
          //               color: Color(0xFF278447),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _salesReportCard({
    required SalesResult result,
    required SalesDetail detail,
  }) {
    return _commonReportCard(
      date: detail.date ??
          result.companyDate ??
          "--",
      documentNo: detail.salesNo ?? "--",
      companyName: result.companyName ?? "--",
      erpCost: detail.erpCost,
      cash: detail.cashPortion,
      account: detail.accountPortion,
      gst: detail.gst,
      tds: detail.tds,
      netAmount: detail.netAmount,
      noLabel: "Sales No",
    );
  }

  Widget _receiptReportCard({
    required ReceiptResult result,
    required ReceiptDetail detail,
  }) {
    return _commonReportCard(
      date: detail.date?.toString() ??
          result.companyDate?.toString() ??
          "--",
      documentNo: detail.receiptNo ?? "--",
      companyName: result.companyName ?? "--",
      erpCost: detail.receivedAmount,
      cash: detail.cashPortion,
      account: detail.bankPortion,
      gst: detail.gst,
      tds: detail.tds,
      noLabel: "Receipt No",
    );
  }

  Widget _billReportCard({
    required BillResult result,
    required BillDetail detail,
  }) {
    return _commonReportCard(
      date: detail.date ??
          result.companyDate ??
          "--",
      documentNo: detail.billNo ?? "--",
      companyName: result.companyName ?? "--",
      erpCost: detail.billAmount,
      gst: detail.gst,
      netAmount: detail.netAmount,
      noLabel: "Bill No",
    );
  }



  Widget _reportAmountItem({
    required String title,
    required num? value,
    bool isNetAmount = false,
    Color? labelColor,
    Color? amountColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              // fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              // color: Colors.grey,
              // fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isNetAmount
                  ? const Color(0xFF267A42)
                  : labelColor ,
            ),
          ),

          const SizedBox(height: 2),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              _formatAmount(value),
              style: TextStyle(
                fontSize: isNetAmount ? 16 : 14,
                fontWeight:
                isNetAmount ? FontWeight.w700 : FontWeight.w500,
                color: isNetAmount
                    ? const Color(0xFF155A2F)
                    : amountColor ,
              ),
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
