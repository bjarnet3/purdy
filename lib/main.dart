import 'package:flutter/material.dart';
import 'dart:async';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
      home: const MyHomePage(title: 'Purple Andy'),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(1);
    final pageController = usePageController(initialPage: tabIndex.value);
    final status = useState('?');
    final stepCount = useState('?');

    useEffect(() {
      Future<void> initPlatformState() async {
        bool granted = await Permission.activityRecognition.isGranted;

        if (!granted) {
          granted = await Permission.activityRecognition.request() ==
              PermissionStatus.granted;
        }

        if (!granted) {
          // tell user, the app will not work
          return;
        }

        Pedometer.pedestrianStatusStream.listen((event) {
          status.value = event.status;
        }).onError((error) {
          status.value = 'Pedestrian Status not available';
        });

        Pedometer.stepCountStream.listen((event) {
          stepCount.value = event.steps.toString();
        }).onError((error) {
          stepCount.value = 'Step Count not available';
        });
      }

      initPlatformState();
      return null;
    }, []);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.attach_money_rounded, color: Colors.white),
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.info, color: Colors.white),
        ],
        inactiveIcons: const [
          Text("Coins", style: TextStyle(color: Colors.white)),
          Text("Home", style: TextStyle(color: Colors.white)),
          Text("About", style: TextStyle(color: Colors.white)),
        ],
        color: Colors.purple,
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
          Container(
            width: double.infinity,
            height: 500,
            color: Colors.black,
            child: Column(
              children: [
                const Spacer(),
                Text(
                  "STATUS: ${status.value}",
                  style: status.value == 'walking' || status.value == 'stopped'
                      ? const TextStyle(fontSize: 30, color: Colors.white)
                      : const TextStyle(fontSize: 20, color: Colors.white),
                ),
                Container(
                  height: 20,
                ),
                Text(
                  "STEPS:   ${stepCount.value}",
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
                const Spacer(),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
