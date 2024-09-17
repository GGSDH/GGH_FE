import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../data/models/request/add_photobook_request.dart';
import '../../../data/repository/photobook_repository.dart';

final class AddPhotobookState {
  final bool isLoading;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;

  AddPhotobookState({
    required this.isLoading,
    required this.title,
    required this.startDate,
    required this.endDate,
  });

  factory AddPhotobookState.initial() {
    return AddPhotobookState(
      isLoading: false,
      title: "",
      startDate: null,
      endDate: null,
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
      endDate: endDate ?? this.endDate
    );
  }
}

sealed class AddPhotobookEvent {}

final class AddPhotobookUpload extends AddPhotobookEvent {
  final String title;
  final DateTime startDate;
  final DateTime endDate;

  AddPhotobookUpload({
    required this.title,
    required this.startDate,
    required this.endDate,
  });
}

sealed class AddPhotobookSideEffect {}
final class AddPhotobookComplete extends AddPhotobookSideEffect {
  final int photobookId;

  AddPhotobookComplete(this.photobookId);
}
final class AddPhotobookShowError extends AddPhotobookSideEffect {
  final String message;

  AddPhotobookShowError(this.message);
}

class AddPhotobookBloc extends SideEffectBloc<AddPhotobookEvent, AddPhotobookState, AddPhotobookSideEffect> {
  final PhotobookRepository _photobookRepository;

  AddPhotobookBloc({
    required PhotobookRepository photobookRepository,
  }) : _photobookRepository = photobookRepository,
        super(AddPhotobookState.initial()) {
    on<AddPhotobookUpload>(_onInitialize);
  }

  void _onInitialize(
    AddPhotobookUpload event,
    Emitter<AddPhotobookState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final photos = await scanPhotos(event.startDate, event.endDate);

      final response = await _photobookRepository.addPhotobook(
        title: event.title,
        startDate: event.startDate.toString(),
        endDate: event.endDate.toString(),
        photos: photos,
      );

      response.when(
        success: (data) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(AddPhotobookComplete(data.id));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(AddPhotobookShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(AddPhotobookShowError(e.toString()));
    }
  }

  Future<List<AddPhotoItem>> scanPhotos(DateTime startDate, DateTime endDate) async {
    try {
      // 사진 권한 확인
      PermissionStatus status = await Permission.photos.request();
      if (!status.isGranted) {
        produceSideEffect(AddPhotobookShowError("사진 권한을 허용해주세요"));
        return [];
      }

      // 앨범 목록 가져오기
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.image);
      if (albums.isEmpty) return [];

      List<AddPhotoItem> photos = [];
      Set<String> uniquePaths = {}; // 중복된 파일 경로를 체크하기 위한 Set

      for (var album in albums) {
        int albumCount = await album.assetCountAsync;

        // 배치 크기 설정
        int batchSize = 100;
        for (int i = 0; i < albumCount; i += batchSize) {
          int end = (i + batchSize > albumCount) ? albumCount : i + batchSize;
          List<AssetEntity> albumPhotos = await album.getAssetListRange(start: i, end: end);

          for (var asset in albumPhotos) {
            DateTime assetDate = asset.createDateTime;

            // 날짜 필터링
            if ((assetDate.isAfter(startDate) || assetDate.isAtSameMomentAs(startDate)) &&
                (assetDate.isBefore(endDate) || assetDate.isAtSameMomentAs(endDate))) {

              // 파일 로드 전에 중복 확인
              File? file = await asset.file;
              if (file != null) {
                final filePath = extractRelativePath(file.path);

                // 중복된 파일 경로가 아닐 경우에만 처리
                if (!uniquePaths.contains(filePath)) {
                  uniquePaths.add(filePath);

                  final latLng = await asset.latlngAsync();

                  if (latLng.latitude == null || latLng.longitude == null) {
                    continue;
                  }

                  // 사진 메타데이터와 파일 경로를 AddPhotoItem으로 추가
                  final item = AddPhotoItem(
                    timestamp: assetDate.toString(),
                    latitude: latLng.latitude!,
                    longitude: latLng.longitude!,
                    path: filePath,
                  );
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

  String extractRelativePath(String filePath) {
    if (Platform.isIOS) {
      final startIndex = filePath.indexOf('flutter-images');
      return filePath.substring(startIndex);
    } else {
      return filePath;
    }
  }
}