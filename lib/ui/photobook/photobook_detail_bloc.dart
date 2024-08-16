import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/response/add_photobook_response.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

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
  final String dominantLocationCity;

  PhotobookDetailState({
    required this.isLoading,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.photobookDetailCards,
    required this.dominantLocationCity,
  });

  factory PhotobookDetailState.initial() {
    return PhotobookDetailState(
      isLoading: false,
      title: "",
      startDate: "",
      endDate: "",
      photobookDetailCards: [],
      dominantLocationCity: ""
    );
  }

  PhotobookDetailState copyWith({
    bool? isLoading,
    String? title,
    String? startDate,
    String? endDate,
    List<PhotobookDetailCard>? photobookDetailCards,
    String? dominantLocationCity
  }) {
    return PhotobookDetailState(
      isLoading: isLoading ?? this.isLoading,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      photobookDetailCards: photobookDetailCards ?? this.photobookDetailCards,
      dominantLocationCity: dominantLocationCity ?? this.dominantLocationCity,
    );
  }
}

sealed class PhotobookDetailEvent { }
final class PhotobookDetailInitialize extends PhotobookDetailEvent {
  final int photobookId;

  PhotobookDetailInitialize(this.photobookId);
}

sealed class PhotobookDetailSideEffect { }
final class PhotobookDetailShowError extends PhotobookDetailSideEffect {
  final String message;

  PhotobookDetailShowError(this.message);
}

class PhotobookDetailBloc extends SideEffectBloc<PhotobookDetailEvent, PhotobookDetailState, PhotobookDetailSideEffect> {
  final PhotobookRepository _photobookRepository;

  PhotobookDetailBloc({
    required PhotobookRepository photobookRepository,
  }) : _photobookRepository = photobookRepository,
       super(PhotobookDetailState.initial()) {
    on<PhotobookDetailInitialize>(_onPhotobookDetailInitialize);
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
          final Map<String, int> locationFrequency = {};

          final List<PhotobookDetailCard> cards = data.dailyPhotoGroup.expand((dailyGroup) {
            return dailyGroup.hourlyPhotoGroups.map((hourlyGroup) {
              if (hourlyGroup.dominantLocation != null) {
                final locationKey = hourlyGroup.dominantLocation!.city ?? "알 수 없는 도시";

                if (locationFrequency.containsKey(locationKey)) {
                  locationFrequency[locationKey] = locationFrequency[locationKey]! + 1;
                } else {
                  locationFrequency[locationKey] = 1;
                }
              }

              // hourlyPhotoGroup에서 첫 번째 사진을 선택하여 PhotobookDetailCard 생성
              final firstPhoto = hourlyGroup.photos.first;

              return PhotobookDetailCard(
                id: firstPhoto.id,
                date: hourlyGroup.dateTime,
                title: hourlyGroup.dominantLocation?.name ?? "알 수 없는 도시",
                location: hourlyGroup.dominantLocation,
                filePathUrl: firstPhoto.path,
              );
            }).toList(); // null이 아닌 카드만 필터링하고 캐스팅
          }).toList();

          // 빈도가 가장 높은 위치를 찾기
          String? mostFrequentLocation;
          int highestFrequency = 0;

          locationFrequency.forEach((location, frequency) {
            if (frequency > highestFrequency) {
              highestFrequency = frequency;
              mostFrequentLocation = location;
            }
          });

          emit(
            state.copyWith(
              isLoading: false,
              title: data.title,
              startDate: data.startDate,
              endDate: data.endDate,
              dominantLocationCity: mostFrequentLocation ?? "알 수 없는 도시",
              photobookDetailCards: cards,
            ),
          );
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