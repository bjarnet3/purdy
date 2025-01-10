import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(255, 12, 12, 12),
      child: CustomScrollView(
        slivers: <Widget>[
          // SliverAppBar(
          //   title: Text('Home'),
          //   floating: true,
          //   expandedHeight: 200,
          //   flexibleSpace: Container(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: <Color>[
          //           Color.fromARGB(255, 12, 12, 12),
          //           Color.fromARGB(255, 12, 12, 12),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: <Widget>[
                      Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Welcome to the home screen!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
