import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/repository/favorite_repository.dart';
import 'package:gyeonggi_express/util/event_bus.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/tour_area_response.dart';
import '../../data/models/sigungu_code.dart';
import '../../data/models/trip_theme.dart';
import '../../data/repository/trip_repository.dart';

class CategoryDetailState {
  final bool isLoading;
  final List<TourAreaResponse> tourAreas;
  final TripTheme selectedCategory;
  final List<SigunguCode> selectedSigunguCodes;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final bool hasReachedMax;

  CategoryDetailState({
    required this.isLoading,
    required this.tourAreas,
    required this.selectedCategory,
    required this.selectedSigunguCodes,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.hasReachedMax,
  });

  factory CategoryDetailState.initial() => CategoryDetailState(
        isLoading: false,
        tourAreas: [],
        selectedCategory: TripTheme.NATURAL,
        selectedSigunguCodes: [],
        totalCount: 0,
        pageNumber: 0,
        pageSize: 20,
        hasReachedMax: false,
      );

  CategoryDetailState copyWith({
    bool? isLoading,
    List<TourAreaResponse>? tourAreas,
    TripTheme? selectedCategory,
    List<SigunguCode>? selectedSigunguCodes,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    bool? hasReachedMax,
  }) {
    return CategoryDetailState(
      isLoading: isLoading ?? this.isLoading,
      tourAreas: tourAreas ?? this.tourAreas,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSigunguCodes: selectedSigunguCodes ?? this.selectedSigunguCodes,
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

sealed class CategoryDetailEvent {}
final class SelectCategory extends CategoryDetailEvent {
  final TripTheme tripTheme;
  SelectCategory(this.tripTheme);
}
final class SelectSigunguCodes extends CategoryDetailEvent {
  final List<SigunguCode> sigunguCodes;
  SelectSigunguCodes(this.sigunguCodes);
}
final class LoadMoreTourAreas extends CategoryDetailEvent {}
final class LikeTourArea extends CategoryDetailEvent {
  final int tourAreaId;
  LikeTourArea(this.tourAreaId);
}
final class UnlikeTourArea extends CategoryDetailEvent {
  final int tourAreaId;
  UnlikeTourArea(this.tourAreaId);
}
final class TourAreaLikeStatusChanged extends CategoryDetailEvent {
  final int tourAreaId;
  final bool isLiked;
  TourAreaLikeStatusChanged(this.tourAreaId, this.isLiked);
}

sealed class CategoryDetailSideEffect {}
final class CategoryDetailShowError extends CategoryDetailSideEffect {
  final String message;
  CategoryDetailShowError(this.message);
}

class CategoryDetailBloc extends SideEffectBloc<CategoryDetailEvent,
    CategoryDetailState, CategoryDetailSideEffect> {
  final TripRepository _tripRepository;
  final FavoriteRepository _favoriteRepository;

  CategoryDetailBloc({
    required TripRepository tripRepository,
    required FavoriteRepository favoriteRepository,
  })  : _tripRepository = tripRepository,
        _favoriteRepository = favoriteRepository,
        super(CategoryDetailState.initial()) {
    EventBus().on<ChangeStationLikeEvent>().listen((event) {
      add(TourAreaLikeStatusChanged(event.stationId, event.isLike));
    });

    on<SelectCategory>(_onSelectCategory);
    on<SelectSigunguCodes>(_onSelectSigunguCodes);
    on<LoadMoreTourAreas>(_onLoadMoreTourAreas);
    on<LikeTourArea>(_onLikeTourArea);
    on<UnlikeTourArea>(_onUnlikeTourArea);
    on<TourAreaLikeStatusChanged>(_onTourAreaLikeStatusChanged);
  }

  void _onTourAreaLikeStatusChanged(
    TourAreaLikeStatusChanged event,
    Emitter<CategoryDetailState> emit,
  ) {
    final updatedTourAreas = state.tourAreas.map((tourArea) {
      if (tourArea.tourAreaId == event.tourAreaId) {
        return tourArea.copyWith(likedByMe: event.isLiked, likeCount: event.isLiked ? tourArea.likeCount + 1 : tourArea.likeCount - 1);
      }
      return tourArea;
    }).toList();
    emit(state.copyWith(tourAreas: updatedTourAreas));
  }

  void _onSelectCategory(
    SelectCategory event,
    Emitter<CategoryDetailState> emit,
  ) async {
    emit(state.copyWith(
        isLoading: true, selectedCategory: event.tripTheme, pageNumber: 0));

    try {
      final response = await _tripRepository.getTourAreas(
        sigunguCodes: state.selectedSigunguCodes,
        tripTheme: state.selectedCategory,
        page: state.pageNumber,
      );

      response.when(
        success: (data) {
          emit(state.copyWith(
            isLoading: false,
            tourAreas: data.content,
            totalCount: data.totalElements,
            hasReachedMax: data.last,
          ));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(CategoryDetailShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(CategoryDetailShowError(e.toString()));
    }
  }

  void _onSelectSigunguCodes(
    SelectSigunguCodes event,
    Emitter<CategoryDetailState> emit,
  ) async {
    emit(state.copyWith(
        isLoading: true, selectedSigunguCodes: event.sigunguCodes));

    try {
      final response = await _tripRepository.getTourAreas(
        page: state.pageNumber,
        sigunguCodes: event.sigunguCodes,
        tripTheme: state.selectedCategory,
      );

      response.when(
        success: (data) {
          emit(state.copyWith(
            isLoading: false,
            tourAreas: data.content,
            totalCount: data.totalElements,
            hasReachedMax: data.last,
          ));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(CategoryDetailShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(CategoryDetailShowError(e.toString()));
    }
  }

  void _onLoadMoreTourAreas(
    LoadMoreTourAreas event,
    Emitter<CategoryDetailState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoading) return;

    emit(state.copyWith(isLoading: true));

    try {
      final response = await _tripRepository.getTourAreas(
        sigunguCodes: state.selectedSigunguCodes,
        tripTheme: state.selectedCategory,
        page: state.pageNumber + 1,
      );

      response.when(
        success: (data) {
          final hasReachedMax = data.last;
          emit(state.copyWith(
            isLoading: false,
            pageNumber: state.pageNumber + 1,
            tourAreas: List.from(state.tourAreas)..addAll(data.content),
            hasReachedMax: hasReachedMax,
            totalCount: data.totalElements,
          ));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(CategoryDetailShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(CategoryDetailShowError(e.toString()));
    }
  }

  void _onLikeTourArea(
    LikeTourArea event,
    Emitter<CategoryDetailState> emit,
  ) async {
    final result =
        await _favoriteRepository.addFavoriteTourArea(event.tourAreaId);
    result.when(
      success: (_) {
        final updatedTourAreas = state.tourAreas.map((tourArea) {
          if (tourArea.tourAreaId == event.tourAreaId) {
            return tourArea.copyWith(
              likeCount: tourArea.likeCount + 1,
              likedByMe: true,
            );
          }
          return tourArea;
        }).toList();
        emit(state.copyWith(tourAreas: updatedTourAreas));
        EventBus().fire(ChangeStationLikeEvent(event.tourAreaId, true));
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(
            CategoryDetailShowError('Failed to like tour area: $errorMessage'));
      },
    );
  }

  void _onUnlikeTourArea(
    UnlikeTourArea event,
    Emitter<CategoryDetailState> emit,
  ) async {
    final result =
        await _favoriteRepository.removeFavoriteTourArea(event.tourAreaId);
    result.when(
      success: (_) {
        final updatedTourAreas = state.tourAreas.map((tourArea) {
          if (tourArea.tourAreaId == event.tourAreaId) {
            return tourArea.copyWith(
              likeCount: tourArea.likeCount - 1,
              likedByMe: false,
            );
          }
          return tourArea;
        }).toList();
        emit(state.copyWith(tourAreas: updatedTourAreas));
        EventBus().fire(ChangeStationLikeEvent(event.tourAreaId, false));
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(CategoryDetailShowError(
            'Failed to unlike tour area: $errorMessage'));
      },
    );
  }
}
