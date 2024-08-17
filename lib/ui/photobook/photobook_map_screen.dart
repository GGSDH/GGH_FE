import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gyeonggi_express/ui/component/app/app_action_bar.dart';
import 'package:gyeonggi_express/ui/ext/file_path_extension.dart';
import 'package:gyeonggi_express/ui/photobook/photobook_detail_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../constants.dart';
import '../../data/repository/photobook_repository.dart';
import '../../themes/color_styles.dart';
import '../component/app/app_image_plaeholder.dart';

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
                child: Column(
                  children: [
                    AppActionBar(
                      rightText: '',
                      onBackPressed: () => GoRouter.of(context).pop(),
                      menuItems: const [],
                    ),
                    Expanded(
                      child: _MapSection(
                        mapControllerCompleter: _mapControllerCompleter,
                        photobookDetailCards: state.photobookDetailCards,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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

        await _addMarkersAndPath(controller, context);
      },
    );
  }

  Future<void> _addMarkersAndPath(
      NaverMapController controller,
      BuildContext context,
      ) async {
    List<NLatLng> pathCoords = [];

    for (var photobook in photobookDetailCards) {
      if (photobook.location?.lat != null && photobook.location?.lon != null) {
        final currentLocation = NLatLng(photobook.location!.lat, photobook.location!.lon);
        pathCoords.add(currentLocation);

        try {
          final overlayImage = await _createOverlayImage(photobook, context);
          final photobookMarker = NMarker(
            id: photobook.id,
            position: currentLocation,
            icon: overlayImage,
            size: const Size(48, 48),
          );
          controller.addOverlay(photobookMarker);

          final circleMarker = _createCircleMarker(photobook.id, currentLocation);
          controller.addOverlay(circleMarker);
        } catch (e) {
          final errorMarker = await _createErrorMarker(photobook, currentLocation, context);
          controller.addOverlay(errorMarker);

          final circleMarker = _createCircleMarker(photobook.id, currentLocation);
          controller.addOverlay(circleMarker);
        }
      }
    }

    if (pathCoords.isNotEmpty) {
      final pathOverlay = NPathOverlay(
        id: 'all_locations_path',
        coords: pathCoords,
        width: 8,
        color: ColorStyles.primary,
      );
      controller.addOverlay(pathOverlay);
    }
  }

  Future<NOverlayImage> _createOverlayImage(PhotobookDetailCard photobook, BuildContext context) async {
    final filePath = await photobook.filePathUrl.getFilePath();
    final imageFile = File(filePath);

    if (await imageFile.exists()) {
      return NOverlayImage.fromFile(imageFile);
    } else {
      return await NOverlayImage.fromWidget(
        context: context,
        widget: const AppImagePlaceholder(width: 48, height: 48),
        size: const Size(48, 48),
      );
    }
  }

  NCircleOverlay _createCircleMarker(String id, NLatLng location) {
    return NCircleOverlay(
      id: '${id}_circle',
      center: location,
      radius: 100,
      color: ColorStyles.primary.withOpacity(0.5),
      outlineWidth: 3,
      outlineColor: Colors.white,
    )..setGlobalZIndex(300000);
  }

  Future<NMarker> _createErrorMarker(PhotobookDetailCard photobook, NLatLng currentLocation, BuildContext context) async {
    final errorIcon = await NOverlayImage.fromWidget(
      context: context,
      widget: const AppImagePlaceholder(width: 48, height: 48),
      size: const Size(48, 48),
    );

    return NMarker(
      id: photobook.id,
      position: currentLocation,
      icon: errorIcon,
    );
  }
}
