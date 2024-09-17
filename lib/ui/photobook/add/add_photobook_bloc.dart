import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../data/models/request/add_photobook_request.dart';
import '../../../data/repository/photobook_repository.dart';
import '../../../util/isolate_util.dart';

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

      // Isolate를 사용한 병렬 처리
      final List<AddPhotoItem> photos = await computeIsolate(
        _filterPhotosByMetadata,
        _IsolatePhotoParams(startDate, endDate, albums),
      );

      return photos;
    } catch (e) {
      print("Error scanning photos: $e");
      return [];
    }
  }

  // 메타데이터로 필터링하여 필요한 파일만 로드하는 함수
  Future<List<AddPhotoItem>> _filterPhotosByMetadata(_IsolatePhotoParams params) async {
    List<AddPhotoItem> photos = [];
    Set<String> uniquePaths = {};

    for (var album in params.albums) {
      int albumCount = await album.assetCountAsync;
      int batchSize = 100;

      for (int i = 0; i < albumCount; i += batchSize) {
        int end = (i + batchSize > albumCount) ? albumCount : i + batchSize;
        List<AssetEntity> albumPhotos = await album.getAssetListRange(start: i, end: end);

        for (var asset in albumPhotos) {
          DateTime assetDate = asset.createDateTime;

          // 메타데이터로 날짜 필터링
          if ((assetDate.isAfter(params.startDate) || assetDate.isAtSameMomentAs(params.startDate)) &&
              (assetDate.isBefore(params.endDate) || assetDate.isAtSameMomentAs(params.endDate))) {

            // 필요한 메타데이터만 먼저 처리
            final latitude = asset.latitude ?? 0;
            final longitude = asset.longitude ?? 0;

            // 파일 로드 전에 경로 추출 및 중복 확인
            final filePath = asset.relativePath;  // 메타데이터 기반 파일 경로
            if (!uniquePaths.contains(filePath)) {
              uniquePaths.add(filePath!);

              // 필요한 사진만 파일을 로드
              File? file = await asset.file;
              if (file != null) {
                final item = AddPhotoItem(
                  timestamp: assetDate.toString(),
                  latitude: latitude,
                  longitude: longitude,
                  path: extractRelativePath(file.path),
                );
                photos.add(item);
              }
            }
          }
        }
      }
    }
    return photos;
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

class _IsolatePhotoParams {
  final DateTime startDate;
  final DateTime endDate;
  final List<AssetPathEntity> albums;

  _IsolatePhotoParams(this.startDate, this.endDate, this.albums);
}