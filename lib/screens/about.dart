import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class About extends HookConsumerWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(255, 12, 12, 12),
    );
  }
}
