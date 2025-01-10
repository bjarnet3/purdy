import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Steps extends HookConsumerWidget {
  const Steps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late Stream<StepCount> stepCountStream;
    late Stream<PedestrianStatus> pedestrianStatusStream;

    final status = useState('?');
    final steps = useState<String?>('0');

    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

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

    var goal = 5100;
    var percent = (int.parse(steps.value ?? "0")) / goal;
    var percentSafe = percent.clamp(0.0, 1.0);
    var percentDisplay = percentSafe * 100;

    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color.fromARGB(255, 12, 12, 12),
      child: Stack(children: [
        Column(
          children: [
            Container(
              height: 15,
            ),
            Image.asset('assets/images/Purdy - Holding money.png',
                height: screenHeight - 290),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 28.0),
                        child: Text(
                          "Steps",
                          style: TextStyle(fontSize: 20, color: Colors.white),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 5.0,
                      percent: percentSafe,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 2,
                          ),
                          status.value == 'walking'
                              ? const Text("Walking",
                                  style: TextStyle(
                                      fontSize: 11.0, color: Colors.white))
                              : Text("Stopped",
                                  style: TextStyle(
                                      fontSize: 11.0, color: Colors.grey[600])),
                          Container(
                            height: 2,
                          ),
                          Text("${percentDisplay.toStringAsFixed(0)} %",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: percent == 0.0
                                      ? Colors.grey[600]
                                      : Colors.white)),
                        ],
                      ),
                      // backgroundColor: Colors.grey[600] ?? Colors.grey,
                      progressColor: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            //   child: Text(
            //     "STATUS: ${status.value}",
            //     style: status.value == 'walking' || status.value == 'stopped'
            //         ? const TextStyle(fontSize: 30, color: Colors.white)
            //         : const TextStyle(fontSize: 20, color: Colors.white),
            //   ),
            // ),
            const Spacer(),
          ],
        )
      ]),
    );
  }
}
