import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/data/repository/photobook_repository.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../routes.dart';
import '../../../themes/text_styles.dart';
import 'add_photobook_bloc.dart';

class AddPhotobookLoadingScreen extends StatefulWidget {
  final String startDate;
  final String endDate;
  final String title;

  const AddPhotobookLoadingScreen({
    required this.startDate,
    required this.endDate,
    required this.title,
    super.key
  });

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

    log("startDate: ${widget.startDate}, endDate: ${widget.endDate}");

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
    return BlocProvider(
      create: (context) => AddPhotobookBloc(
        photobookRepository: GetIt.instance<PhotobookRepository>(),
      )..add(
        AddPhotobookUpload(
          title: widget.title,
          startDate: DateTime.parse(widget.startDate),
          endDate: DateTime.parse(widget.endDate),
        ),
      ),
      child: BlocSideEffectListener<AddPhotobookBloc, AddPhotobookSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is AddPhotobookShowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(sideEffect.message),
              ),
            );
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
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
      ),
    );
  }
}