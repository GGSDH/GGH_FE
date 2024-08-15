import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../constants.dart';
import '../../data/models/response/photobook_list_response.dart';
import '../../data/repository/photobook_repository.dart';
import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../component/photobook/photobook_list_item.dart';


class PhotobookScreen extends StatefulWidget {
  const PhotobookScreen({super.key});

  @override
  _PhotobookScreenState createState() => _PhotobookScreenState();
}

class _PhotobookScreenState extends State<PhotobookScreen> with RouteAware {
  final Completer<NaverMapController> _mapControllerCompleter = Completer<NaverMapController>();

  void _showBottomSheet(List<Photobook> photobooks) {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.8,
            snap: true,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: photobooks.length,
                  itemBuilder: (context, index) {
                    final photobook = photobooks[index];
                    return PhotobookListItem(
                      title: photobook.title,
                      imageFilePath: photobook.photo,
                      startDate: photobook.startDate,
                      endDate: photobook.endDate,
                      location: photobook.location,
                      onTap: () {
                        GoRouter.of(context).push("${Routes.photobook.path}/${Routes.photobookDetail.path}");
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotobookBloc(
        photobookRepository: GetIt.instance.get<PhotobookRepository>(),
      )..add(PhotobookInitialize()),
      child: BlocSideEffectListener<PhotobookBloc, PhotobookSideEffect>(
        listener: (context, sideEffect) {
          if (sideEffect is PhotobookShowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(sideEffect.message),
              ),
            );
          } else if (sideEffect is PhotobookShowBottomSheet) {
            _showBottomSheet(sideEffect.photobooks);
          }
        },
        child: BlocBuilder<PhotobookBloc, PhotobookState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Material(
                color: Colors.white,
                child: DefaultTabController(
                  length: 2,
                  child: SafeArea(
                    child: Stack(
                        children: [
                          Column(
                            children: [
                              const _TabBarSection(),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    _PhotobookSection(
                                      mapControllerCompleter: _mapControllerCompleter,
                                      onAddPhotobook: () {
                                        GoRouter.of(context).go("${Routes.photobook.path}/${Routes.addPhotobook.path}");
                                      },
                                      showPhotobookList: () => _showBottomSheet(state.photobooks),
                                    ),
                                    _PhotoTicketSection(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ]
                    ),
                  ),
                ),
              );
            }
          }
        ),
      ),
    );
  }
}

class _TabBarSection extends StatelessWidget {
  const _TabBarSection();

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicator: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorStyles.gray900,
            width: 1,
          ),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        Tab(
          child: Text(
            "포토북",
            style: TextStyles.titleLarge.copyWith(
              color: ColorStyles.gray900,
            ),
          ),
        ),
        Tab(
          child: Text(
            "포토티켓",
            style: TextStyles.titleLarge.copyWith(
              color: ColorStyles.gray900,
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotobookSection extends StatelessWidget {
  const _PhotobookSection({
    required this.mapControllerCompleter,
    required this.onAddPhotobook,
    required this.showPhotobookList,
  });

  final Completer<NaverMapController> mapControllerCompleter;
  final VoidCallback onAddPhotobook;
  final VoidCallback showPhotobookList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NaverMap(
          options: const NaverMapViewOptions(
            initialCameraPosition: Constants.DEFAULT_CAMERA_POSITION,
            indoorEnable: true,
            locationButtonEnable: false,
            consumeSymbolTapEvents: false,
            rotationGesturesEnable: true,
            scrollGesturesEnable: true,
            zoomGesturesEnable: true,
          ),
          onMapReady: (controller) {
            mapControllerCompleter.complete(controller);
          },
          forceGesture: true,
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: GestureDetector(
            onTap: onAddPhotobook,
            child: SvgPicture.asset(
              "assets/icons/ic_add_photo.svg",
              width: 52,
              height: 52,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: showPhotobookList,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorStyles.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "목록 열기",
                  style: TextStyles.titleSmall.copyWith(
                    color: ColorStyles.grayWhite,
                  ),
                ),
              ),
            ),
          )
        ),
      ]
    );
  }
}

class _PhotoTicketSection extends StatelessWidget {
  _PhotoTicketSection();

  final PageController _controller = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: -100,
          child: SvgPicture.asset(
            "assets/icons/ic_photo_ticket_illust.svg",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -28),
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: PageView.builder(
                controller: _controller,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: PhotoTicketItem(
                      day: index + 1,
                      date: "8월 ${index + 1}일",
                      title: "너무 신나는 경기행 해커톤",
                      location: "각자의 집",
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ]
    );
  }
}

class PhotoTicketItem extends StatelessWidget {

  const PhotoTicketItem({
    required this.day,
    required this.date,
    required this.title,
    required this.location,
  });

  final int day;
  final String date;
  final String title;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10), // Add padding to avoid clipping
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: ColorStyles.gray300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: ColorStyles.gray300.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(6, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Day $day",
                          style: const TextStyle(
                            color: ColorStyles.gray900,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          date,
                          style: TextStyles.titleMedium.copyWith(
                            color: ColorStyles.gray500,
                          )
                        )
                      ]
                    ),
                    const SizedBox(height: 15),

                    Expanded(
                      child: Image.asset(
                        "assets/images/img_dummy_place.png",
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      title,
                      style: TextStyles.titleSmall.copyWith(
                        color: ColorStyles.gray900,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ic_map_pin.svg",
                          width: 14,
                          height: 14,
                          colorFilter: const ColorFilter.mode(
                            ColorStyles.gray600,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyles.bodyMedium.copyWith(
                            color: ColorStyles.gray800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 7,
            child: Center(
              child: CustomPaint(
                size: const Size(25, 40),
                painter: OffsetRectanglePainter(
                  color: ColorStyles.primary
                )
              ),
            ),
          )
        ]
      ),
    );
  }
}

class OffsetRectanglePainter extends CustomPainter {
  OffsetRectanglePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorStyles.primary
      ..style = PaintingStyle.fill;

    const radius = Radius.circular(4);  // Set radius to 4

    final path = Path()
      ..moveTo(0 + radius.x, 0) // Top left corner
      ..lineTo(size.width - radius.x, 0) // Top right corner
      ..arcToPoint(
        Offset(size.width, radius.y),
        radius: radius,
        clockwise: true,
      )
      ..lineTo(size.width + 7, size.height - radius.y) // Bottom right side
      ..arcToPoint(
        Offset(size.width + 7 - radius.x, size.height),
        radius: radius,
        clockwise: true,
      )
      ..lineTo(7 + radius.x, size.height) // Bottom left side
      ..arcToPoint(
        Offset(7, size.height - radius.y),
        radius: radius,
        clockwise: true,
      )
      ..lineTo(0, radius.y) // Left side
      ..arcToPoint(
        Offset(0 + radius.x, 0),
        radius: radius,
        clockwise: true,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}