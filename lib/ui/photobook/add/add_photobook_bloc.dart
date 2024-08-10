import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../data/models/request/add_photobook_request.dart';

final class AddPhotobookState {
  final bool isLoading;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<AddPhotoItem>? photos;

  AddPhotobookState({
    required this.isLoading,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.photos,
  });

  factory AddPhotobookState.initial() {
    return AddPhotobookState(
      isLoading: false,
      title: "",
      startDate: null,
      endDate: null,
      photos: [],
    );
  }

  AddPhotobookState copyWith({
    bool? isLoading,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    List<AddPhotoItem>? photos,
  }) {
    return AddPhotobookState(
      isLoading: isLoading ?? this.isLoading,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      photos: photos ?? this.photos,
    );
  }
}

sealed class AddPhotobookEvent {}

final class AddPhotobookInitialize extends AddPhotobookEvent {
  final String title;
  final DateTime startDate;
  final DateTime endDate;

  AddPhotobookInitialize({
    required this.title,
    required this.startDate,
    required this.endDate,
  });
}

sealed class AddPhotobookSideEffect {}

class AddPhotobookBloc
    extends SideEffectBloc<AddPhotobookEvent, AddPhotobookState, AddPhotobookSideEffect> {
  AddPhotobookBloc() : super(AddPhotobookState.initial()) {
    on<AddPhotobookInitialize>(_onInitialize);
  }

  void _onInitialize(
      AddPhotobookInitialize event,
      Emitter<AddPhotobookState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final photos = await scanPhotos(event.startDate, event.endDate);
      emit(state.copyWith(
        isLoading: false,
        title: event.title,
        startDate: event.startDate,
        endDate: event.endDate,
        photos: photos,
      ));

      print("Photos scanned successfully: $photos");
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      print("Failed to scan photos: $e");
    }
  }

  Future<List<AddPhotoItem>> scanPhotos(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Request permission before accessing the photos
      PermissionStatus status = await Permission.photos.request();
      if (!status.isGranted) {
        print("Permission denied.");
        return [];
      }

      List<AssetPathEntity> albums =
      await PhotoManager.getAssetPathList(type: RequestType.image);
      List<AddPhotoItem> photos = [];

      for (var album in albums) {
        int albumCount = await album.assetCountAsync;
        if (albumCount > 0) {
          int batchSize = 100;
          for (int i = 0; i < albumCount; i += batchSize) {
            int end = (i + batchSize > albumCount) ? albumCount : i + batchSize;
            List<AssetEntity> albumPhotos =
            await album.getAssetListRange(start: i, end: end);

            for (var asset in albumPhotos) {
              DateTime assetDate = asset.createDateTime;
              if ((assetDate.isAfter(startDate) ||
                  assetDate.isAtSameMomentAs(startDate)) &&
                  (assetDate.isBefore(endDate) ||
                      assetDate.isAtSameMomentAs(endDate))) {
                File? file = await asset.file;
                if (file != null) {
                  final filePath = await filePathToFile(file.path);
                  final item = AddPhotoItem(
                      timestamp: assetDate.toString(),
                      latitude: asset.latitude ?? 0,
                      longitude: asset.longitude ?? 0,
                      path: filePath);
                  print("Photo found: ${item.toString()}");

                  photos.add(item);
                }
              }
            }
          }
        }
      }

      return photos;
    } catch (e) {
      print("Error scanning photos: $e");
      return [];
    }
  }

  Future<String> filePathToFile(String relativePath) async {
    if (Platform.isIOS) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final appDirPath = appDocDir.parent.path; // Get the parent directory of the Documents directory
      final filePath = '$appDirPath/tmp/$relativePath';
      return filePath;
    } else {
      return relativePath;
    }
  }
}
