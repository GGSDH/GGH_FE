import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gyeonggi_express/data/models/response/lane_specific_response.dart';
import 'package:gyeonggi_express/ui/ext/file_path_extension.dart';
import 'package:image/image.dart' as img;

import '../data/models/response/photobook_response.dart';
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
        final currentLocation =
            NLatLng(photobook.location!.lat, photobook.location!.lon);
        pathCoords.add(currentLocation);

        try {
          final overlayImage =
              await _createOverlayImage(photobook.filePathUrl, context);
          final photobookMarker = NMarker(
            id: photobook.id,
            position: currentLocation,
            icon: overlayImage,
            size: const Size(48, 48),
          );
          controller.addOverlay(photobookMarker);

          log('Adding overlayImage for photobook ${photobook.id} at ${photobook.filePathUrl}');

          final circleMarker =
              _createCircleMarker(photobook.id, currentLocation);
          controller.addOverlay(circleMarker);

          log('Adding circleMarker for photobook ${photobook.id} at $currentLocation');
        } catch (e) {
          final errorMarker =
              await _createErrorMarker(photobook.id, currentLocation, context);
          controller.addOverlay(errorMarker);

          final circleMarker =
              _createCircleMarker(photobook.id, currentLocation);
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
    List<PhotobookResponse> photobooks,
    BuildContext context,
  ) async {
    for (var photobook in photobooks) {
      if (photobook.location?.lat != null && photobook.location?.lon != null) {
        final currentLocation = NLatLng(
          photobook.location!.lat,
          photobook.location!.lon,
        );

        try {
          final overlayImage = await _createOverlayImage(
              photobook.mainPhoto?.path ?? '', context);
          NMarker photobookMarker = NMarker(
            id: "${photobook.id}",
            position: currentLocation,
            icon: overlayImage,
            size: const Size(48, 48),
          );
          controller.addOverlay(photobookMarker);

          final circleMarker =
              _createCircleMarker("${photobook.id}", currentLocation);
          controller.addOverlay(circleMarker);
        } catch (e) {
          final errorMarker = await _createErrorMarker(
              "${photobook.id}", currentLocation, context);
          controller.addOverlay(errorMarker);

          final circleMarker =
              _createCircleMarker("${photobook.id}", currentLocation);
          controller.addOverlay(circleMarker);
        }
      }
    }
  }

  static Future<NOverlayImage> _createOverlayImage(
      String imageFilePath,
      BuildContext context,
      ) async {
    try {
      final filePath = await imageFilePath.getFilePath();
      final imageFile = File(filePath);

      if (await imageFile.exists()) {
        log('Creating overlay image from file: $imageFilePath');

        // 이미지 파일을 읽어오고 디코딩
        final imageBytes = await imageFile.readAsBytes();
        img.Image? image = img.decodeImage(imageBytes);

        if (image != null) {
          // 이미지 크기를 48x48로 리사이즈 (빠른 리사이징을 위해 simple 방식 사용)
          final resizedImage = img.copyResize(
            image,
            width: 48,
            height: 48,
            interpolation: img.Interpolation.average, // 빠른 리사이징을 위해 보간법 선택
          );

          // 리사이징한 이미지를 byteArray로 변환
          final resizedImageBytes = img.encodeJpg(resizedImage, quality: 70);  // 품질을 70으로 설정해 용량 줄임

          return NOverlayImage.fromByteArray(resizedImageBytes);
        } else {
          log('Failed to decode image: $imageFilePath');
          return _createPlaceholderOverlayImage(context);
        }
      } else {
        return _createPlaceholderOverlayImage(context);
      }
    } catch (e, stackTrace) {
      log('Error creating overlay image: $e', stackTrace: stackTrace);
      return _createPlaceholderOverlayImage(context);
    }
  }

  static Future<NOverlayImage> _createPlaceholderOverlayImage(
    BuildContext context,
  ) async {
    return await NOverlayImage.fromWidget(
      context: context,
      widget: const AppImagePlaceholder(width: 48, height: 48),
      size: const Size(48, 48),
    );
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

  static Future<void> addMarkersAndPathForLane(
    NaverMapController controller,
    List<LaneSpecificResponse> laneSpecificResponses,
    BuildContext context,
  ) async {
    List<NLatLng> pathCoords = [];

    // Sort the responses by sequence
    laneSpecificResponses.sort((a, b) => a.sequence.compareTo(b.sequence));

    for (var laneResponse in laneSpecificResponses) {
      final currentLocation = NLatLng(laneResponse.tourAreaResponse.latitude!,
          laneResponse.tourAreaResponse.longitude);
      pathCoords.add(currentLocation);

      try {
        final markerIcon =
            await _createSequenceMarker(laneResponse.sequence, context);
        final marker = NMarker(
          id: 'lane_${laneResponse.sequence}',
          position: currentLocation,
          icon: markerIcon,
          size: const Size(30, 30),
        );
        controller.addOverlay(marker);
      } catch (e) {
        print(
            'Error creating marker for sequence ${laneResponse.sequence}: $e');
        // You might want to add error handling here, similar to the original code
      }
        }

    if (pathCoords.isNotEmpty) {
      final pathOverlay = NPathOverlay(
        id: 'lane_path',
        coords: pathCoords,
        width: 2,
        color: ColorStyles.primary,
      );
      controller.addOverlay(pathOverlay);
    }
  }

  static Future<NOverlayImage> _createSequenceMarker(
    int sequence,
    BuildContext context,
  ) async {
    return NOverlayImage.fromWidget(
      context: context,
      widget: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ColorStyles.primary,
        ),
        child: Center(
          child: Text(
            sequence.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      size: const Size(48, 48),
    );
  }
}
