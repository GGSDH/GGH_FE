import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/component/app/app_file_image.dart';
import 'package:gyeonggi_express/ui/component/app/app_image_plaeholder.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_detail_bloc.dart';
import 'package:intl/intl.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/add_photobook_response.dart';
import '../../data/repository/photobook_repository.dart';
import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/app/app_action_bar.dart';

class PhotobookDetailScreen extends StatelessWidget {
  final String photobookId;

  const PhotobookDetailScreen({
    super.key,
    required this.photobookId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotobookDetailBloc(
        photobookRepository: GetIt.instance<PhotobookRepository>(),
      )..add(PhotobookDetailInitialize(int.parse(photobookId))),
      child: BlocSideEffectListener<PhotobookDetailBloc, PhotobookDetailSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is PhotobookDetailShowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(sideEffect.message)),
            );
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
                                        "photobookId": photobookId,
                                      },
                                    ).toString()
                                );
                              })
                        ],
                      ),
                      Column(
                          children: state.photobookDailyPhotoGroups
                              .expand((dailyPhotoGroup) {
                            return [
                              _dayItem(dailyPhotoGroup),
                              ...dailyPhotoGroup.hourlyPhotoGroups.map((hourlyPhotoGroup) {
                                return _hourItem(hourlyPhotoGroup);
                              })
                            ];
                          }).toList()
                      )
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
      ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Text(
                "${dailyPhotoGroup.day}일차",
                style: TextStyles.titleLarge.copyWith(
                    color: ColorStyles.gray900
                ),
              ),
              const SizedBox(width: 8),
              Text(
                dailyPhotoGroup.dateTime,
                style: TextStyles.bodyLarge.copyWith(
                    color: ColorStyles.gray500
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _hourItem(HourlyPhotoGroup hourlyPhotoGroup) {
    final photosCount = hourlyPhotoGroup.photos.length;

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

    if (photosCount == 1) {
      return _buildSinglePhoto(photos.first);
    } else if (photosCount == 2) {
      return _buildTwoPhotos(photos[0], photos[1]);
    } else if (photosCount == 3) {
      return _buildThreePhotos(photos);
    } else {
      return _buildMultiplePhotos(photos, photosCount);
    }
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
                Expanded(child: _buildSinglePhoto(photos[3]))
              ],
            ),
          ],
        ),

        (photosCount > 4) ?
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
          ) : const SizedBox(),
      ]
    );
  }
}
