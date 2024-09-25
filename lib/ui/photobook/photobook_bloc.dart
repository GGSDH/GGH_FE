import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/util/event_bus.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/photo_ticket_response.dart';
import '../../data/models/response/photobook_response.dart';
import '../../data/repository/photobook_repository.dart';

final class PhotobookState {
  final bool isLoading;
  final List<PhotobookResponse> photobooks;
  final List<PhotoTicketResponse> photoTickets;

  PhotobookState({
    required this.isLoading,
    required this.photobooks,
    required this.photoTickets,
  });

  factory PhotobookState.initial() {
    return PhotobookState(
      isLoading: false,
      photobooks: [],
      photoTickets: []
    );
  }

  PhotobookState copyWith({
    bool? isLoading,
    List<PhotobookResponse>? photobooks,
    List<PhotoTicketResponse>? photoTickets,
  }) {
    return PhotobookState(
      isLoading: isLoading ?? this.isLoading,
      photobooks: photobooks ?? this.photobooks,
      photoTickets: photoTickets ?? this.photoTickets,
    );
  }
}

sealed class PhotobookEvent { }
final class FetchPhotobooks extends PhotobookEvent { }
final class FetchPhotoTickets extends PhotobookEvent { }
final class PhotobookAdded extends PhotobookEvent {
  final PhotobookResponse photobook;

  PhotobookAdded(this.photobook);
}
final class PhotobookRemoved extends PhotobookEvent {
  final int photobookId;

  PhotobookRemoved(this.photobookId);
}
final class ShowPhotobookBottomSheet extends PhotobookEvent { }

sealed class PhotobookSideEffect { }
final class PhotobookShowBottomSheet extends PhotobookSideEffect {
  final List<PhotobookResponse> photobooks;

  PhotobookShowBottomSheet(this.photobooks);
}
final class PhotobookShowError extends PhotobookSideEffect {
  final String message;

  PhotobookShowError(this.message);
}

class PhotobookBloc extends SideEffectBloc<PhotobookEvent, PhotobookState, PhotobookSideEffect> {
  final PhotobookRepository _photobookRepository;

  PhotobookBloc({
    required PhotobookRepository photobookRepository,
  }) : _photobookRepository = photobookRepository,
       super(PhotobookState.initial()) {
    EventBus().on<PhotobookAddEvent>().listen((event) {
      add(PhotobookAdded(event.photobook));
    });
    EventBus().on<PhotobookRemoveEvent>().listen((event) {
      add(PhotobookRemoved(event.photobookId));
    });

    on<FetchPhotobooks>(_onFetchPhotobooks);
    on<FetchPhotoTickets>(_onFetchPhotoTickets);
    on<PhotobookAdded>(_onPhotobookAdded);
    on<PhotobookRemoved>(_onPhotobookRemoved);
    on<ShowPhotobookBottomSheet>(_onShowPhotobookBottomSheet);
  }

  void _onFetchPhotobooks(
    FetchPhotobooks event,
    Emitter<PhotobookState> emit
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _photobookRepository.getPhotobooks();

      response.when(
          success: (data) {
            emit(
                state.copyWith(
                  isLoading: false,
                  photobooks: data,
                )
            );
            if (state.photobooks.isNotEmpty) produceSideEffect(PhotobookShowBottomSheet(state.photobooks));
          },
          apiError: (errorMessage, errorCode) {
            emit(state.copyWith(isLoading: false));
            produceSideEffect(PhotobookShowError(errorMessage));
          }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(PhotobookShowError(e.toString()));
    }
  }

  void _onFetchPhotoTickets(
    FetchPhotoTickets event,
    Emitter<PhotobookState> emit
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _photobookRepository.getPhotoTickets();

      response.when(
          success: (data) {
            emit(
                state.copyWith(
                  isLoading: false,
                  photoTickets: data,
                )
            );
          },
          apiError: (errorMessage, errorCode) {
            emit(state.copyWith(isLoading: false));
            produceSideEffect(PhotobookShowError(errorMessage));
          }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(PhotobookShowError(e.toString()));
    }
  }

  void _onPhotobookAdded(
    PhotobookAdded event,
    Emitter<PhotobookState> emit
  ) {
    emit(state.copyWith(
      photobooks: [...state.photobooks, event.photobook]
    ));
    produceSideEffect(PhotobookShowBottomSheet(state.photobooks));
  }

  void _onPhotobookRemoved(
    PhotobookRemoved event,
    Emitter<PhotobookState> emit
  ) {
    emit(state.copyWith(
      photobooks: state.photobooks.where((photobook) => photobook.id != event.photobookId).toList()
    ));
    produceSideEffect(PhotobookShowBottomSheet(state.photobooks));
  }

  void _onShowPhotobookBottomSheet(
    ShowPhotobookBottomSheet event,
    Emitter<PhotobookState> emit
  ) {
    produceSideEffect(PhotobookShowBottomSheet(state.photobooks));
  }
}