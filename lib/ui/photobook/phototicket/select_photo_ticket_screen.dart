import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/component/photo_ticket_item.dart';
import 'package:gyeonggi_express/ui/photobook/phototicket/select_photo_ticket_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../routes.dart';
import '../../../themes/color_styles.dart';
import '../../../themes/text_styles.dart';

class SelectPhotoTicketScreen extends StatefulWidget {
  const SelectPhotoTicketScreen({super.key});

  @override
  _SelectPhotoTicketScreenState createState() => _SelectPhotoTicketScreenState();
}

class _SelectPhotoTicketScreenState extends State<SelectPhotoTicketScreen> {
  Timer? _timer;

  void _startAutoChangeIndex(BuildContext context) {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      context.read<SelectPhotoTicketBloc>().add(SelectPhotoTicketIndexChanged());
    });
  }

  void _stopAutoChangeIndex() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocSideEffectListener<SelectPhotoTicketBloc, SelectPhotoTicketSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is SelectPhotoTicketShowError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(sideEffect.message)),
          );
        }
      },
      child: BlocBuilder<SelectPhotoTicketBloc, SelectPhotoTicketState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            body: Material(
              color: Colors.white,
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white,
                              ColorStyles.primaryLight,
                            ],
                          ),
                        ),
                      )
                    ),
                    Positioned(
                      bottom: -100,
                      child: SvgPicture.asset(
                        "assets/icons/ic_photo_ticket_illust.svg",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AppActionBar(
                        onBackPressed: () => GoRouter.of(context).pop(),
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            state.isChoosing
                                ? "손을 떼면\n여행자의 소중한 순간으로 선택돼요"
                                : "사진을 꾹 눌러\n여행의 소중한 순간을 포착하세요",
                            style: TextStyles.title2ExtraLarge.copyWith(
                              color: ColorStyles.gray900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 54),
                          GestureDetector(
                            onLongPress: () {
                              context.read<SelectPhotoTicketBloc>().add(SelectPhotoTicketPressStart());
                              _startAutoChangeIndex(context);
                            },
                            onLongPressUp: () {
                              context.read<SelectPhotoTicketBloc>().add(SelectPhotoTicketPressEnd());
                              _stopAutoChangeIndex();

                              final path = Uri(
                                path: '${Routes.photobook.path}/${Routes.selectPhotoTicket.path}/${Routes.addPhotoTicket.path}',
                                queryParameters: {
                                  'title': state.title,
                                  'startDate': state.startDate.toString(),
                                  'endDate': state.endDate.toString(),
                                  'location': state.location,
                                  'selectedPhotoPath': state.photos[state.selectedPhotoIndex].path,
                                  'selectedPhotoId': state.photos[state.selectedPhotoIndex].id,
                                },
                              ).toString();

                              GoRouter.of(context).push(path).then((result) {
                                if (result != null) {
                                  GoRouter.of(context).pop(true);
                                }
                              });
                            },
                            child: SizedBox(
                              width: screenWidth * 0.7,
                              child: AspectRatio(
                                aspectRatio: 0.7,
                                child: Stack(
                                  children: state.photos.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    var photo = entry.value;
                                    return AnimatedOpacity(
                                      opacity: index == state.selectedPhotoIndex ? 1.0 : 0.0,
                                      duration: const Duration(milliseconds: 300),
                                      child: PhotoTicketItem(
                                        title: state.title,
                                        filePath: photo.path,
                                        startDate: state.startDate,
                                        endDate: state.endDate,
                                        location: state.location,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
