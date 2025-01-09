import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime now = DateTime.now();
    // Start of the week - Monday
    DateTime fromDate = now.subtract(Duration(days: now.weekday - 1));
    // End of the week - Sunday
    DateTime toDate =
        now.add(Duration(days: DateTime.daysPerWeek - now.weekday));

    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(255, 12, 12, 12),
      child: const Column(
        children: <Widget>[
          Text(
            'Week of',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Steps',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Distance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Calories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
