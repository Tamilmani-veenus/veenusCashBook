import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'list_screen.dart';

class CashBookHomeScreen extends StatelessWidget {
  const CashBookHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                size: 28,
                color: AppColors.primary,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

        title: const Text(
          'CashBook',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
            ),
            onPressed: () {},
          ),
        ],
      ),

      // ================= DRAWER =================
      drawer: const CashBookDrawer(),

      // ================= BODY =================
      body: SafeArea(
        child: Column(
          children: [
            buildGreetingSection(),
            
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Logo with soft background
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withOpacity(0.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.10),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Transform.translate(
                          offset: const Offset(2, -6),
                          child: Image.asset(
                            'assets/veenuslogo.png',
                            width: 130,
                            height: 130,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'CashBook',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: -0.7,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Smart Cash Management',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.subText,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 16,
                            color: AppColors.accent,
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Simple • Smart • Organized',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
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
}

class CashBookDrawer extends StatelessWidget {
  const CashBookDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      width: 320,
      child: SafeArea(
        child: Column(
          children: [

            // =========================
            // DRAWER HEADER
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 28,
                bottom: 28,
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [

                  // CashBook Logo
                  Image.asset(
                    'assets/drawerimg.png',
                    height: 150,
                    fit: BoxFit.cover,
                  ),


                  // // CashBook
                  // const Text(
                  //   'CashBook',
                  //   style: TextStyle(
                  //     fontFamily: 'Poppins',
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.w700,
                  //     color: AppColors.primary,
                  //     letterSpacing: -0.5,
                  //   ),
                  // ),

                  // Tagline
                  const Text(
                    'Smart Cash Management',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.blueGrey
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 2,
              color: AppColors.border,
            ),

            const SizedBox(height: 18),

            // =========================
            // MENU
            // =========================

            _drawerItem(
              context,
              icon: Icons.business_outlined,
              title: 'Company Details',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ListScreen(title: 'Company Details')));
              },
            ),

            _drawerItem(
              context,
              icon: Icons.shopping_cart_outlined,
              title: 'Sales Details',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ListScreen(title: 'Sales Details')));
              },
            ),

            _drawerItem(
              context,
              icon: Icons.receipt_long_outlined,
              title: 'Receipts Details',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ListScreen(title: 'Receipts Details')));
              },
            ),

            _drawerItem(
              context,
              icon: Icons.description_outlined,
              title: 'Bill Details',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ListScreen(title: 'Bill Details')));
              },
            ),

            _drawerItem(
              context,
              icon: Icons.bar_chart_outlined,
              title: 'Reports',
              onTap: () {
                Navigator.pop(context);
                // EntryScreen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 2,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              children: [

                // =====================
                // ICON
                // =====================
                SizedBox(
                  width: 42,
                  child: Icon(
                    icon,
                    color: AppColors.drawerIcon,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 16),

                // =====================
                // TITLE
                // =====================
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ),

                // =====================
                // ARROW
                // =====================
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.subText,
                  size: 27,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildGreetingSection() {
  final now = DateTime.now();

  String greeting;

  if (now.hour < 12) {
    greeting = "Good Morning!";
  } else if (now.hour < 17) {
    greeting = "Good Afternoon!";
  } else {
    greeting = "Good Evening!";
  }

  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        // ================= GREETING =================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                '$greeting 👋',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                    color: AppColors.text
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Here's your cash overview",
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xff8A96A8),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // ================= DATE CARD =================
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Calendar
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 19,
                  color: Color(0xff1677FF),
                ),
              ),

              const SizedBox(width: 8),

              // Date text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    '${_getMonthName(now.month)} ${now.day}, ${now.year}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff172B4D),
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    _getDayName(now.weekday),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
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

String _getDayName(int weekday) {
  const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  return days[weekday - 1];
}

String _getMonthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  return months[month - 1].substring(0, 3);
}