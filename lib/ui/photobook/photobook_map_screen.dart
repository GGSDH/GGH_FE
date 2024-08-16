import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/component/app/app_file_image.dart';
import 'package:gyeonggi_express/ui/ext/file_path_extension.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_detail_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../constants.dart';
import '../../data/repository/photobook_repository.dart';
import '../component/app/app_image_plaeholder.dart';
import '../component/map/map_marker.dart';

class PhotobookMapScreen extends StatefulWidget {
  final String photobookId;

  const PhotobookMapScreen({
    super.key,
    required this.photobookId,
  });

  @override
  _PhotobookMapScreenState createState() => _PhotobookMapScreenState();
}

class _PhotobookMapScreenState extends State<PhotobookMapScreen> {
  final Completer<NaverMapController> _mapControllerCompleter = Completer<NaverMapController>();

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
              SnackBar(
                content: Text(sideEffect.message),
              ),
            );
          }
        },
        child: BlocBuilder<PhotobookDetailBloc, PhotobookDetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      AppActionBar(
                        rightText: '',
                        onBackPressed: () {
                          GoRouter.of(context).pop();
                        },
                        menuItems: const [],
                      ),
                      Expanded(
                        child: _MapSection(
                            mapControllerCompleter: _mapControllerCompleter,
                            photobookDetailCards: state.photobookDetailCards
                        ),
                      )
                    ],
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

class _MapSection extends StatelessWidget {
  const _MapSection({
    required this.mapControllerCompleter,
    required this.photobookDetailCards,
  });

  final Completer<NaverMapController> mapControllerCompleter;
  final List<PhotobookDetailCard> photobookDetailCards;

  @override
  Widget build(BuildContext context) {
    return NaverMap(
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
        if (!mapControllerCompleter.isCompleted) {
          mapControllerCompleter.complete(controller);
        }

        List<NLatLng> pathCoords = [];

        for (var photobook in photobookDetailCards) {
          if (photobook.location?.lat != null && photobook.location?.lon != null) {
            try {
              // 이미지 파일을 불러오고 NOverlayImage를 비동기적으로 생성
              final overlayImage = await NOverlayImage.fromWidget(
                context: context,
                widget: MapMarker(filePath: photobook.filePathUrl),
                size: const Size(48, 70),
              );

              // NMarker 생성
              final currentLocation = NLatLng(
                  photobook.location!.lat, photobook.location!.lon);

              // 위치를 pathCoords 리스트에 추가
              pathCoords.add(currentLocation);

              final photobookMarker = NMarker(
                id: photobook.id,
                position: currentLocation,
                icon: overlayImage,
              );

              // 마커 추가
              controller.addOverlay(photobookMarker);
            } catch (e) {
              final currentLocation = NLatLng(
                  photobook.location!.lat, photobook.location!.lon);

              pathCoords.add(currentLocation);

              final errorMarker = NMarker(
                id: photobook.id,
                position: currentLocation,
                icon: await NOverlayImage.fromWidget(
                  context: context,
                  widget: MapMarker(filePath: photobook.filePathUrl),
                  size: const Size(48, 70),
                ),
              );

              controller.addOverlay(errorMarker);
            }
          }
        }

        // 경로를 그릴 좌표가 존재하는 경우
        if (pathCoords.isNotEmpty) {
          final pathOverlay = NPathOverlay(
            id: 'all_locations_path',
            coords: pathCoords, // 저장된 모든 LatLng 좌표
            width: 2,
            color: const Color(0xFFF7BC25),
          );

          controller.addOverlay(pathOverlay);
        }
      },
    );
  }
}