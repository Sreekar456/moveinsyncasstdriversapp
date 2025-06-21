import 'package:drivers_app/pages/earnings_page.dart';
import 'package:drivers_app/pages/home_page.dart';
import 'package:drivers_app/pages/profile_page.dart';
import 'package:drivers_app/pages/trips_page.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  TabController? controller;
  int indexSelected = 0;

  onBarItemClicked(int i) {
    setState(() {
      indexSelected = i;
      controller!.index = indexSelected;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 4, vsync: this);
  }
  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller,
      children: const [
        HomePage(),
        EarningsPage(),
        TripsPage(),
        ProfilePage()
      ],
    ),
      bottomNavigationBar: BottomNavigationBar(items:[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.credit_card),
          label: "Earnings",
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_tree),
          label: "Trips",
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: "Profile",
        ),
      ],
      currentIndex: indexSelected,
      // backgroundColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.blue,
      showSelectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontSize: 14,
      ),
      type: BottomNavigationBarType.fixed,
      onTap: onBarItemClicked,
    ),
    );
  }
}
