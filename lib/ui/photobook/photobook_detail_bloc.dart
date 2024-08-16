import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/response/add_photobook_response.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/repository/photobook_repository.dart';

final class PhotobookDetailCard {
  final String date;
  final String title;
  final String location;
  final String filePathUrl;

  PhotobookDetailCard({
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
  final LocationItem? dominantLocation;

  PhotobookDetailState({
    required this.isLoading,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.photobookDetailCards,
    this.dominantLocation,
  });

  factory PhotobookDetailState.initial() {
    return PhotobookDetailState(
      isLoading: false,
      title: "",
      startDate: "",
      endDate: "",
      photobookDetailCards: [],
      dominantLocation: null,
    );
  }

  PhotobookDetailState copyWith({
    bool? isLoading,
    String? title,
    String? startDate,
    String? endDate,
    List<PhotobookDetailCard>? photobookDetailCards,
    LocationItem? dominantLocation,
  }) {
    return PhotobookDetailState(
      isLoading: isLoading ?? this.isLoading,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      photobookDetailCards: photobookDetailCards ?? this.photobookDetailCards,
      dominantLocation: dominantLocation ?? this.dominantLocation,
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
            print("$data");

            final List<PhotobookDetailCard> cards = data.dailyPhotoGroup.expand((dailyGroup) {
              return dailyGroup.hourlyPhotoGroups.expand((hourlyGroup) {
                return hourlyGroup.photos.map((photo) {
                  return PhotobookDetailCard(
                    date: hourlyGroup.dateTime,
                    title: hourlyGroup.dominantLocation?.name ?? "Unknown location",
                    location: hourlyGroup.dominantLocation?.city ?? "Unknown city",
                    filePathUrl: photo.path,
                  );
                }).toList();
              }).toList();
            }).toList();

            emit(
              state.copyWith(
                isLoading: false,
                title: data.title,
                startDate: data.startDate,
                endDate: data.endDate,
                photobookDetailCards: cards
              )
            );
          },
          apiError: (errorMessage, errorCode) {
            print(errorMessage);

            emit(state.copyWith(isLoading: false));
            produceSideEffect(PhotobookDetailShowError(errorMessage));
          }
      );
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(PhotobookDetailShowError(e.toString()));
    }
  }
}