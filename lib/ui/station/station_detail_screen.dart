import 'package:flutter/material.dart';
import 'package:gyeonggi_express/ui/component/app_action_bar.dart';

class StationDetailScreen extends StatelessWidget {
  const StationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        AppActionBar(rightText: "", onBackPressed: () => {}, menuItems: [
          ActionBarMenuItem(
              icon: const Icon(Icons.favorite),
              onPressed: () => print("Favorite")),
          ActionBarMenuItem(
              icon: const Icon(Icons.share), onPressed: () => print("Share")),
        ])
      ]),
    );
  }
}
