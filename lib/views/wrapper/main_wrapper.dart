import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int selectedIndex = 0;

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.orange.shade900,
        onButtonPressed: (index) {
          setState(() {
            selectedIndex = index;
          });
          _goBranch(selectedIndex);
        },
        iconSize: 30,
        activeColor: Colors.white,
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            icon: Icons.home, // Home icon
            title: 'Home',
          ),
          BarItem(
            icon: Icons.group, // Community icon
            title: 'Community',
          ),
          BarItem(
            icon: Icons.search, // Search icon
            title: 'Search',
          ),
          BarItem(
            icon: Icons.share, // Share icon
            title: 'Share',
          ),
        ],
      ),
    );
  }
}
