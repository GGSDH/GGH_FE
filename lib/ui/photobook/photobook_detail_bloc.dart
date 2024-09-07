import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/photobook_response.dart';
import '../../data/repository/photobook_repository.dart';

final class PhotobookDetailCard {
  final String id;
  final String date;
  final String title;
  final LocationItem? location;
  final String filePathUrl;

  PhotobookDetailCard({
    required this.id,
    required this.date,
    required this.title,
    required this.location,
    required this.filePathUrl,
  });
}

final class PhotobookDetailState {
  final bool isLoading;
  final String title;
  final String startDate;
  final String endDate;
  final List<PhotobookDetailCard> photobookDetailCards;
  final List<DailyPhotoGroup> photobookDailyPhotoGroups;
  final String? dominantLocationCity;

  PhotobookDetailState({
    required this.isLoading,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.photobookDetailCards,
    required this.photobookDailyPhotoGroups,
    required this.dominantLocationCity,
  });

  factory PhotobookDetailState.initial() {
    return PhotobookDetailState(
      isLoading: false,
      title: "",
      startDate: "",
      endDate: "",
      photobookDetailCards: [],
      photobookDailyPhotoGroups: [],
      dominantLocationCity: ""
    );
  }

  PhotobookDetailState copyWith({
    bool? isLoading,
    String? title,
    String? startDate,
    String? endDate,
    List<PhotobookDetailCard>? photobookDetailCards,
    List<DailyPhotoGroup>? photobookDailyPhotoGroups,
    String? dominantLocationCity
  }) {
    return PhotobookDetailState(
      isLoading: isLoading ?? this.isLoading,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      photobookDetailCards: photobookDetailCards ?? this.photobookDetailCards,
      photobookDailyPhotoGroups: photobookDailyPhotoGroups ?? this.photobookDailyPhotoGroups,
      dominantLocationCity: this.dominantLocationCity,
    );
  }
}

sealed class PhotobookDetailEvent { }
final class PhotobookDetailInitialize extends PhotobookDetailEvent {
  final int photobookId;

  PhotobookDetailInitialize(this.photobookId);
}
final class PhotobookDelete extends PhotobookDetailEvent {
  final int photobookId;

  PhotobookDelete(this.photobookId);
}

sealed class PhotobookDetailSideEffect { }
final class PhotobookDetailShowError extends PhotobookDetailSideEffect {
  final String message;

  PhotobookDetailShowError(this.message);
}
final class PhotobookFetchComplete extends PhotobookDetailSideEffect { }
final class PhotobookDeleteComplete extends PhotobookDetailSideEffect { }

class PhotobookDetailBloc extends SideEffectBloc<PhotobookDetailEvent, PhotobookDetailState, PhotobookDetailSideEffect> {
  final PhotobookRepository _photobookRepository;

  PhotobookDetailBloc({
    required PhotobookRepository photobookRepository,
  }) : _photobookRepository = photobookRepository,
       super(PhotobookDetailState.initial()) {
    on<PhotobookDetailInitialize>(_onPhotobookDetailInitialize);
    on<PhotobookDelete>(_onDeletePhotobook);
  }

  void _onPhotobookDetailInitialize(
    PhotobookDetailInitialize event,
    Emitter<PhotobookDetailState> emit
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _photobookRepository.getPhotobookDetail(event.photobookId);

      response.when(
        success: (data) {
          final List<PhotobookDetailCard> cards = data.dailyPhotoGroup.map((dailyGroup) {
            // 각 day의 hourlyPhotoGroups의 첫 번째 항목만 선택
            final hourlyGroup = dailyGroup.hourlyPhotoGroups.first;
            final firstPhoto = hourlyGroup.photos.first;

            return PhotobookDetailCard(
              id: firstPhoto.id,
              date: dailyGroup.dateTime,
              title: hourlyGroup.dominantLocation?.name ?? "",
              location: hourlyGroup.dominantLocation,
              filePathUrl: firstPhoto.path,
            );
          }).toList();

          emit(
            state.copyWith(
              isLoading: false,
              title: data.title,
              startDate: data.startDate,
              endDate: data.endDate,
              photobookDailyPhotoGroups: data.dailyPhotoGroup,
              dominantLocationCity: data.location?.city,
              photobookDetailCards: cards,
            ),
          );
          produceSideEffect(PhotobookFetchComplete());
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(PhotobookDetailShowError(errorMessage));
        },
      );
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(PhotobookDetailShowError(e.toString()));
    }
  }

  void _onDeletePhotobook(
    PhotobookDelete event,
    Emitter<PhotobookDetailState> emit
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _photobookRepository.deletePhotobook(event.photobookId);

      response.when(
        success: (data) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(PhotobookDeleteComplete());
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(PhotobookDetailShowError(errorMessage));
        },
      );
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(PhotobookDetailShowError(e.toString()));
    }
  }
}