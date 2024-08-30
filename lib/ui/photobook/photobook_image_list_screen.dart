import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/ui/component/app/app_file_image.dart';
import 'package:gyeonggi_express/ui/component/app/app_image_plaeholder.dart';

import '../../themes/text_styles.dart';
import '../component/app/app_action_bar.dart';

class PhotobookImageListScreen extends StatelessWidget {
  final List<String> filePaths;

  const PhotobookImageListScreen({
    super.key,
    required this.filePaths,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            AppActionBar(
              title: '전체 보기',
              onBackPressed: () => GoRouter.of(context).pop(),
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
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                            builder: (BuildContext context) {
                              return PhotoViewPopup(
                                imageUrls: filePaths,
                                initialIndex: index,
                              );
                          })
                      );
                    },
                    child: AppFileImage(
                      imageFilePath: filePaths[index],
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: const AppImagePlaceholder(width: double.infinity, height: double.infinity),
                      errorWidget: const AppImagePlaceholder(width: double.infinity, height: double.infinity)
                    ),
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

class PhotoViewPopup extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const PhotoViewPopup({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  _PhotoViewPopupState createState() => _PhotoViewPopupState();
}

class _PhotoViewPopupState extends State<PhotoViewPopup> {
  late PageController _pageController;
  late int _currentIndex;
  late List<Size> _imageSizes;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _imageSizes = List.generate(widget.imageUrls.length, (_) => Size.zero);

    // Preload image sizes
    for (int i = 0; i < widget.imageUrls.length; i++) {
      _getImageSize(widget.imageUrls[i], i);
    }
  }

  Future<void> _getImageSize(String imageUrl, int index) async {
    final file = File(imageUrl);
    if (!file.existsSync()) return;

    final image = Image.file(file);
    final completer = Completer<Size>();

    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        final imageSize = Size(info.image.width.toDouble(), info.image.height.toDouble());
        completer.complete(imageSize);
      }),
    );

    _imageSizes[index] = await completer.future;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 30) / 4;
    final itemHeight = itemWidth * 0.62;

    return Dialog(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            // Main image view using PageView
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: PageView.builder(
                itemCount: widget.imageUrls.length,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final imageSize = _imageSizes[index];
                  final aspectRatio = imageSize.width != 0 ? imageSize.width / imageSize.height : 1.0;
                  final imageHeight = screenWidth / aspectRatio;

                  return Center(
                    child: SizedBox(
                      width: screenWidth,
                      height: imageHeight.isFinite ? imageHeight : 300, // Default to 300 if imageHeight is infinite
                      child: AppFileImage(
                        imageFilePath: widget.imageUrls[index],
                        placeholder: AppImagePlaceholder(width: screenWidth, height: 300),
                        errorWidget: AppImagePlaceholder(width: screenWidth, height: 300),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Top bar with title and close button
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: Colors.black.withOpacity(0.6), // Background for visibility
                child: Stack(
                  children: [
                    // Centered title
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '사진 상세',
                        style: TextStyles.titleLarge.copyWith(color: Colors.white),
                      ),
                    ),

                    // Close button on the left
                    Positioned(
                      left: 0,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: SvgPicture.asset(
                          'assets/icons/ic_close_24px.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Thumbnail list at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: itemHeight,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(widget.imageUrls.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(index);
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: index == _currentIndex ? Colors.white : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: AppFileImage(
                            imageFilePath: widget.imageUrls[index],
                            width: itemWidth,
                            height: itemHeight,
                            placeholder: AppImagePlaceholder(width: itemWidth, height: itemHeight),
                            errorWidget: AppImagePlaceholder(width: itemWidth, height: itemHeight),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
