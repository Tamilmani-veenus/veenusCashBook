import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

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
  String? selectedCity;

  final List<String> cities = [
    'Chennai',
    'Coimbatore',
    'Madurai',
    'Trichy',
  ];

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
                  ),
                  const SizedBox(height: 16),

                  _entryField(
                    label: 'Address',
                    hint: 'Enter address',
                    icon: Icons.location_on_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  _entryField(
                    label: 'Contact No.',
                    hint: 'Enter contact number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.number,
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
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  _entryField(
                    label: 'GST No.',
                    hint: 'Enter GST number',
                    icon: Icons.receipt_long_outlined,
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Save Entry',
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
          DropdownButtonFormField2<String>(
            value: selectedCity,

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

            items: cities.map((city) {
              return DropdownMenuItem<String>(
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
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                selectedCity = value;
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
          )
        else
          TextField(
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


}