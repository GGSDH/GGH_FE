import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/response/lane_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_summary_response.dart';
import 'package:gyeonggi_express/data/repository/favorite_repository.dart';

abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<TourAreaSummary> tourAreas;
  final List<Lane> lanes;

  FavoritesLoaded({required this.tourAreas, required this.lanes});
}

class FavoritesError extends FavoritesState {
  final String message;
  final String code;

  FavoritesError({required this.message, required this.code});
}

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoriteRepository repository;

  FavoritesBloc({required this.repository}) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoading());
    try {
      final tourAreasResult = await repository.getFavoriteTourAreas();
      final lanesResult = await repository.getFavoriteLanes();

      final tourAreas = tourAreasResult.when(
        success: (data) => data,
        apiError: (errorMessage, errorCode) =>
            throw Exception('Tour Areas: $errorMessage'),
      );

      final lanes = lanesResult.when(
        success: (data) => data,
        apiError: (errorMessage, errorCode) =>
            throw Exception('Lanes: $errorMessage'),
      );

      emit(FavoritesLoaded(tourAreas: tourAreas, lanes: lanes));
    } catch (e) {
      emit(FavoritesError(message: e.toString(), code: 'UNKNOWN'));
    }
  }
}
