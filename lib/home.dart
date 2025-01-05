import 'package:flutter/material.dart';
import 'dart:async';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(1);
    final pageController = usePageController(initialPage: tabIndex.value);

    late Stream<StepCount> stepCountStream;
    late Stream<PedestrianStatus> pedestrianStatusStream;

    final status = useState('?');
    final steps = useState<String?>('0');

    void onStepCount(StepCount event) {
      print(event);
      steps.value = event.steps.toString();
    }

    void onPedestrianStatusChanged(PedestrianStatus event) {
      print(event);
      status.value = event.status;
    }

    void onPedestrianStatusError(error) {
      print('onPedestrianStatusError: $error');

      status.value = 'N/A';

      print(status);
    }

    void onStepCountError(error) {
      print('onStepCountError: $error');

      steps.value = '0';
    }

    Future<bool> checkActivityRecognitionPermission() async {
      bool granted = await Permission.activityRecognition.isGranted;

      if (!granted) {
        granted = await Permission.activityRecognition.request() ==
            PermissionStatus.granted;
      }

      return granted;
    }

    Future<void> initPlatformState() async {
      bool granted = await checkActivityRecognitionPermission();
      if (!granted) {
        // tell user, the app will not work
      }

      pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      (pedestrianStatusStream.listen(onPedestrianStatusChanged))
          .onError(onPedestrianStatusError);

      stepCountStream = Pedometer.stepCountStream;
      stepCountStream.listen(onStepCount).onError(onStepCountError);
    }

    useEffect(() {
      initPlatformState();
      return null;
    }, []);

    var goal = 10000;
    var percent = int.parse(steps.value ?? "0") / goal;
    var percentSafe = percent.clamp(0.0, 1.0);
    var percentDisplay = percentSafe * 100;

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
          Text("Coins", style: TextStyle(color: Colors.white)),
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
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color.fromARGB(255, 12, 12, 12),
            child: Stack(children: [
              Column(
                children: [
                  const Spacer(),
                  Image.asset('assets/images/Purdy - Holding money.png'),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularPercentIndicator(
                            radius: 60.0,
                            lineWidth: 5.0,
                            percent: percentSafe,
                            center: Text(
                                percentDisplay.toStringAsFixed(2) + "%",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: percent == 0.0
                                        ? Colors.grey[600]
                                        : Colors.white)),
                            progressColor: Colors.purple,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 28.0),
                              child: Text(
                                "Steps",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: Text(
                                steps.value ?? '0',
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "STATUS: ${status.value}",
                      style: status.value == 'walking' ||
                              status.value == 'stopped'
                          ? const TextStyle(fontSize: 30, color: Colors.white)
                          : const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  const Spacer(),
                ],
              )
            ]),
          ),
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
