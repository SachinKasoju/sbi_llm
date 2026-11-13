import 'package:flutter/material.dart';
import 'package:sbi_riverpod_project/utils/global_colors.dart';
import 'package:sbi_riverpod_project/views/home/home_page.dart';
import 'package:sbi_riverpod_project/views/learning/learning_page.dart';
import 'package:sbi_riverpod_project/views/profile/profile_page.dart';
import 'package:sbi_riverpod_project/views/search/search_page.dart';
import 'package:sbi_riverpod_project/widgets/custom_app_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  static final _pages = [const HomePage(), SearchPage(), LearningPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    String? title;
    switch (_index) {
      case 1:
        title = 'Search';
        break;
      case 2:
        title = 'My Learning';
        break;
      case 3:
        title = 'My Profile';
        break;
      default:
        title = null;
    }

    return Scaffold(
      appBar: CommonAppBar(
        title: title,
        showActions: true, // Always show wishlist/cart on main tabs
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.primaryColor.withOpacity(0.05),
        indicatorColor: AppColors.primaryColor,
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home,color: Colors.white,),
              label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search),
              selectedIcon: Icon(Icons.search,color: Colors.white,),
              label: 'Search'),
          NavigationDestination(
              icon: Icon(Icons.play_circle_outline),
              selectedIcon: Icon(Icons.play_circle,color: Colors.white,),
              label: 'Learning'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person,color: Colors.white,),
              label: 'Profile'),
        ],
      ),
    );
  }
}
