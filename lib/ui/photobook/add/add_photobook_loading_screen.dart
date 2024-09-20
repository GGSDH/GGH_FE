import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../routes.dart';
import '../../../themes/color_styles.dart';
import '../../../themes/text_styles.dart';
import '../../../util/toast_util.dart';
import 'add_photobook_bloc.dart';

class AddPhotobookLoadingScreen extends StatefulWidget {

  const AddPhotobookLoadingScreen({ super.key });

  @override
  _AddPhotobookLoadingScreenState createState() => _AddPhotobookLoadingScreenState();
}

class _AddPhotobookLoadingScreenState extends State<AddPhotobookLoadingScreen> {
  final ScrollController _scrollController = ScrollController();
  final assetPaths = [
    "assets/icons/ic_loading_photo_one.svg",
    "assets/icons/ic_loading_photo_two.svg",
    "assets/icons/ic_loading_photo_three.svg",
  ];
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();

    // 자동 스크롤을 위한 Listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 10) {
        // 끝에 도달하면 다시 처음으로 이동
        _scrollController.jumpTo(0);
      }
    });

    _startAutoScroll();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _scrollController.animateTo(
        _scrollController.position.pixels + 300,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<AddPhotobookBloc, AddPhotobookSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is AddPhotobookShowError) {
          ToastUtil.showToast(context, sideEffect.message);
        } else if (sideEffect is AddPhotobookComplete) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(context).go(
              Uri(
                path: "${Routes.photobook.path}/${Routes.photobookCard.path}",
                queryParameters: {
                  "photobookId": sideEffect.photobookId.toString(),
                },
              ).toString(),
            );
          });
        } else if (sideEffect is AddPhotobookNoPhotosFound) {
          _showNoPhotosFoundDialog(context);
        }
      },
      child: BlocBuilder<AddPhotobookBloc, AddPhotobookState>(
        builder: (context, state) {
          return Scaffold(
            body: Material(
              color: Colors.white,
              child: Center(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "소중한 추억이 담긴\n포토북을 생성중이에요",
                        style: TextStyles.title2ExtraLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 100),
                      SvgPicture.asset(
                        "assets/icons/ic_camera.svg",
                        width: 186,
                        height: 137,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 174,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final actualIndex = index % assetPaths.length;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: SvgPicture.asset(
                                assetPaths[actualIndex],
                                width: 131,
                                height: 174,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showNoPhotosFoundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
        Dialog(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/icons/ic_warning_red.svg",
                  width: 40,
                  height: 40
                ),
                const SizedBox(height: 10),
                Text("포토북 생성에 실패했어요 🥲",
                    style: TextStyles.titleLarge
                        .copyWith(color: ColorStyles.gray800)),
                const SizedBox(height: 8),
                Text(
                  "해당 기간의 경기 여행 정보가 없어요.\nGPS를 끈 경우, 사진의 위치 정보가\n수집되지 않아요.",
                  style: TextStyles.bodyMedium.copyWith(color: ColorStyles.gray600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            GoRouter.of(context).go(Routes.photobook.path);
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
                            Navigator.of(context).pop();
                            GoRouter.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: ColorStyles.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "다시하기",
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
        ),
    );
  }
}