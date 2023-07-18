import 'package:flutter/material.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/screens/close_products.dart';
import 'package:sharefood/screens/cart.dart';
import 'package:sharefood/screens/profile_screen.dart';
import 'package:sharefood/widgets/custom_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> pages = [
    CartScreen(storage: CartStorage()),
    const CloseProductsList(),
    const ProfileScreen(),
  ];

  int _currentIndex = 1;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC4DFCB),
      body: pages[_currentIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }


  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 55,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTabItem(
            isSelected: _currentIndex == 0,
            iconData: Icons.shopping_cart_outlined,
            onTap: () {
              setState(() {
                _currentIndex = 0;
              });
            },
          ),
          CustomTabItem(
            isSelected: _currentIndex == 1,
            iconData: Icons.home_outlined,
            onTap: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
          CustomTabItem(
            isSelected: _currentIndex == 2,
            iconData: Icons.settings_outlined,
            onTap: () {
              setState(() {
                _currentIndex = 2;
              });
            },
          ),
        ],
      ),
    );
  }
}

