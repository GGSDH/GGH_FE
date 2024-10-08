import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_detail_bloc.dart';
import 'package:intl/intl.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../../util/toast_util.dart';
import '../component/app/app_file_image.dart';
import '../component/app/app_image_plaeholder.dart';

class PhotobookCardScreen extends StatefulWidget {
  final String photobookId;

  const PhotobookCardScreen({
    super.key,
    required this.photobookId,
  });

  @override
  _PhotobookCardScreenState createState() => _PhotobookCardScreenState();
}

class _PhotobookCardScreenState extends State<PhotobookCardScreen> {
  int currentPage = 0;
  int pageCount = 3;
  late double baseCardWidth;
  late double baseCardHeight;
  double scaleFactor = 0.9; // 각 페이지가 멀어질수록 크기 줄어드는 비율
  double visiblePartWidth = 20.0; // 겹치지 않는 부분의 너비
  double swipeOffset = 0.0;
  bool isSwiping = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    baseCardWidth = screenWidth * 0.9 - 40;
    baseCardHeight = baseCardWidth * 1.4;

    return BlocSideEffectListener<PhotobookDetailBloc, PhotobookDetailSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is PhotobookDetailShowError) {
          ToastUtil.showToast(context, sideEffect.message);
        } else if (sideEffect is PhotobookDeleteComplete) {
          GoRouter.of(context).pop(true);
        }
      },
      child: BlocBuilder<PhotobookDetailBloc, PhotobookDetailState>(
        builder: (context, state) {
          pageCount = state.photobookDetailCards.length;

          if (state.isLoading) {
            const Material(
              color: Colors.white,
              child: SafeArea(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          return Material(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  AppActionBar(
                    onBackPressed: () {
                      GoRouter.of(context).go(Routes.photobook.path);
                    },
                    menuItems: [
                      ActionBarMenuItem(
                        icon: SvgPicture.asset(
                          "assets/icons/ic_trash.svg",
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          _showDeleteDialog(
                            context,
                            () {
                              context.read<PhotobookDetailBloc>().add(
                                PhotobookDelete(int.parse(widget.photobookId)),
                              );
                            }
                          );
                        }
                      )
                    ],
                  ),
                  const SizedBox(height: 4),

                  state.dominantLocationCity != null && state.dominantLocationCity!.isNotEmpty  ?
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorStyles.primary),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      state.dominantLocationCity!,
                      style: TextStyles.bodyMedium.copyWith(
                        color: ColorStyles.primary,
                      ),
                    )
                  ) : const SizedBox(height: 32),

                  const SizedBox(height: 14),
                  Text(
                    state.title,
                    style: TextStyles.title2ExtraLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDates(state.startDate, state.endDate),
                    style: TextStyles.bodyLarge.copyWith(
                      color: ColorStyles.gray500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: baseCardWidth + 40,
                        height: baseCardHeight,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                for (int i = pageCount - 1; i >= currentPage; i--)
                                  _buildCard(i, state.photobookDetailCards[i]), // 현재 페이지부터 페이지들을 역순으로 쌓음
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildCard(int index, PhotobookDetailCard card) {
    return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        left: calculateLeftOffset(index),
        width: calculateCardWidth(index),
        height: calculateCardHeight(index),
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              isSwiping = true;
              swipeOffset += details.delta.dx; // 스와이프 방향으로 페이지 이동
            });
          },
          onHorizontalDragEnd: (details) => _onHorizontalDragEnd(details),
          child: (currentPage - index).abs() < 3 ?
            InkWell(
              onTap: () {
                GoRouter.of(context).push(
                  Uri(
                      path: "${Routes.photobook.path}/${Routes.photobookDetail.path}",
                      queryParameters: {
                        "photobookId": widget.photobookId,
                        "selectedDay": "${currentPage + 1}"
                      }
                  ).toString(),
                );
              },
              child: Page(
                day: index + 1,
                imageUrl: card.filePathUrl,
                dateTime: card.date,
                name: card.title,
                location: card.location?.city ?? "알 수 없는 도시",
              )
            ):
            const SizedBox(),
          )
    );
  }

  double calculateLeftOffset(int index) {
    if (index == currentPage) {
      return (pageCount == 1)
          ? 20
          : (pageCount == 2)
          ? 10
          : 0;
    }

    double offsetFromCenter = (index - currentPage).toDouble();
    double cumulativeWidth = (pageCount == 1)
        ? 20
        : (pageCount == 2)
        ? 10
        : 0;

    if (index > currentPage) {
      // 현재 페이지보다 오른쪽에 있는 페이지들에 대해 cumulativeWidth를 계산
      for (int i = currentPage; i < index; i++) {
        cumulativeWidth += calculateCardWidth(i) * (1 - scaleFactor);
      }
    } else {
      // 현재 페이지보다 왼쪽에 있는 페이지들에 대해 cumulativeWidth를 계산
      for (int i = index; i < currentPage; i++) {
        cumulativeWidth -= calculateCardWidth(i + 1) * (1 - scaleFactor);
      }
    }

    return cumulativeWidth + offsetFromCenter * visiblePartWidth;
  }

  double calculateCardWidth(int index) {
    double scale = 1 - ((index - currentPage).abs() * (1 - scaleFactor));
    return baseCardWidth * scale;
  }

  double calculateCardHeight(int index) {
    double scale = 1 - ((index - currentPage).abs() * (1 - scaleFactor));
    return baseCardHeight * scale;
  }

  double calculateOpacity(int index) {
    double maxOpacityDecrease = 0.5; // 가장 멀리 있는 페이지의 최소 투명도
    int offsetFromCenter = (index - currentPage).abs();

    // 스와이프 중일 때, 전환될 페이지의 opacity를 1로 설정
    if (isSwiping && offsetFromCenter == 1) {
      return 1.0;
    }

    double opacity = 1 - (offsetFromCenter * maxOpacityDecrease);

    if (offsetFromCenter > 2) return 0;
    return opacity.clamp(0.5, 1.0);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! < 0 && currentPage < pageCount - 1) {
      // 오른쪽 -> 왼쪽으로 스와이프 (다음 페이지로 이동)
      setState(() {
        swipeOffset = -MediaQuery.of(context).size.width; // 페이지를 오른쪽으로 이동
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          currentPage++;
          swipeOffset = 0.0; // 초기화
          isSwiping = false;
        });
      });
    } else if (details.primaryVelocity! > 0 && currentPage > 0) {
      // 오른쪽 -> 왼쪽으로 스와이프 (이전 페이지로 이동)
      setState(() {
        currentPage--;
        swipeOffset = -MediaQuery.of(context).size.width; // 페이지를 왼쪽으로 이동
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          swipeOffset = 0.0; // 초기화
          isSwiping = false;
        });
      });
    } else {
      setState(() {
        swipeOffset = 0.0; // 스와이프 취소 시 초기화
      });
    }
  }

  void _showDeleteDialog(
    BuildContext context,
    VoidCallback onDelete
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "정말로 삭제 하시겠습니까?",
                style: TextStyles.titleLarge.copyWith(
                  color: ColorStyles.gray800,
                )
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: ColorStyles.gray100,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "취소",
                          style: TextStyles.titleMedium.copyWith(
                            color: ColorStyles.gray500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                          onDelete();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: ColorStyles.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "삭제",
                          style: TextStyles.titleMedium.copyWith(
                            color: ColorStyles.grayWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}

class Page extends StatelessWidget {
  final int day;
  final String imageUrl;
  final String dateTime;
  final String name;
  final String location;

  const Page({
    super.key,
    required this.day,
    required this.imageUrl,
    required this.dateTime,
    required this.name,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          AppFileImage(
            width: double.infinity,
            height: double.infinity,
            imageFilePath: imageUrl,
            placeholder: const AppImagePlaceholder(
                width: double.infinity, height: double.infinity),
            errorWidget: const AppImagePlaceholder(
                width: double.infinity, height: double.infinity),
          ),
          Container(
            color: Colors.black.withOpacity(0.08),
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAY$day',
                  style: TextStyles.headlineLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatIso8601String(dateTime),
                  style: TextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
                const Spacer(),
                Text(
                  name,
                  style: TextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/ic_map_pin.svg",
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      location,
                      style: TextStyles.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String formatDates(String startDate, String endDate) {
  try {
    DateTime startDateTime = DateTime.parse(startDate);
    DateTime endDateTime = DateTime.parse(endDate);

    final dateFormat = DateFormat('yy. MM. dd');

    final formattedStartDate = dateFormat.format(startDateTime);
    final formattedEndDate = dateFormat.format(endDateTime);

    return '$formattedStartDate ~ $formattedEndDate';
  } catch (e) {
    return '';
  }
}


String formatIso8601String(String iso8601String) {
  DateTime dateTime = DateTime.parse(iso8601String);

  DateFormat formatter = DateFormat('yy. MM. dd');
  return formatter.format(dateTime);
}