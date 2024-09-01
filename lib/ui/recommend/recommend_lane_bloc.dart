import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:gyeonggi_express/data/repository/trip_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/recommend_lane_response.dart';
import '../../data/models/trip_theme.dart';

final class RecommendLaneState {
  final bool isLoading;

  final int selectedDays;
  final List<SigunguCode> selectedSigunguCodes;
  final List<TripTheme> selectedTripThemes;

  final RecommendedLaneResponse data;

  RecommendLaneState({
    required this.isLoading,
    required this.selectedDays,
    required this.selectedSigunguCodes,
    required this.selectedTripThemes,
    required this.data,
  });

  factory RecommendLaneState.initial() {
    return RecommendLaneState(
      isLoading: false,
      selectedDays: 0,
      selectedSigunguCodes: [],
      selectedTripThemes: [],
      data: RecommendedLaneResponse(
        travelPlan: TravelPlan(
          title: '',
          description: '',
          days: [],
        ),
        laneSpecificResponse: {},
        id: 0,
      ),
    );
  }

  RecommendLaneState copyWith({
    bool? isLoading,
    int? selectedDays,
    List<SigunguCode>? selectedSigunguCodes,
    List<TripTheme>? selectedTripThemes,
    RecommendedLaneResponse? data,
  }) {
    return RecommendLaneState(
      isLoading: isLoading ?? this.isLoading,
      selectedDays: selectedDays ?? this.selectedDays,
      selectedSigunguCodes: selectedSigunguCodes ?? this.selectedSigunguCodes,
      selectedTripThemes: selectedTripThemes ?? this.selectedTripThemes,
      data: data ?? this.data,
    );
  }
}

sealed class RecommendLaneEvent { }
final class RecommendLaneSelectDays extends RecommendLaneEvent {
  final int days;

  RecommendLaneSelectDays(this.days);
}
final class RecommendLaneSelectSigunguCodes extends RecommendLaneEvent {
  final List<SigunguCode> sigunguCodes;

  RecommendLaneSelectSigunguCodes(this.sigunguCodes);
}
final class RecommendLaneSelectTripThemes extends RecommendLaneEvent {
  final List<TripTheme> tripThemes;

  RecommendLaneSelectTripThemes(this.tripThemes);
}
final class RecommendLaneInitialize extends RecommendLaneEvent {}

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
    on<RecommendLaneSelectDays>(_onSelectDays);
    on<RecommendLaneSelectSigunguCodes>(_onSelectSigunguCodes);
    on<RecommendLaneSelectTripThemes>(_onSelectTripThemes);
    on<RecommendLaneInitialize>(_onInitialize);
  }

  void _onSelectDays(
    RecommendLaneSelectDays event,
    Emitter<RecommendLaneState> emit
  ) {
    emit(state.copyWith(selectedDays: event.days));
  }

  void _onSelectSigunguCodes(
    RecommendLaneSelectSigunguCodes event,
    Emitter<RecommendLaneState> emit
  ) {
    emit(state.copyWith(selectedSigunguCodes: event.sigunguCodes));
  }

  void _onSelectTripThemes(
    RecommendLaneSelectTripThemes event,
    Emitter<RecommendLaneState> emit
  ) {
    emit(state.copyWith(selectedTripThemes: event.tripThemes));
  }

  void _onInitialize(
    RecommendLaneInitialize event,
    Emitter<RecommendLaneState> emit
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _tripRepository.getRecommendedLane(
        days: state.selectedDays,
        sigunguCodes: state.selectedSigunguCodes,
        tripThemes: state.selectedTripThemes,
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