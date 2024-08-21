import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/component/app/app_file_image.dart';
import 'package:gyeonggi_express/ui/component/app/app_image_plaeholder.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_detail_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/add_photobook_response.dart';
import '../../data/repository/photobook_repository.dart';
import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/app/app_action_bar.dart';

class PhotobookDetailScreen extends StatefulWidget {
  final String photobookId;
  final String selectedDay;

  const PhotobookDetailScreen({
    super.key,
    required this.photobookId,
    required this.selectedDay,
  });

  @override
  _PhotobookDetailScreenState createState() => _PhotobookDetailScreenState();
}

class _PhotobookDetailScreenState extends State<PhotobookDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _dayKeys = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotobookDetailBloc(
        photobookRepository: GetIt.instance<PhotobookRepository>(),
      )..add(PhotobookDetailInitialize(int.parse(widget.photobookId))),
      child: BlocSideEffectListener<PhotobookDetailBloc, PhotobookDetailSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is PhotobookDetailShowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(sideEffect.message)),
            );
          } else if (sideEffect is PhotobookFetchComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Scroll to the selected day after the widget is built
              _scrollToSelectedDay();
            });
          }
        },
        child: BlocBuilder<PhotobookDetailBloc, PhotobookDetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      AppActionBar(
                        rightText: '',
                        onBackPressed: () => GoRouter.of(context).pop(),
                        menuItems: [
                          ActionBarMenuItem(
                              icon: SvgPicture.asset(
                                "assets/icons/ic_map.svg",
                                width: 24,
                                height: 24,
                              ),
                              onPressed: () {
                                GoRouter.of(context).push(
                                    Uri(
                                      path: "${Routes.photobook.path}/${Routes.photobookMap.path}",
                                      queryParameters: {
                                        "photobookId": widget.photobookId,
                                      },
                                    ).toString());
                              })
                        ],
                      ),
                      Column(
                          children: state.photobookDailyPhotoGroups
                              .asMap()
                              .entries
                              .expand((entry) {
                            int index = entry.key;
                            DailyPhotoGroup dailyPhotoGroup = entry.value;
                            // Store GlobalKey for each day item
                            _dayKeys[index] = GlobalKey();

                            return [
                              _dayItem(dailyPhotoGroup, index),
                              ...dailyPhotoGroup.hourlyPhotoGroups.map((hourlyPhotoGroup) {
                                return _hourItem(hourlyPhotoGroup);
                              })
                            ];
                          }).toList())
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _dayItem(
      DailyPhotoGroup dailyPhotoGroup,
      int index,
      ) {
    return Column(
      key: _dayKeys[index], // Assign GlobalKey to each day item
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Text(
                "${dailyPhotoGroup.day}일차",
                style: TextStyles.titleLarge.copyWith(color: ColorStyles.gray900),
              ),
              const SizedBox(width: 8),
              Text(
                dailyPhotoGroup.dateTime,
                style: TextStyles.bodyLarge.copyWith(color: ColorStyles.gray500),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _hourItem(HourlyPhotoGroup hourlyPhotoGroup) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: ColorStyles.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorStyles.primary,
                      width: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 1,
                    color: ColorStyles.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(hourlyPhotoGroup),
                  const SizedBox(height: 8),
                  _buildPhotoLayout(hourlyPhotoGroup),
                  const SizedBox(height: 34),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(HourlyPhotoGroup hourlyPhotoGroup) {
    return Row(
      children: [
        Text(
          hourlyPhotoGroup.localizedTime,
          style: TextStyles.titleMedium.copyWith(
            color: ColorStyles.gray800,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          hourlyPhotoGroup.dominantLocation?.name ?? "",
          style: TextStyles.bodyLarge.copyWith(
            color: ColorStyles.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoLayout(HourlyPhotoGroup hourlyPhotoGroup) {
    final photos = hourlyPhotoGroup.photos;
    final photosCount = photos.length;

    return GestureDetector(
      onTap: () => _navigateToPhotoList(photos),  // GestureDetector wraps the entire widget
      child: Builder(
        builder: (context) {
          if (photosCount == 1) {
            return _buildSinglePhoto(photos.first);
          } else if (photosCount == 2) {
            return _buildTwoPhotos(photos[0], photos[1]);
          } else if (photosCount == 3) {
            return _buildThreePhotos(photos);
          } else {
            return _buildMultiplePhotos(photos, photosCount);
          }
        },
      ),
    );
  }

  Widget _buildSinglePhoto(PhotoItem photo) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AppFileImage(
        imageFilePath: photo.path,
        width: double.infinity,
        height: 150,
        placeholder: const AppImagePlaceholder(width: double.infinity, height: 150),
        errorWidget: const AppImagePlaceholder(width: double.infinity, height: 150),
      ),
    );
  }

  Widget _buildTwoPhotos(PhotoItem photo1, PhotoItem photo2) {
    return Row(
      children: [
        Expanded(child: _buildSinglePhoto(photo1)),
        const SizedBox(width: 8),
        Expanded(child: _buildSinglePhoto(photo2)),
      ],
    );
  }

  Widget _buildThreePhotos(List<PhotoItem> photos) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildSinglePhoto(photos[1])),
            const SizedBox(width: 8),
            Expanded(child: _buildSinglePhoto(photos[2])),
          ],
        ),
        const SizedBox(height: 8),
        _buildSinglePhoto(photos[0]),
      ],
    );
  }

  Widget _buildMultiplePhotos(List<PhotoItem> photos, int photosCount) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildSinglePhoto(photos[0])),
                const SizedBox(width: 8),
                Expanded(child: _buildSinglePhoto(photos[1])),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildSinglePhoto(photos[2])),
                const SizedBox(width: 8),
                Expanded(child: _buildSinglePhoto(photos[3])),
              ],
            ),
          ],
        ),
        if (photosCount > 4)
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: ColorStyles.gray900.withOpacity(0.7),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                "+${photosCount - 4}장",
                style: TextStyles.titleXSmall.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _scrollToSelectedDay() {
    final selectedDayIndex = int.parse(widget.selectedDay) - 1;
    final key = _dayKeys[selectedDayIndex];
    if (key != null) {
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(context,
            duration: const Duration(milliseconds: 500), alignment: 0.1);
      }
    }
  }

  void _navigateToPhotoList(List<PhotoItem> photos) {
    final path = Uri(
      path: "${Routes.photobook.path}/${Routes.photobookImageList.path}",
      queryParameters: {
        "filePaths": photos.map((photo) => photo.path).join(','),
      },
    ).toString();

    GoRouter.of(context).push(path);
  }
}
