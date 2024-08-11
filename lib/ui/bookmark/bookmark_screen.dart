import 'package:flutter/material.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: const Text('You have no bookmarks yet.'),
      ),
    );
  }
}