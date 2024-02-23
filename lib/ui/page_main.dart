import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wanandroid_flutter/ui/page_search.dart';
import 'package:wanandroid_flutter/ui/tabPage/page_home.dart';
import 'package:wanandroid_flutter/ui/tabPage/page_mine.dart';
import 'package:wanandroid_flutter/ui/tabPage/page_plaza.dart';
import 'package:wanandroid_flutter/ui/tabPage/page_project.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _MainPageState();

}

class _MainPageState extends State<MainPage>{
  int _selectedItemIndex = 0;
  String _currentTitle = "首页";
  final PageController _pageController = PageController(initialPage: 0);
  final List<String> _titles = ["首页", "项目", "广场", "我的"];
  final List<Widget> _navIcons = [
    const Icon(Icons.home),
    const Icon(Icons.ac_unit),
    const Icon(Icons.animation),
    const Icon(Icons.verified_user_rounded)
  ];

  final List<Widget> _pages = [
    const HomePage(),
    const ProjectPage(),
    const PlazaPage(),
    const MinePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(_currentTitle, style: const TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: '搜索',
            onPressed: () {
              Get.to(() => const SearchPage());
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        iconSize: 24,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: _generateBottomNavList(),
        currentIndex: _selectedItemIndex,
        onTap:(netIndex) => _onNavItemTapped(netIndex),
      ),
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _pages[index];
        },
        onPageChanged:(index) => _onPageChanged(index),
        controller: _pageController,
      ),
    );
  }

  List<BottomNavigationBarItem> _generateBottomNavList() {
    return List.generate(_titles.length, (index) {
      return BottomNavigationBarItem(
          icon: _navIcons[index], label: _titles[index]);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedItemIndex = index;
      _currentTitle = _titles[index];
    });
  }

  void _onNavItemTapped(int index) {
    // _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.ease);
    _pageController.jumpToPage(index);
  }
}