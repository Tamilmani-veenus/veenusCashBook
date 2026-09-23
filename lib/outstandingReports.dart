import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:veenuscashbook/controller/common_controller.dart';
import 'package:veenuscashbook/utilities/baseutitiles.dart';
import 'package:veenuscashbook/utilities/requestconstant.dart';
import 'app_theme.dart';

class OutStandingBillReportWidget extends StatefulWidget {
  final String title;

  const OutStandingBillReportWidget({
    super.key,
    required this.title,
  });

  @override
  State<OutStandingBillReportWidget> createState() => _OutStandingBillReportWidgetState();
}

class _OutStandingBillReportWidgetState extends State<OutStandingBillReportWidget> {

  CommonController commonController = Get.put(CommonController());

  bool get _isBillOutstanding => widget.title == "Bill Outstanding Report";
  bool get _istdsOutstanding => widget.title == "TDS Report";

  bool? isCustomDate = null;

  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    DateTime oneWeekBefore = currentDate.subtract(const Duration(days: 7));
    commonController.RptFromDate.text=BaseUtitiles.formatApiDate(oneWeekBefore);
    commonController.RptToDate.text=BaseUtitiles.formatApiDate(currentDate);
    commonController.overallBillTotal.value = null;
    commonController.overalltdsTotal.value = null;
    commonController.billOutstandingList.value = [];
    commonController.tdsReportList.value = [];
    commonController.outstandingList.value = [];
    commonController.financialYearList.value = [];
    commonController.getFinancialReportData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () {
          final bool isBill = _isBillOutstanding;
          final bool isTds = _istdsOutstanding;

          final dynamic total = isBill
              ? commonController.overallBillTotal.value : isTds ? commonController.overalltdsTotal.value
              : commonController.overallTotal.value;

          final List list = isBill
              ? commonController.billOutstandingList : isTds ? commonController.tdsReportList
              : commonController.outstandingList;

          // if (list.isEmpty && total == null) {
          //   return const SizedBox.shrink();
          // }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _dateFilterCard(),
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
                      if (_isBillOutstanding) {
                        await commonController.getBillOutStandingReport();
                      }else if(_istdsOutstanding) {
                        await commonController.getTdsReport();
                      }else {
                        await commonController.getOutStandingReport();
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),

              if (total != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isBill ? _billSummaryGrid(total) : _istdsOutstanding ? _totalSummary(total) : _totalSummary(total),
                ),

              const SizedBox(height: 12),

              if (list.isNotEmpty) ...[
                isBill
                    ? const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      Text(
                        "Company Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff17245E),
                        ),
                      ),
                    ],
                  ),
                )
                    : const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "Company Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff17245E),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isBill
                            ? _billCompanyCard(list[index])
                            : _companyCard(list[index]),
                      );
                    },
                  ),
                )
              ],
            ],
          );
        },
      ),
    );
  }

  void _loadDefaultCustomDates() {
    final today = DateTime.now();

    final fromDate = today.subtract(
      const Duration(days: 7),
    );

    setState(() {
      isCustomDate = true;

      commonController.selectedFinancialYearId = 0;
      commonController.selectedFinancialYear = null;

      commonController.RptFromDate.text =
          BaseUtitiles.formatApiDate(fromDate);

      commonController.RptToDate.text =
          BaseUtitiles.formatApiDate(today);
    });
  }

  Future<void> _showFinancialYearDialog() async {
    if (commonController.financialYearList.isEmpty) {
      await commonController.getFinancialReportData();
    }

    if (commonController.financialYearList.isEmpty) {
      return;
    }

    final selected = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Select Financial Year",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xff17245E),
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            12,
            8,
            12,
            12,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Obx(
                  () => ListView.separated(
                shrinkWrap: true,
                itemCount: commonController.financialYearList.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final item = commonController.financialYearList[index];

                  final year = item['accountYear']?.toString() ?? '';

                  final isSelected =
                      commonController.selectedFinancialYear == year;

                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.pop(context, item);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xffF0F5FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            size: 20,
                            color: const Color(0xff3048A1),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            year,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: const Color(0xff17245E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      _applyFinancialYear(selected);
    }
  }

  void _applyFinancialYear(Map<String, dynamic> item) {
    final accountYear =
        item['accountYear']?.toString() ?? '';

    if (accountYear.isEmpty) return;

    // Example:
    // 26-27 -> 2026
    // 25-26 -> 2025

    final parts = accountYear.split('-');

    if (parts.length != 2) return;

    final startShortYear = int.tryParse(parts[0]);

    if (startShortYear == null) return;

    final startYear = 2000 + startShortYear;
    final endYear = startYear + 1;

    final fromDate = DateTime(
      startYear,
      4,
      1,
    );

    final toDate = DateTime(
      endYear,
      3,
      31,
    );

    setState(() {
      isCustomDate = false;

      commonController.selectedFinancialYearId = item['id'];
      commonController.selectedFinancialYear = accountYear;

      commonController.RptFromDate.text =
          BaseUtitiles.formatApiDate(fromDate);

      commonController.RptToDate.text =
          BaseUtitiles.formatApiDate(toDate);
    });
  }

  Widget _dateFilterCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xffDCE6F7),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              // ---------------- FINANCIAL YEAR ----------------
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    await _showFinancialYearDialog();
                  },
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: false,
                        groupValue: isCustomDate,
                        activeColor: const Color(0xff3048A1),
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                        onChanged: (_) async {
                          await _showFinancialYearDialog();
                        },
                      ),

                      const SizedBox(width: 4),

                      const Flexible(
                        child: Text(
                          "Financial Year",
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff17245E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ---------------- CUSTOM DATE ----------------
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      isCustomDate = true;
                    });
                  },
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: isCustomDate,
                        activeColor: const Color(0xff3048A1),
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                        onChanged: (value) {
                          _loadDefaultCustomDates();
                          // setState(() {
                          //   isCustomDate = value ?? false;
                          // });
                        },
                      ),

                      const SizedBox(width: 4),

                      const Flexible(
                        child: Text(
                          "Custom Date",
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff5C6B92),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (isCustomDate != null) ...[
            const SizedBox(height: 8),

            Row(
              children: [

                // ---------------- FROM ----------------
                Expanded(
                  child: _dateBox(
                    title: "From",
                    controller: commonController.RptFromDate,
                    enabled: isCustomDate == true,
                    onTap: () async {
                      DateTime today = DateTime.now();
                      DateTime initialDate = today.subtract(const Duration(days: 7));

                      if (initialDate.isBefore(DateTime(1900))) {
                        initialDate = DateTime(1900);
                      }
                      var Frdate = await showDatePicker(
                          context: context,
                          initialDate: initialDate,
                          firstDate: DateTime(1900),
                          lastDate: today,
                          builder: (context, child) {
                            return Theme(data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.primary, // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Colors.black, // button text color
                                ),
                              ),
                            ),
                              child: child!,
                            );
                          });
                         setState(() {
                          // Store yyyy-MM-dd for API
                          commonController.RptFromDate.text =
                              BaseUtitiles.formatApiDate(Frdate!);
                        });

                    },
                  ),
                ),

                const SizedBox(width: 10),

                // ---------------- TO ----------------
                Expanded(
                  child: _dateBox(
                    title: "To",
                    controller: commonController.RptToDate,
                    enabled: isCustomDate == true,
                    onTap: () async {
                      DateTime today = DateTime.now();
                      DateTime fromDate = DateTime.parse(commonController.RptFromDate.text);
                      var ToDate = await showDatePicker(
                          context: context,
                          initialDate: today.isBefore(fromDate) ? fromDate : today,
                          firstDate: fromDate,
                          lastDate:  DateTime.now(),
                          builder: (context, child) {
                            return Theme(data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.primary, // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Colors.black, // button text color
                                ),
                              ),
                            ),
                              child: child!,
                            );
                          });
                      if (ToDate != null) {
                        setState(() {
                          // Store yyyy-MM-dd for API
                          commonController.RptToDate.text =
                              BaseUtitiles.formatApiDate(ToDate);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _dateBox({
    required String title,
    required TextEditingController controller,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    String displayDate = "";

    if (controller.text.isNotEmpty) {
     displayDate = BaseUtitiles.formatDisplayDate(
        DateTime.parse(controller.text),
      );
    }
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffF0F5FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xffC8D9FF),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xff68779D),
              ),
            ),

            const SizedBox(height: 3),

            Row(
              children: [
                Expanded(
                  child: Text(
                    displayDate.isEmpty
                        ? "Select date"
                        : displayDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: controller.text.isEmpty
                          ? const Color(0xff9AA6C7)
                          : const Color(0xff17245E),
                    ),
                  ),
                ),

                const SizedBox(width: 5),

                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Color(0xff3048A1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalSummary(dynamic total) {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            title: _istdsOutstanding ? "Total TDS" : "Total Sales",
            amount: _istdsOutstanding ? total.tdsAmount : total.salesAmount,
            icon: Icons.account_balance_wallet_rounded,
            iconColor: const Color(0xff1687E8),
            backgroundColor: const Color(0xffF0F7FF),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _summaryCard(
            title: _istdsOutstanding ? "Total Received" : "Total Receipt",
            amount: _istdsOutstanding ? total.receivedAmount : total.receiptAmount,
            icon: Icons.receipt_long_rounded,
            iconColor: const Color(0xff009B6B),
            backgroundColor: const Color(0xffEDFFF7),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _summaryCard(
            title: "Total Balance",
            amount: total.balanceAmount,
            icon: Icons.account_balance_rounded,
            iconColor: const Color(0xff6236D9),
            backgroundColor: const Color(0xffF5F0FF),
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required num? amount,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: iconColor.withOpacity(0.18),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.12),
            ),
            child: Icon(
              icon,
              size: 22,
              color: iconColor,
            ),
          ),

          const SizedBox(height: 5,),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff17245E),
            ),
          ),

          const SizedBox(height: 3),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _formatAmount(amount),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _companyCard(dynamic item) {
    final String companyName =
    (item.companyName ?? "").toString().trim();

    final num salesAmount =
        _istdsOutstanding ? item.tdsAmount ?? 0 : item.salesAmount ?? 0;


    final num receiptAmount =
    _istdsOutstanding ? item.receivedAmount ?? 0 : item.receiptAmount ?? 0;

    final num balanceAmount =
        item.balanceAmount ?? 0;

    final bool isNegative = balanceAmount < 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xffDCE6F7),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: Text(
                  companyName.isNotEmpty
                      ? companyName[0].toUpperCase()
                      : "?",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  companyName.isEmpty
                      ? "-"
                      : companyName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff17245E),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _amountBox(
                  label: _istdsOutstanding ? "TDS Amount" : "Sales Amount",
                  value: _formatAmount(salesAmount),
                  backgroundColor: const Color(0xffEFF3FF),
                  borderColor: const Color(0xffD0DCFA),
                  labelColor: const Color(0xff3357B2),
                  valueColor: const Color(0xff17245E),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                flex: 5,
                child: _amountBox(
                  label: _istdsOutstanding ? "Input Amount" : "Receipt Amount",
                  value: _formatAmount(receiptAmount),
                  backgroundColor: const Color(0xffFFF6E9),
                  borderColor: const Color(0xffFCE3B4),
                  labelColor: const Color(0xffB0790F),
                  valueColor: const Color(0xff17245E),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                flex: 5,
                child: _amountBox(
                  label: "Balance",
                  value: _formatAmount(balanceAmount),
                  backgroundColor: isNegative
                      ? const Color(0xffFFF0F0)
                      : const Color(0xffE9FFF5),
                  borderColor: isNegative
                      ? const Color(0xffFFD0D0)
                      : const Color(0xffB8F0D5),
                  labelColor: isNegative
                      ? const Color(0xffD92D20)
                      : const Color(0xff16805A),
                  valueColor: isNegative
                      ? const Color(0xffE12D2D)
                      : const Color(0xff16805A),
                  valueFontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amountBox({
    required String label,
    required String value,
    required Color backgroundColor,
    required Color borderColor,
    required Color labelColor,
    required Color valueColor,
    FontWeight valueFontWeight = FontWeight.w700,
  }) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Color(0xffF0F5FF),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
                color: Color(0xff5C6B92)
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: valueFontWeight,
                color: Color(0xff17245E),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _billSummaryGrid(dynamic total) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _billSummaryCard(
                title: "Total Sales",
                amount: total.salesAmount,
                icon: Icons.monetization_on_rounded,
                iconColor: const Color(0xff1677D2),
                backgroundColor: const Color(0xffEAF2FF),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _billSummaryCard(
                title: "Total Received",
                amount: total.totalReceivedAmount,
                icon: Icons.description_rounded,
                iconColor: const Color(0xff17A673),
                backgroundColor: const Color(0xffE9FFF5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _billSummaryCard(
                title: "Total Bill Amount",
                amount: total.billAmount,
                icon: Icons.description_rounded,
                iconColor: const Color(0xffE68A00),
                backgroundColor: const Color(0xffFFF3E0),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _billSummaryCard(
                title: "Total Balance",
                amount: total.balanceAmount,
                icon: Icons.balance_rounded,
                iconColor: const Color(0xff6236D9),
                backgroundColor: const Color(0xffF5F0FF),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _billSummaryCard({
    required String title,
    required num? amount,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 5,),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withOpacity(0.15),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff17245E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _formatAmount(amount),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _billCompanyCard(dynamic item) {
    final String companyName =
    (item.companyName ?? "").toString().trim();

    final num salesAmount = item.salesAmount ?? 0;
    final num receiptAmount = item.totalReceivedAmount ?? 0;
    final num billAmount = item.billAmount ?? 0;
    final num balanceAmount = item.balanceAmount ?? 0;


    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffDCE6F7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER : avatar + name + chevron
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: Text(
                            companyName.isNotEmpty ? companyName[0].toUpperCase() : "?",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            companyName.isEmpty ? "-" : companyName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff17245E),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // ROW 1 : Sales / Received
                    Row(
                      children: [
                        Expanded(
                          child: _billAmountBox(
                            icon: Icons.monetization_on_rounded,
                            label: "Sales Amount",
                            value: _formatAmount(salesAmount),
                            valueColor: const Color(0xff17245E),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _billAmountBox(
                            icon: Icons.description_rounded,
                            label: "Received Amount",
                            value: _formatAmount(receiptAmount),
                            valueColor: const Color(0xff17245E),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ROW 2 : Bill Amount / Balance
                    Row(
                      children: [
                        Expanded(
                          child: _billAmountBox(
                            icon: Icons.description_rounded,
                            label: "Bill Amount",
                            value: _formatAmount(billAmount),
                            valueColor: const Color(0xff17245E),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _billAmountBox(
                            icon: Icons.balance_rounded,
                            label: "Balance",
                            value: _formatAmount(balanceAmount),
                            valueColor: const Color(0xff17245E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billAmountBox({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xffF0F5FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(icon, color: AppColors.primary, size: 17),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Color(0xff5C6B92)),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: valueColor,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  String _formatAmount(num? value) {
    final amount = value ?? 0;

    final isNegative = amount < 0;
    final absoluteAmount = amount.abs();

    final parts = absoluteAmount
        .toStringAsFixed(2)
        .split('.');

    String number = parts[0];

    if (number.length > 3) {
      final lastThree = number.substring(
        number.length - 3,
      );

      String remaining = number.substring(
        0,
        number.length - 3,
      );

      final groups = <String>[];

      while (remaining.length > 2) {
        groups.insert(
          0,
          remaining.substring(
            remaining.length - 2,
          ),
        );

        remaining = remaining.substring(
          0,
          remaining.length - 2,
        );
      }

      if (remaining.isNotEmpty) {
        groups.insert(0, remaining);
      }

      number = "${groups.join(",")},$lastThree";
    }

    return "₹ ${isNegative ? "-" : ""}$number.${parts[1]}";
  }

  // ==========================================================
  Color _companyColor(String name) {
    if (name.isEmpty) {
      return const Color(0xff64748B);
    }

    final colors = [
      const Color(0xff1677D2),
      const Color(0xff6633D8),
      const Color(0xff079A68),
      const Color(0xffE68A00),
      const Color(0xffE34D72),
    ];

    return colors[name.codeUnitAt(0) % colors.length];
  }
}