import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/route_extension.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../constants.dart';
import '../../data/models/response/photo_ticket_response.dart';
import '../../data/models/response/photobook_response.dart';
import '../../routes.dart';
import '../../themes/color_styles.dart';
import '../../themes/text_styles.dart';
import '../../util/naver_map_util.dart';
import '../../util/toast_util.dart';
import '../component/app/app_button.dart';
import '../component/photo_ticket_item.dart';
import '../component/photobook/photobook_list_item.dart';


class PhotobookScreen extends StatefulWidget with RouteAware {
  const PhotobookScreen({super.key});

  @override
  _PhotobookScreenState createState() => _PhotobookScreenState();
}

class _PhotobookScreenState extends State<PhotobookScreen> with RouteAware, TickerProviderStateMixin {
  NaverMapController? _mapController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _showBottomSheet(
    List<PhotobookResponse> photobooks,
    Function onLoadPhotobooks,
    VoidCallback onAddPhotobook
  ) {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => GoRouter.of(context).pop(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
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
                child: Stack(
                  children: [
                    ListView.builder(
                      controller: scrollController,
                      itemCount: photobooks.length,
                      itemBuilder: (context, index) {
                        final photobook = photobooks[index];
                        return PhotobookListItem(
                          title: photobook.title,
                          imageFilePath: photobook.mainPhoto?.path ?? '',
                          startDate: photobook.startDate,
                          endDate: photobook.endDate,
                          location: photobook.location?.name ?? '',
                          onTap: () {
                            GoRouter.of(context).push(
                              Uri(
                                  path: "${Routes.photobook.path}/${Routes.photobookCard.path}",
                                  queryParameters: { 'photobookId': "${photobook.id}" }
                              ).toString()
                            ).then((result) {
                              if (result == true) onLoadPhotobooks();
                            });
                          },
                        );
                      },
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
                  ]
                )
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<PhotobookBloc, PhotobookSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is PhotobookShowError) {
          ToastUtil.showToast(context, sideEffect.message, bottomPadding: 0);
        } else if (sideEffect is PhotobookShowBottomSheet) {
          _showBottomSheet(
            sideEffect.photobooks,
            () => context.read<PhotobookBloc>().add(FetchPhotobooks()),
            () => GoRouter.of(context).push("${Routes.photobook.path}/${Routes.addPhotobook.path}")
          );
        }
      },
      child: BlocBuilder<PhotobookBloc, PhotobookState>(
        builder: (context, state) {
          return Scaffold(
            body: Material(
              color: Colors.white,
              child: (state.photobooks.isEmpty && !state.isLoading) ? _buildNoPhotobooksFoundScreen() :
              DefaultTabController(
                length: 2,
                child: SafeArea(
                  child: Stack(
                      children: [
                        Column(
                          children: [
                            _TabBarSection(
                              tabController: _tabController
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildPhotobookSection(
                                    photobooks: state.photobooks,
                                    onAddPhotobook: () {
                                      GoRouter.of(context).push("${Routes.photobook.path}/${Routes.addPhotobook.path}");
                                    },
                                    showPhotobookList: () => {
                                      context.read<PhotobookBloc>().add(FetchPhotobooks()),
                                    },
                                  ),
                                  _PhotoTicketSection(
                                    photobookCount: state.photobooks.length,
                                    photoTickets: state.photoTickets,
                                    tabController: _tabController
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildPhotobookSection({
    required List<PhotobookResponse> photobooks,
    required VoidCallback onAddPhotobook,
    required VoidCallback showPhotobookList,
  }) {
    void addMarkersToMap(List<PhotobookResponse> photobooks) async {
      if (_mapController == null) return;
      NaverMapUtil.addMarkers(_mapController!, photobooks, context);
    }

    if (_mapController != null) {
      addMarkersToMap(photobooks);
    }

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
            onMapReady: (controller) async {
              _mapController = controller;
              addMarkersToMap(photobooks);
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

  Widget _buildNoPhotobooksFoundScreen() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "소중한 추억,\n포토북으로 만들어 보세요!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: ColorStyles.gray900,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                SvgPicture.asset(
                  "assets/icons/img_add_photobook_illust.svg",
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),

          const SizedBox(height: 33),

          Padding(
            padding: const EdgeInsets.all(14),
            child: AppButton(
              text: "포토북 만들기",
              onPressed: () {
                GoRouter.of(context).push("${Routes.photobook.path}/${Routes.addPhotobook.path}/${Routes.addPhotobookSelectPeriod.path}");
              },
              isEnabled: true,
              onIllegalPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBarSection extends StatelessWidget {
  final TabController tabController;

  const _TabBarSection({
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
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

class _PhotoTicketSection extends StatelessWidget {
  final int photobookCount;
  final List<PhotoTicketResponse> photoTickets;
  final TabController tabController;

  _PhotoTicketSection({
    required this.photobookCount,
    required this.photoTickets,
    required this.tabController,
  });

  final PageController _controller = PageController(viewportFraction: 0.8);

  Widget _buildNoPhotoTicketItem(
    BuildContext context
  ) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "여행의 소중한 순간을\n포토티켓에 담아보세요.",
                  style: TextStyles.title2ExtraLarge.copyWith(
                    color: ColorStyles.gray900,
                  ),
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/ic_loading_photo_one.svg",
                      width: 105,
                      height: 141,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset(
                      "assets/icons/ic_loading_photo_two.svg",
                      width: 105,
                      height: 141,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset(
                      "assets/icons/ic_loading_photo_three.svg",
                      width: 105,
                      height: 141,
                      fit: BoxFit.cover,
                    ),
                  ],
                )
              ],
            ),
          )
        ),
        Text(
          "하나의 포토북에 하나의 포토티켓이 발행돼요.",
          style: TextStyles.bodyMedium.copyWith(
            color: ColorStyles.gray600,
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
          child: AppButton(
            text: '바로가기',
            onPressed: () {
              GoRouter.of(context).push("${Routes.photobook.path}/${Routes.addPhotobook.path}");
            }
          ),
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return (photobookCount == 0) ? _buildNoPhotoTicketItem(context) :
    Stack(
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
              aspectRatio: 0.9,
              child: PageView.builder(
                controller: _controller,
                itemCount: (photobookCount == photoTickets.length) ? photoTickets.length : photoTickets.length + 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: (index == photoTickets.length) ?
                      AddPhotoTicketItem(
                        onTap: () {
                          GoRouter.of(context).push("${Routes.photobook.path}/${Routes.selectPhotoTicket.path}").then((result) {
                            if (result == true) {
                              context.read<PhotobookBloc>().add(FetchPhotoTickets());
                              tabController.animateTo(1);
                            }
                          });
                        }
                      ) :
                    PhotoTicketItem(
                      title: photoTickets[index].photobook.title,
                      filePath: photoTickets[index].photo.path,
                      startDate: DateTime.parse(photoTickets[index].photobook.startDate),
                      endDate: DateTime.parse(photoTickets[index].photobook.endDate),
                      location: photoTickets[index].photo.location?.name ?? '',
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

class AddPhotoTicketItem extends StatelessWidget {
  final VoidCallback onTap;

  const AddPhotoTicketItem({
    super.key,
    required this.onTap
  });

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
                            const Text(
                              '',
                              style: TextStyle(
                                color: ColorStyles.grayWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '',
                              style: TextStyles.titleMedium.copyWith(
                                color: ColorStyles.gray500,
                              )
                            )
                          ]
                      ),
                      const SizedBox(height: 15),

                      Expanded(
                        child: GestureDetector(
                          onTap: onTap,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: ColorStyles.gray100,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "포토티켓으로,\n여행의 소중한 순간을 📸",
                                  style: TextStyles.titleMedium.copyWith(
                                    color: ColorStyles.gray700
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: ColorStyles.gray800,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "포토티켓 만들기",
                                    style: TextStyles.titleXSmall.copyWith(
                                      color: ColorStyles.grayWhite
                                    )
                                  )
                                )
                              ],
                            ),
                          ),
                        )
                      ),

                      const SizedBox(height: 15),

                      Text(
                        '',
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
                              ColorStyles.grayWhite,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '',
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