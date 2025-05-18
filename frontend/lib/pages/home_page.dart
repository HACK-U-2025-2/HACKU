import 'package:flutter/material.dart';
import 'package:frontend/widgets/home_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      drawer: const DestinationNavigationDrawer(),
      body: const Placeholder(),
    );
  }
}
