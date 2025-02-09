import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:purdy/screens/steps.dart';
import 'package:purdy/screens/home.dart';
import 'package:purdy/screens/about.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

Future<void> main() async {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'Purple Andy'),
    );
  }
}

class MainPage extends HookConsumerWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(1);
    final pageController = usePageController(initialPage: tabIndex.value);
    PermissionStatus perm = PermissionStatus.provisional;
    const double themeBorderRadius = 8.0; // Define the themeBorderRadius

    useEffect(() {
      () async {
        perm = Platform.isAndroid
            ? await Permission.activityRecognition.request()
            : await Permission.sensors.request();
        print('perm: $perm');
      }();
      return () {};
    }, []);

    if (perm.isDenied || perm.isPermanentlyDenied || perm.isRestricted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You need to approve the permissions to use the pedometer',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeBorderRadius),
          ),
          // Open the system settings to allow the permissions
          action: SnackBarAction(
            label: 'Settings',
            textColor: Theme.of(context).colorScheme.onError,
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    } else {
      // Call the functions your need to read stepCount
    }

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
        children: const [
          Steps(),
          Home(),
          About(),
        ],
      ),
    );
  }
}
