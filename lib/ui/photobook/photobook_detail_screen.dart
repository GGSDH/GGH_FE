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

  Widget _hourItem(
    HourlyPhotoGroup hourlyPhotoGroup,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
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
                )
              ],
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        hourlyPhotoGroup.localizedTime,
                        style: TextStyles.titleMedium.copyWith(
                          color: ColorStyles.gray800
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hourlyPhotoGroup.dominantLocation?.name ?? "알 수 없는 도시",
                        style: TextStyles.bodyLarge.copyWith(
                          color: ColorStyles.gray500
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: hourlyPhotoGroup.photos.map((photo) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AppFileImage(
                              imageFilePath: photo.path,
                              width: 150,
                              height: 150,
                              placeholder: const AppImagePlaceholder(width: 150, height: 150),
                              errorWidget: const AppImagePlaceholder(width: 150, height: 150)
                            )
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 34)
                ],
              ),
            )
          ],
        )
      )
    );
  }

  String formatIso8601ToKoreanTime(String iso8601String) {
    try {
      DateTime dateTime = DateTime.parse(iso8601String);
      String period = DateFormat('a', 'ko').format(dateTime); // 'a' will give AM/PM in Korean
      String hour = DateFormat('h', 'ko').format(dateTime);   // 'h' will give the hour in 12-hour format

      // Convert AM/PM to Korean equivalent
      if (period == 'AM') {
        period = '오전';
      } else {
        period = '오후';
      }

      return '$period $hour시';
    } catch (e) {
      return '알 수 없음';
    }
  }
}