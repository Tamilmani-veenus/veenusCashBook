import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:veenuscashbook/controller/billDetails_controller.dart';
import 'package:veenuscashbook/controller/common_controller.dart';
import 'package:veenuscashbook/controller/companyDetails_controller.dart';
import 'package:veenuscashbook/controller/receiptDetails_controller.dart';
import 'package:veenuscashbook/controller/salesDetails_controller.dart';
import 'package:veenuscashbook/utilities/baseutitiles.dart';
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
  CompanyDetailsController companyDetailsController = Get.put(CompanyDetailsController());
  SalesDetailController salesDetailController = Get.put(SalesDetailController());
  ReceiptDetailsController receiptDetailsController = Get.put(ReceiptDetailsController());
  BillDetailsController billDetailsController = Get.put(BillDetailsController());
  CommonController commonController = Get.put(CommonController());
  int? expandedIndex;
  List<int> filteredIndexes = [];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchController.addListener(_searchList);

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadList());
  }

  Future<void> _loadList() async {
    if (isSalesDetails) {
      await salesDetailController.getSalesDetails_List();
    } else if (isReceiptDetails) {
      await receiptDetailsController.getReceiptDetails_List();
    } else if (isBillDetails) {
      await billDetailsController.getBillDetails_List();
    }
    if (mounted) setState(() => expandedIndex = null);
  }

  @override
  void dispose() {
    searchController.removeListener(_searchList);
    searchController.dispose();
    super.dispose();
  }

  bool get isSalesDetails => widget.title == "Sales Details";
  bool get isReceiptDetails => widget.title == "Receipt Details";
  bool get isBillDetails => widget.title == "Bill Details";

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
                    controller: searchController,
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
            isSalesDetails ? salesDetailController.SalesDetailsList.length : isReceiptDetails ? receiptDetailsController.ReceiptDetailsList.length : billDetailsController.BillDetailsList.length;

            final double totalAmount =
            isSalesDetails ? salesDetailController.SalesDetailsList.fold<double>(
              0.0,
                  (sum, item) => sum + (item.netPayAmt ?? 0),
            ) :isReceiptDetails ? receiptDetailsController.ReceiptDetailsList.fold<double>(
              0.0,
                  (sum, item) => sum + (item.netPayAmt ?? 0) ) : billDetailsController.BillDetailsList.fold<double>(
                0.0,
                    (sum, item) => sum + (item.netAmount ?? 0) ) ;

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

          Expanded(
            child: Obx(() {
              final indexes = _getFilteredIndexes();

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(18, 5, 18, 90),
                itemCount: indexes.length,
                itemBuilder: (context, index) => _listItem(indexes[index]),
              );
            }),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: 4,
        onPressed: () async {
          companyDetailsController.saveButton.value = RequestConstant.SUBMIT;
          salesDetailController.saveButton.value = RequestConstant.SUBMIT;
          receiptDetailsController.saveButton.value = RequestConstant.SUBMIT;
          billDetailsController.saveButton.value = RequestConstant.SUBMIT;

          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EntryScreen(title: widget.title)),
          );

          _loadList(); // runs when you come back to this screen
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
    final int length = isSalesDetails
        ? salesDetailController.SalesDetailsList.length
        : isReceiptDetails
        ? receiptDetailsController.ReceiptDetailsList.length
        : billDetailsController.BillDetailsList.length;

    if (index < 0 || index >= length) {
      return const SizedBox.shrink();
    }

    final String date;
    final String companyName;
    final String number;
    final num amount;

    if (isSalesDetails) {
      final sales = salesDetailController.SalesDetailsList[index];
      date = sales.date;
      companyName = sales.companyName ?? '';
      number = "SalesNo : ${sales.salesNo ?? ''}";
      amount = sales.netPayAmt ?? 0;
    } else if (isReceiptDetails) {
      final receipt = receiptDetailsController.ReceiptDetailsList[index];
      date = receipt.date;
      companyName = receipt.companyName ?? '';
      number = "ReceiptNo : ${receipt.receiptNo ?? ''}";
      amount = receipt.netPayAmt ?? 0;
    } else {
      final bill = billDetailsController.BillDetailsList[index];
      date = bill.date;
      companyName = bill.companyName ?? '' ;
      number = "BillNo : ${bill.billNo ?? ''}" ;
      amount = bill.netAmount ?? 0 ;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
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
                        AppUtils.getDay(date),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        AppUtils.getMonth(date),
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
                        companyName,
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
                        number,
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
                  "₹ ${amount.toString()}",
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
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      setState(() => expandedIndex = null);

                      if (isSalesDetails) {
                        await salesDetailController.SalesDetails_List_EditApi(
                            salesDetailController.SalesDetailsList[index].id, widget.title, context);
                      } else if (isReceiptDetails) {
                        await receiptDetailsController.ReceiptDetails_List_EditApi(
                            receiptDetailsController.ReceiptDetailsList[index].id, widget.title, context);
                      } else {
                        await billDetailsController.BillDetails_List_EditApi(
                            billDetailsController.BillDetailsList[index].id, widget.title, context);
                      }

                      _loadList();
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
                      setState(() {
                        expandedIndex = null;
                      });
                      await commonController.DeleteAlert(
                          context,
                          index,widget.title);
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

  void _resetFilteredList() {
    final count = _getOriginalListLength();

    setState(() {
      filteredIndexes = List.generate(
        count,
            (index) => index,
      );
    });
  }
  int _getOriginalListLength() {
    if (isSalesDetails) {
      return salesDetailController.SalesDetailsList.length;
    }

    if (isReceiptDetails) {
      return receiptDetailsController.ReceiptDetailsList.length;
    }

    return billDetailsController.BillDetailsList.length;
  }

  List<int> _getFilteredIndexes() {
    final query = searchController.text.trim().toLowerCase();

    // Read the right list (this also makes Obx listen to it)
    final int count = _getOriginalListLength();

    bool matches(List<Object?> fields) =>
        fields.any((f) => (f ?? '').toString().toLowerCase().contains(query));

    final List<int> result = [];

    for (int i = 0; i < count; i++) {
      if (query.isEmpty) {
        result.add(i);
        continue;
      }

      bool ok;
      if (isSalesDetails) {
        final s = salesDetailController.SalesDetailsList[i];
        ok = matches([s.companyName, s.salesNo, s.date, s.erpCost, s.netPayAmt]);
      } else if (isReceiptDetails) {
        final r = receiptDetailsController.ReceiptDetailsList[i];
        ok = matches([r.companyName, r.receiptNo, r.date, r.receivedAmount, r.netPayAmt]);
      } else {
        final b = billDetailsController.BillDetailsList[i];
        ok = matches([b.companyName, b.billNo, b.date, b.billAmount]);
      }

      if (ok) result.add(i);
    }

    return result;
  }

  void _searchList() {
    setState(() => expandedIndex = null);
  }

}

