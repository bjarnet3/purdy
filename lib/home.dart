import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:purdy/steps.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(1);
    final pageController = usePageController(initialPage: tabIndex.value);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color.fromARGB(255, 7, 7, 7),
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.attach_money_rounded, color: Colors.white),
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.info_rounded, color: Colors.white),
        ],
        inactiveIcons: const [
          Text("Steps", style: TextStyle(color: Colors.white)),
          Text("Home", style: TextStyle(color: Colors.white)),
          Text("About", style: TextStyle(color: Colors.white)),
        ],
        color: Colors.deepPurple,
        height: 60,
        circleWidth: 60,
        activeIndex: tabIndex.value,
        onTap: (index) {
          tabIndex.value = index;
          pageController.jumpToPage(tabIndex.value);
        },
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          tabIndex.value = v;
        },
        children: [
          const Steps(),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(255, 12, 12, 12),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(255, 12, 12, 12),
          ),
        ],
      ),
    );
  }
}
