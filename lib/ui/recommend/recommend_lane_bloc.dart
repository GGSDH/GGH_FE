import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:gyeonggi_express/data/repository/trip_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/recommended_lane_response.dart';
import '../../data/models/trip_theme.dart';

final class RecommendLaneState {
  final bool isLoading;

  final RecommendedLaneResponse data;

  RecommendLaneState({
    required this.isLoading,
    required this.data,
  });

  factory RecommendLaneState.initial() {
    return RecommendLaneState(
      isLoading: false,
      data: RecommendedLaneResponse(
        title: '',
        description: '',
        days: [],
        id: 0,
      ),
    );
  }

  RecommendLaneState copyWith({
    bool? isLoading,
    RecommendedLaneResponse? data,
  }) {
    return RecommendLaneState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}

sealed class RecommendLaneEvent { }
final class RecommendLaneInitialize extends RecommendLaneEvent {
  final int selectedDays;
  final List<SigunguCode> selectedSigunguCodes;
  final List<TripTheme> selectedTripThemes;

  RecommendLaneInitialize({
    required this.selectedDays,
    required this.selectedSigunguCodes,
    required this.selectedTripThemes,
  });
}

sealed class RecommendLaneSideEffect { }
final class RecommendLaneShowError extends RecommendLaneSideEffect {
  final String message;

  RecommendLaneShowError(this.message);
}

class RecommendLaneBloc extends SideEffectBloc<RecommendLaneEvent, RecommendLaneState, RecommendLaneSideEffect> {
  final TripRepository _tripRepository;

  RecommendLaneBloc({
    required TripRepository tripRepository,
  }) : _tripRepository = tripRepository,
        super(RecommendLaneState.initial()) {
    on<RecommendLaneInitialize>(_onInitialize);
  }

  void _onInitialize(
    RecommendLaneInitialize event,
    Emitter<RecommendLaneState> emit
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _tripRepository.getRecommendedLane(
        days: event.selectedDays,
        sigunguCodes: event.selectedSigunguCodes,
        tripThemes: event.selectedTripThemes,
      );

      response.when(
        success: (data) {
          emit(state.copyWith(isLoading: false, data: data));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(RecommendLaneShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(RecommendLaneShowError(e.toString()));
    }
  }
}