import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:veenuscashbook/controller/companyDetails_controller.dart';
import '../app_theme.dart';
import '../common_utils/common_listScreen.dart';
import '../entry_screen.dart';
import '../utilities/requestconstant.dart';

class CompanyListScreen extends StatefulWidget {
  final String title;

  const CompanyListScreen({
    super.key,
    required this.title,
  });

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  CompanyDetailsController companyDetailsController = Get.put(CompanyDetailsController());
  int? expandedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    companyDetailsController.getCompanyDetails_List();
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


          const SizedBox(height: 8),
          Expanded(
            child: Obx(
                  () {
                if (companyDetailsController.CompanyDetailsList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Company Details Found",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppColors.subText,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 10,
                  ),
                  itemCount: companyDetailsController.CompanyDetailsList.length,
                  itemBuilder: (context, index) {
                    return _companyCard(index);
                  },
                );
              },
            ),
          )
          // List
          // Expanded(
          //   child: ListView.builder(
          //     padding: const EdgeInsets.fromLTRB(
          //       18,
          //       5,
          //       18,
          //       90,
          //     ),
          //     itemCount: 10,
          //     itemBuilder: (context, index) {
          //       return _listItem(index);
          //     },
          //   ),
          // ),
        ],
      ),

      bottomNavigationBar: Obx(
            () => CommonRequestBottomBar(
          totalCount: companyDetailsController.CompanyDetailsList.length,
          onAdd: () {
            companyDetailsController.saveButton.value =
                RequestConstant.SUBMIT;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EntryScreen(
                   title: widget.title,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _companyCard(int index) {
    final company = companyDetailsController.CompanyDetailsList[index];

    final String companyName =
    company.companyName?.trim().isNotEmpty == true
        ? company.companyName!.trim()
        : "--";

    final String initial =
    companyName != "--"
        ? companyName.substring(0, 1).toUpperCase()
        : "?";

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
        left: 10,
        right: 10,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Company
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      company.companyAddress ?? "--",
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

              // Edit
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  companyDetailsController
                      .saveButton
                      .value =
                      RequestConstant
                          .RESUBMIT;
                  FocusScope.of(
                      context)
                      .unfocus();
                  companyDetailsController.CompanyDetails_List_EditApi(
                      companyDetailsController
                          .CompanyDetailsList
                          .value[
                      index]
                          .id,widget.title,
                      context);
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 17,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(width: 7),

              // Delete
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  await companyDetailsController.DeleteAlert(
                  context,
                  index);
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Divider
          Container(
            height: 1,
            color: AppColors.border.withOpacity(.7),
          ),

          const SizedBox(height: 8),

          // Contact information
          Row(
            children: [
              Expanded(
                child: _companyInfo(
                  icon: Icons.phone_outlined,
                  title: "Contact",
                  value: company.contactNo ?? "--",
                ),
              ),

              Container(
                width: 1,
                height: 30,
                color: AppColors.border,
              ),

              Expanded(
                child: _companyInfo(
                  icon: Icons.location_city_outlined,
                  title: "City",
                  value: company.city ?? "--",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _companyInfo({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        ),

        const SizedBox(width: 7),

        Flexible(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: AppColors.subText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}