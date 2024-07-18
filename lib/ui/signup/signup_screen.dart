import 'package:flutter/material.dart';
import 'package:gyeonggi_express/ui/signup/component/select_grid.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final List<SelectableGridItemData> _items = [
    SelectableGridItemData(
        id: '1', icon: Icons.directions_run, title: '체험/액티비티'),
    SelectableGridItemData(id: '2', icon: Icons.camera_alt, title: 'SNS 핫플'),
    SelectableGridItemData(id: '3', icon: Icons.spa, title: '푸른 자연'),
    SelectableGridItemData(
        id: '4', icon: Icons.account_balance, title: '유명 관광지'),
    SelectableGridItemData(id: '5', icon: Icons.local_dining, title: '지역 특색'),
    SelectableGridItemData(id: '6', icon: Icons.mood, title: '문화/예술/역사'),
    SelectableGridItemData(id: '7', icon: Icons.local_dining, title: '맛집 탐방'),
    SelectableGridItemData(id: '8', icon: Icons.wb_sunny, title: '힐링'),
  ];

  @override
  Widget build(BuildContext context) {
    return SelectableGrid(
      items: _items,
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
    );
  }
}
