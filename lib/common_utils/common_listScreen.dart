import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veenuscashbook/app_theme.dart';

import '../utilities/requestconstant.dart';

class CommonRequestBottomBar extends StatelessWidget {
  final int totalCount;
  final VoidCallback onAdd;

  const CommonRequestBottomBar({
    super.key,
    required this.totalCount,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.07),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [

          // ========================================================
          // TOTAL ICON
          // ========================================================

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.bar_chart_rounded,
              color: AppColors.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

          // ========================================================
          // TOTAL
          // ========================================================

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Requests",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff667085),
                ),
              ),

              const SizedBox(height: 2),

              Row(
                children: [
                  Text(
                    "$totalCount",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 4),

                  Text(
                    totalCount==1?"Request":"Requests",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff667085),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // ========================================================
          // ADD
          // ========================================================


            SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  AppColors.primary,
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 21,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      "Add",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:
                        RequestConstant.Lable_Font_SIZE,
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
