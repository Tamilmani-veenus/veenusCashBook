import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:veenuscashbook/controller/companyDetails_controller.dart';
import 'package:veenuscashbook/utilities/requestconstant.dart';

import 'app_theme.dart';

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


  @override
  void initState() {
    super.initState();
    var duration = const Duration(seconds:0);
    Future.delayed(duration,() async {

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

      if(companyDetailsController.saveButton.value ==RequestConstant.SUBMIT){
        companyDetailsController.companyNameController.text = "";
        companyDetailsController.AdressController.text = "";
        companyDetailsController.ContactNoController.text = "";
        companyDetailsController.selectedCity = "--SELECT--";
        companyDetailsController.emailController.text = "";
        companyDetailsController.GSTNoController.text = "";
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      companyDetailsController.getDropDownCityValues();
    });
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

      body: SingleChildScrollView(
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

                  _entryField(
                    label: 'Company Name',
                    hint: 'Enter company name',
                    icon: Icons.business_outlined,
                    controller: companyDetailsController.companyNameController
                  ),
                  const SizedBox(height: 16),

                  _entryField(
                    label: 'Address',
                    hint: 'Enter address',
                    icon: Icons.location_on_outlined,
                    controller: companyDetailsController.AdressController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  _entryField(
                    label: 'Contact No.',
                    hint: 'Enter contact number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.number,
                    controller: companyDetailsController.ContactNoController
                  ),
                  const SizedBox(height: 16),

                  _entryField(
                    label: 'City',
                    hint: 'Select city',
                    icon: Icons.location_city_outlined,
                    isDropdown: true,
                  ),
                  const SizedBox(height: 16),

                  _entryField(
                    label: 'Email',
                    hint: 'Enter email address',
                    icon: Icons.email_outlined,
                    controller: companyDetailsController.emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  _entryField(
                    label: 'GST No.',
                    hint: 'Enter GST number',
                    icon: Icons.receipt_long_outlined,
                    controller: companyDetailsController.GSTNoController,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

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
                  SubmitAlert(context);
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
                  companyDetailsController.saveButton.value,
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

        if (isDropdown)
          Obx(
                () => DropdownButtonFormField2<String>(
              value: companyDetailsController.selectedCity,

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

              // API dropdown values
                  items: [
                    // Default value
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

                    // API values
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
                    }).toList(),
                  ],

              onChanged: (value) {
                setState(() {
                  companyDetailsController.selectedCity = value ?? "--SELECT--";
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
            ),
          )
        else
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,

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
        title: const Text('Alert!',style: TextStyle(fontSize: 14),),
        content: Text(companyDetailsController.saveButton==RequestConstant.RESUBMIT  ? 'Are you sure to Re-Submit?' :
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
                            // if (await BaseUtitiles.checkNetworkAndShowLoader(context)) {
                              await companyDetailsController.SaveButton_CompanyDetails(
                                context, companyDetailsController.companyId != 0 ? companyDetailsController.companyId : 0,
                              );
                            // }
                        },
                        child: Text(
                          companyDetailsController.saveButton.value,
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