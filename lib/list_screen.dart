import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:veenuscashbook/controller/receiptDetails_controller.dart';
import 'package:veenuscashbook/controller/salesDetails_controller.dart';
import 'package:veenuscashbook/utilities/requestconstant.dart';

import 'app_theme.dart';
import 'entry_screen.dart';

class ListScreen extends StatefulWidget {
  final String title;

  const ListScreen({
    super.key,
    required this.title,
  });

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  SalesDetailController salesDetailController = Get.put(SalesDetailController());
  ReceiptDetailsController receiptDetailsController = Get.put(ReceiptDetailsController());
  int? expandedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    salesDetailController.getSalesDetails_List();
    receiptDetailsController.getReceiptDetails_List();
  }

  @override
  Widget build(BuildContext context) {
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

      body: Column(
        children: [

          // Search + filter
          Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              16,
              18,
              10,
            ),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search ...',
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppColors.subText,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.drawerIcon,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

              ],
            ),
          ),

          // Summary
          Obx(() {
            final int totalEntries =
                widget.title == "Sales Details" ? salesDetailController.SalesDetailsList.length : receiptDetailsController.ReceiptDetailsList.length;

            final double totalAmount =
            widget.title == "Sales Details" ? salesDetailController.SalesDetailsList.fold<double>(
              0.0,
                  (sum, item) => sum + (item.erpCost ?? 0),
            ) :receiptDetailsController.ReceiptDetailsList.fold<double>(
              0.0,
                  (sum, item) => sum + (item.receivedAmount ?? 0) ) ;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Entries',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$totalEntries',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '₹ ${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 8),

          // List
          Expanded(
            child: Obx(()=>
                ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  5,
                  18,
                  90,
                ),
                itemCount: widget.title == "Sales Details" ? salesDetailController.SalesDetailsList.length : receiptDetailsController.ReceiptDetailsList.length,
                itemBuilder: (context, index) {
                  return _listItem(index);
                },
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: 4,
        onPressed: () {
          widget.title == "Sales Details" ? salesDetailController.saveButton.value = RequestConstant.SUBMIT : receiptDetailsController.saveButton.value = RequestConstant.SUBMIT;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>EntryScreen(title: widget.title)));
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 27,
        ),
      ),
    );
  }

  Widget _listItem(int index) {
    final bool isExpanded = expandedIndex == index;

    final sales = salesDetailController.SalesDetailsList[index];
    final receipt = receiptDetailsController.ReceiptDetailsList[index];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpanded
              ? AppColors.accent
              : AppColors.border,
          width: isExpanded ? 1.2 : 1,
        ),
        boxShadow: isExpanded
            ? [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ]
            : null,
      ),
      child: Column(
        children: [

          // =========================
          // MAIN ITEM
          // =========================
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [

                // =========================
                // DATE
                // =========================
                Container(
                  width: 48,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getDay(widget.title == "Sales Details" ? sales.date : receipt.date),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        _getMonth(widget.title == "Sales Details" ? sales.date : receipt.date),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: AppColors.drawerIcon,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 13),

                // =========================
                // COMPANY + SALES NO
                // =========================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title == "Sales Details" ? sales.companyName ?? '' : receipt.companyName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        widget.title == "Sales Details" ? "SalesNo : ${sales.salesNo ?? ''}" : "ReceiptNo : ${receipt.receiptNo ?? ''}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.subText,
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================
                // ERP COST
                // =========================
                Text(
                  widget.title == "Sales Details" ? '₹ ${sales.erpCost ?? 0}' : '₹ ${receipt.receivedAmount ?? 0}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 4),

                // =========================
                // MORE BUTTON
                // =========================
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(() {
                      if (expandedIndex == index) {
                        expandedIndex = null;
                      } else {
                        expandedIndex = index;
                      }
                    });
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? AppColors.lightBlue
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.more_vert_rounded,
                      color: AppColors.primary,
                      size: 23,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =========================
          // EXPANDED ACTIONS
          // =========================
          if (isExpanded) ...[
            const Divider(
              height: 1,
              color: AppColors.border,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  // =========================
                  // EDIT
                  // =========================
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      salesDetailController
                          .saveButton
                          .value =
                          RequestConstant
                              .RESUBMIT;
                      FocusScope.of(
                          context)
                          .unfocus();
                      salesDetailController.SalesDetails_List_EditApi(
                          salesDetailController
                              .SalesDetailsList
                              .value[
                          index]
                              .id,widget.title,
                          context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: AppColors.drawerIcon,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Edit',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // =========================
                  // DELETE
                  // =========================
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      await salesDetailController.DeleteAlert(
                          context,
                          index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Delete',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getDay(String? date) {
    if (date == null || date.isEmpty) {
      return '--';
    }

    try {
      final parsedDate = DateTime.parse(date);
      return parsedDate.day.toString().padLeft(2, '0');
    } catch (e) {
      return '--';
    }
  }

  String _getMonth(String? date) {
    if (date == null || date.isEmpty) {
      return '--';
    }

    try {
      final parsedDate = DateTime.parse(date);

      const months = [
        'JAN',
        'FEB',
        'MAR',
        'APR',
        'MAY',
        'JUN',
        'JUL',
        'AUG',
        'SEP',
        'OCT',
        'NOV',
        'DEC',
      ];

      return months[parsedDate.month - 1];
    } catch (e) {
      return '--';
    }
  }

}