import 'package:flutter_bloc/flutter_bloc.dart';
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
final class PhotobookInitialize extends PhotobookEvent { }

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
    on<PhotobookInitialize>(_onPhotobookInitialize);
  }

  void _onPhotobookInitialize(
    PhotobookInitialize event,
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
          produceSideEffect(PhotobookShowBottomSheet(state.photobooks));
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
            print('load phototickets');
            print('errorMessage: $errorMessage, errorCode: $errorCode');

            emit(state.copyWith(isLoading: false));
            produceSideEffect(PhotobookShowError(errorMessage));
          }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(PhotobookShowError(e.toString()));
    }
  }
}