import 'package:finalproject_edspertapp/ui/constants/r.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/discussion/chat_page.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/home/home_page.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/profile/profile_page.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);
  static String route = "bottom_page";

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final _pageController = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Image.asset(
          R.assets.icDiscuss,
          width: 30,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ChatPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildButtonNavigationBar(),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          ProfilePage(),
        ],
      ),
    );
  }

  Container _buildButtonNavigationBar() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 20,
          color: Colors.black.withOpacity(0.06),
        )
      ]),
      child: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        selectedIndex = 0;
                        _pageController.animateToPage(selectedIndex,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.bounceInOut);
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            R.assets.icHome,
                            height: 25,
                          ),
                          Text("Home"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Material(
                    child: InkWell(
                      child: Column(
                        children: [
                          Opacity(
                            opacity: 0,
                            child: Image.asset(
                              R.assets.icHome,
                              height: 25,
                            ),
                          ),
                          Text("Diskusi Soal"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        selectedIndex = 1;
                        _pageController.animateToPage(selectedIndex,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            R.assets.icProfile,
                            height: 25,
                          ),
                          Text("Profile"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
