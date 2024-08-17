import 'package:flutter/material.dart';

import '../../../themes/color_styles.dart';
import '../app/app_file_image.dart';
import '../app/app_image_plaeholder.dart';

class MapMarker extends StatelessWidget {
  final String filePath;

  const MapMarker({
    super.key,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    print(filePath);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AppFileImage(
            imageFilePath: filePath,
            width: 48,
            height: 48,
            placeholder: const AppImagePlaceholder(width: 48, height: 48),
            errorWidget: const AppImagePlaceholder(width: 48, height: 48),
          ),
        ),
        const SizedBox(height: 5),
        const Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
                ),
              ),
            ),
            SizedBox(
              width: 10,
              height: 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: ColorStyles.primary,
                    shape: BoxShape.circle
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}