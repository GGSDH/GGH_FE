import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gyeonggi_express/ui/ext/file_path_extension.dart';
import '../data/models/response/photobook_list_response.dart';
import '../themes/color_styles.dart';
import '../ui/component/app/app_image_plaeholder.dart';
import '../ui/photobook/photobook_detail_bloc.dart';

class NaverMapUtil {
  static Future<void> addMarkersAndPath(
    NaverMapController controller,
    List<PhotobookDetailCard> photobookDetailCards,
    BuildContext context,
  ) async {
    List<NLatLng> pathCoords = [];

    for (var photobook in photobookDetailCards) {
      if (photobook.location?.lat != null && photobook.location?.lon != null) {
        final currentLocation = NLatLng(photobook.location!.lat, photobook.location!.lon);
        pathCoords.add(currentLocation);

        try {
          final overlayImage = await _createOverlayImage(photobook.filePathUrl, context);
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
          final errorMarker = await _createErrorMarker(photobook.id, currentLocation, context);
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

  static Future<void> addMarkers(
    NaverMapController controller,
    List<Photobook> photobooks,
    BuildContext context,
  ) async {
    for (var photobook in photobooks) {
      if (photobook.location?.lat != null && photobook.location?.lon != null) {
        final currentLocation = NLatLng(
          photobook.location!.lat, photobook.location!.lon,
        );

        try {
          final overlayImage = await _createOverlayImage(photobook.photo, context);
          final photobookMarker = NMarker(
            id: "${photobook.id}",
            position: currentLocation,
            icon: overlayImage,
            size: const Size(48, 48),
          );
          controller.addOverlay(photobookMarker);

          final circleMarker = _createCircleMarker("${photobook.id}", currentLocation);
          controller.addOverlay(circleMarker);
        } catch (e) {
          final errorMarker = await _createErrorMarker("${photobook.id}", currentLocation, context);
          controller.addOverlay(errorMarker);

          final circleMarker = _createCircleMarker("${photobook.id}", currentLocation);
          controller.addOverlay(circleMarker);
        }
      }
    }
  }

  static Future<NOverlayImage> _createOverlayImage(
    String imageFilePath,
    BuildContext context,
  ) async {
    final filePath = await imageFilePath.getFilePath();
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

  static NCircleOverlay _createCircleMarker(String id, NLatLng location) {
    return NCircleOverlay(
      id: '${id}_circle',
      center: location,
      radius: 100,
      color: ColorStyles.primary.withOpacity(0.5),
      outlineWidth: 3,
      outlineColor: Colors.white,
    )..setGlobalZIndex(300000);
  }

  static Future<NMarker> _createErrorMarker(
    String markerId,
    NLatLng currentLocation,
    BuildContext context,
  ) async {
    final errorIcon = await NOverlayImage.fromWidget(
      context: context,
      widget: const AppImagePlaceholder(width: 48, height: 48),
      size: const Size(48, 48),
    );

    return NMarker(
      id: markerId,
      position: currentLocation,
      icon: errorIcon,
    );
  }
}
