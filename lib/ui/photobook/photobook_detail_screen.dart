import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../component/app/app_action_bar.dart';

class PhotobookDetailScreen extends StatelessWidget {

  PhotobookDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppActionBar(
          onBackPressed: () {
            GoRouter.of(context).pop();
          },
          rightText: '',
          menuItems: const [],
        ),
      ],
    );
  }
}