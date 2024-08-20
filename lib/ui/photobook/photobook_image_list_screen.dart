import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/ui/component/app/app_file_image.dart';
import 'package:gyeonggi_express/ui/component/app/app_image_plaeholder.dart';

import '../component/app/app_action_bar.dart';

class PhotobookImageListScreen extends StatelessWidget {
  final List<String> filePaths;

  const PhotobookImageListScreen({
    super.key,
    required this.filePaths,
  });

  @override
  Widget build(BuildContext context) {
    print('filePaths: $filePaths');

    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            AppActionBar(
              title: '전체 보기',
              onBackPressed: () => GoRouter.of(context).pop(),
              rightText: '',
              menuItems: const [],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: filePaths.length,
                itemBuilder: (context, index) {
                  return AppFileImage(
                    imageFilePath: filePaths[index],
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: const AppImagePlaceholder(width: double.infinity, height: double.infinity),
                    errorWidget: const AppImagePlaceholder(width: double.infinity, height: double.infinity)
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}