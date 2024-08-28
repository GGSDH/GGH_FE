import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/repository/photobook_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../data/models/response/photobook_response.dart';

final class AddPhotoTicketState {
  final bool isLoading;
  final String title;
  final String startDate;
  final String endDate;
  final String location;
  final String selectedPhotoPath;
  final String selectedPhotoId;

  AddPhotoTicketState({
    required this.isLoading,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.selectedPhotoPath,
    required this.selectedPhotoId,
  });

  factory AddPhotoTicketState.initial() {
    return AddPhotoTicketState(
      isLoading: false,
      title: "",
      startDate: "",
      endDate: "",
      location: "",
      selectedPhotoPath: "",
      selectedPhotoId: "",
    );
  }

  AddPhotoTicketState copyWith({
    bool? isLoading,
    String? title,
    String? startDate,
    String? endDate,
    String? location,
    String? selectedPhotoPath,
    String? selectedPhotoId,
  }) {
    return AddPhotoTicketState(
      isLoading: isLoading ?? this.isLoading,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      selectedPhotoPath: selectedPhotoPath ?? this.selectedPhotoPath,
      selectedPhotoId: selectedPhotoId ?? this.selectedPhotoId,
    );
  }
}

sealed class AddPhotoTicketEvent { }
final class AddPhotoTicketInitialize extends AddPhotoTicketEvent {
  final String title;
  final String startDate;
  final String endDate;
  final String location;
  final String selectedPhotoPath;
  final String selectedPhotoId;

  AddPhotoTicketInitialize(
    this.title,
    this.startDate,
    this.endDate,
    this.location,
    this.selectedPhotoPath,
    this.selectedPhotoId,
  );
}
final class UploadPhotoTicket extends AddPhotoTicketEvent {
  final String photoId;

  UploadPhotoTicket(this.photoId);
}

sealed class AddPhotoTicketSideEffect { }
final class UploadPhotoTicketComplete extends AddPhotoTicketSideEffect { }
final class AddPhotoTicketShowError extends AddPhotoTicketSideEffect {
  final String message;

  AddPhotoTicketShowError(this.message);
}

class AddPhotoTicketBloc extends SideEffectBloc<AddPhotoTicketEvent, AddPhotoTicketState, AddPhotoTicketSideEffect> {
  final PhotobookRepository _photobookRepository;

  AddPhotoTicketBloc({
    required PhotobookRepository photobookRepository,
  }) : _photobookRepository = photobookRepository,
       super(AddPhotoTicketState.initial()) {
    on<AddPhotoTicketInitialize>(_onInitialize);
    on<UploadPhotoTicket>(_onUploadPhotoTicket);
  }

  void _onInitialize(
    AddPhotoTicketInitialize event,
    Emitter<AddPhotoTicketState> emit,
  ) async {
    emit(
      state.copyWith(
        title: event.title,
        startDate: event.startDate,
        endDate: event.endDate,
        location: event.location,
        selectedPhotoPath: event.selectedPhotoPath,
        selectedPhotoId: event.selectedPhotoId,
      )
    );
  }

  void _onUploadPhotoTicket(
    UploadPhotoTicket event,
    Emitter<AddPhotoTicketState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _photobookRepository.addPhotoTicket(event.photoId);

      response.when(
        success: (data) {
          produceSideEffect(UploadPhotoTicketComplete());
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(AddPhotoTicketShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(AddPhotoTicketShowError(e.toString()));
    }
  }
}